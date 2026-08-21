import 'dart:async';

import 'package:flow_fusion/controllers/analytics_service.dart';
import 'package:flow_fusion/controllers/app_blocker_service.dart';
import 'package:flow_fusion/controllers/session_lifecycle_observer.dart';
import 'package:flow_fusion/controllers/site_blocker_service.dart';
import 'package:flow_fusion/controllers/session_ticker.dart';
import 'package:flow_fusion/controllers/session_timeline.dart';
import 'package:flow_fusion/enums/session_status.dart';
import 'package:flow_fusion/enums/timer_status.dart';
import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/model/entity/blocked_app.dart';
import 'package:flow_fusion/model/datasources/database/dao/focus_log_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_timer_dao.dart';
import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:flow_fusion/model/datasources/local/timer_state_store.dart';
import 'package:flow_fusion/model/entity/active_timer_state.dart';
import 'package:flow_fusion/model/entity/database/focus_log.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/model/entity/database/session_timer.dart';
import 'package:flow_fusion/ui/app/timer_alert_service.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

@lazySingleton
class ActiveTimerController {
  ActiveTimerController(
    this._sessionDao,
    this._timerDao,
    this._focusLogDao,
    this._stateStore,
    this._timerAlertService,
    this._prefs,
    this._appBlocker,
    this._siteBlocker,
    this._analytics,
  );

  final SessionDao _sessionDao;
  final SessionTimerDao _timerDao;
  final FocusLogDao _focusLogDao;
  final TimerStateStore _stateStore;
  final TimerAlertService _timerAlertService;
  final Prefs _prefs;
  final AppBlockerService _appBlocker;
  final SiteBlockerService _siteBlocker;
  final AnalyticsService _analytics;

  final ActiveTimerState _state = ActiveTimerState();

  final SessionTicker _ticker = SessionTicker();
  late final SessionLifecycleObserver _lifecycleObserver =
      SessionLifecycleObserver(_onLifecycleChange);
  bool _initialized = false;
  bool _isFinalizingSession = false;

  ActiveTimerState get state => _state;
  Session? get session => _state.session;
  List<SessionTimer> get timers => List.unmodifiable(_state.timers);
  int get currentIndex => _state.currentIndex;
  Duration get remaining => _state.remaining;
  bool get isPaused => _state.isPaused;
  bool get hasActiveSession => _state.hasActiveSession;
  int? get currentSessionId => _state.currentSessionId;
  SessionTimer? get currentTimer => _state.currentTimer;
  double get progress => _state.progress;
  String get formattedRemaining => _state.formattedRemaining;
  bool get awaitingManualAdvance => _state.awaitingManualAdvance;

  bool get _hasNextTimer => _state.currentIndex + 1 < _state.timers.length;

  void _syncBlockingForCurrentPhase() {
    final SessionTimer? timer = _state.currentTimer;
    final Session? session = _state.session;
    final bool inWorkPhase = hasActiveSession &&
        !_state.isPaused &&
        !_state.awaitingManualAdvance &&
        timer?.type == TimerType.work;

    final List<BlockedApp> apps = session?.blockedApps ?? const <BlockedApp>[];
    if (inWorkPhase && apps.isNotEmpty) {
      _appBlocker.startBlocking(apps);
    } else {
      _appBlocker.stopBlocking();
    }

    final List<String> sites = session?.blockedSites ?? const <String>[];
    if (inWorkPhase && sites.isNotEmpty) {
      unawaited(_siteBlocker.startBlocking(sites));
    } else {
      unawaited(_siteBlocker.stopBlocking());
    }
  }

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    _lifecycleObserver.start();
    unawaited(_siteBlocker.stopBlocking());
    unawaited(_siteBlocker.selfHeal());
    await _restore();
  }

  Future<void> startSession(Session session) async {
    final sessionId = session.id;
    if (sessionId == null) return;

    final timers = await _timerDao.findTimersBySessionId(sessionId);
    if (timers.isEmpty) return;

    runInAction(() {
      _isFinalizingSession = false;
      final firstDuration = timers.first.plannedDuration;
      _state
        ..session = session
        ..timers = timers
        ..currentIndex = 0
        ..remaining = firstDuration
        ..isPaused = false
        ..awaitingManualAdvance = false
        ..endsAt = DateTime.now().add(firstDuration);
    });
    _startTicker();
    _syncBlockingForCurrentPhase();
    await _persist();
    _analytics.trackEvent('session_started', {
      'has_task': session.taskId != null,
      'timers_count': timers.length,
      'has_blocked_apps': session.blockedApps.isNotEmpty,
      'has_blocked_sites': session.blockedSites.isNotEmpty,
    });
  }

  Future<void> setTask(int? taskId) async {
    final Session? session = _state.session;
    if (session == null) return;

    final Session updated = session.copyWith(
      taskId: taskId,
      clearTaskId: taskId == null,
    );
    // Update in-memory state before the awaited DB write so that a session
    // completion racing this call (e.g. the timer finishes while this write
    // is still in flight) reads the new taskId instead of a stale reference
    // and overwriting it back to null when it persists its own completion.
    runInAction(() => _state.session = updated);
    await _sessionDao.updateSession(updated);
  }

  Future<void> pause() async {
    if (!hasActiveSession || _state.isPaused || _state.awaitingManualAdvance) {
      return;
    }
    runInAction(() {
      _syncRunningState();
      _state
        ..isPaused = true
        ..endsAt = null;
    });
    _stopTicker();
    _syncBlockingForCurrentPhase();
    await _persist();
  }

  Future<void> resume() async {
    if (!hasActiveSession || !_state.isPaused) return;
    runInAction(() {
      _state
        ..isPaused = false
        ..endsAt = DateTime.now().add(_state.remaining);
    });
    _startTicker();
    _syncBlockingForCurrentPhase();
    await _persist();
  }

  Future<void> skipCurrentTimer() async {
    if (!hasActiveSession ||
        _isFinalizingSession ||
        _state.awaitingManualAdvance) {
      return;
    }
    final SessionTimer? skipped = _state.currentTimer;
    if (skipped != null) {
      final Duration actual = elapsedIn(
        skipped.plannedDuration,
        _state.remaining,
      );
      await _logWorkChunk(_state.session!, skipped, actual);
      await _markTimerSkipped(skipped, actual);
    }
    await _advanceToNextTimer();
  }

  Future<void> endSessionNow() async {
    if (!hasActiveSession || _isFinalizingSession) return;

    final SessionTimer? current = _state.currentTimer;
    if (current != null && !_state.awaitingManualAdvance) {
      final Duration actual = elapsedIn(
        current.plannedDuration,
        _state.remaining,
      );
      await _logWorkChunk(_state.session!, current, actual);
      await _markTimerSkipped(current, actual);
    }

    await _clearState(markSessionCompleted: true);
  }

  Future<void> advanceToNextPhaseManually() async {
    if (!hasActiveSession ||
        _isFinalizingSession ||
        !_state.awaitingManualAdvance) {
      return;
    }

    final int nextIndex = _state.currentIndex + 1;
    if (nextIndex >= _state.timers.length) {
      await _clearState(markSessionCompleted: true);
      return;
    }

    runInAction(() {
      final Duration nextDuration = _state.timers[nextIndex].plannedDuration;
      _state
        ..awaitingManualAdvance = false
        ..currentIndex = nextIndex
        ..remaining = nextDuration
        ..isPaused = false
        ..endsAt = DateTime.now().add(nextDuration);
    });
    _startTicker();
    _syncBlockingForCurrentPhase();
    await _persist();
  }

  void _onLifecycleChange() {
    runInAction(_syncRunningState);
    unawaited(_persist());
  }

  Future<void> _restore() async {
    final persisted = _stateStore.read();
    if (persisted == null) return;

    try {
      final session = await _sessionDao.findSessionById(persisted.sessionId);
      final timers = await _timerDao.findTimersBySessionId(persisted.sessionId);
      if (session == null ||
          timers.isEmpty ||
          persisted.currentIndex >= timers.length) {
        await _clearState();
        return;
      }

      if (persisted.awaitingManualAdvance) {
        runInAction(() {
          _state
            ..session = session
            ..timers = timers
            ..currentIndex = persisted.currentIndex
            ..isPaused = false
            ..remaining = Duration.zero
            ..endsAt = null
            ..awaitingManualAdvance = true;
        });
        return;
      }

      if (!persisted.isPaused && persisted.endsAtMs == null) {
        await _clearState();
        return;
      }

      var shouldStartTicker = false;
      runInAction(() {
        _state
          ..session = session
          ..timers = timers
          ..currentIndex = persisted.currentIndex
          ..isPaused = persisted.isPaused;

        if (persisted.isPaused) {
          _state
            ..remaining = remainingFromPersistedMs(
              persisted.remainingMs ?? 0,
              timers[persisted.currentIndex],
            )
            ..endsAt = null;
        } else {
          _state
            ..remaining = timers[persisted.currentIndex].plannedDuration
            ..endsAt = DateTime.fromMillisecondsSinceEpoch(persisted.endsAtMs!);
          _syncRunningState();
          shouldStartTicker = hasActiveSession && !_state.isPaused;
        }
      });

      if (shouldStartTicker) _startTicker();
      _syncBlockingForCurrentPhase();
    } catch (e, s) {
      AppLogger.error('ActiveTimerController.restore', e, s);
      await _clearState();
    }
  }

  void _startTicker() {
    _ticker.start(() {
      runInAction(_syncRunningState);
      unawaited(_persist());
    });
  }

  void _stopTicker() => _ticker.stop();

  void _syncRunningState() {
    if (_isFinalizingSession ||
        !hasActiveSession ||
        _state.isPaused ||
        _state.awaitingManualAdvance ||
        _state.endsAt == null) {
      return;
    }

    final now = DateTime.now();
    final diff = _state.endsAt!.difference(now);
    if (diff > Duration.zero) {
      _state.remaining = diff;
      return;
    }

    if (_prefs.manualPhaseSwitch && _hasNextTimer) {
      _enterManualHold();
      return;
    }

    _advanceAcrossElapsedTime(now.difference(_state.endsAt!));
  }

  void _enterManualHold() {
    final int completedIndex = _state.currentIndex;
    final SessionTimer completedTimer = _state.timers[completedIndex];
    final SessionTimer nextTimer = _state.timers[completedIndex + 1];
    final Session session = _state.session!;

    _state
      ..remaining = Duration.zero
      ..endsAt = null
      ..awaitingManualAdvance = true;
    _stopTicker();

    _syncBlockingForCurrentPhase();

    unawaited(
      _logWorkChunk(session, completedTimer, completedTimer.plannedDuration),
    );
    unawaited(_markTimerCompleted(completedTimer));
    unawaited(
      _timerAlertService.notifyTimerFinished(
        timerTitle: completedTimer.title,
        nextTimerTitle: nextTimer.title,
      ),
    );
  }

  void _advanceAcrossElapsedTime(Duration overshoot) {
    final Session session = _state.session!;
    final List<TimerTransition> transitions = planAdvance(
      overshoot: overshoot,
      currentIndex: _state.currentIndex,
      durations: <Duration>[
        for (final SessionTimer timer in _state.timers) timer.plannedDuration,
      ],
    );

    for (final TimerTransition transition in transitions) {
      switch (transition) {
        case TimerCompleted(:final int completedIndex, :final int nextIndex):
          final SessionTimer completedTimer = _state.timers[completedIndex];
          final SessionTimer nextTimer = _state.timers[nextIndex];
          _state.currentIndex = nextIndex;
          unawaited(
            _logWorkChunk(
              session,
              completedTimer,
              completedTimer.plannedDuration,
            ),
          );
          unawaited(_markTimerCompleted(completedTimer));
          unawaited(
            _timerAlertService.notifyTimerFinished(
              timerTitle: completedTimer.title,
              nextTimerTitle: nextTimer.title,
            ),
          );
        case SettleOn(:final int index, :final Duration remaining):
          _state
            ..currentIndex = index
            ..remaining = remaining
            ..endsAt = DateTime.now().add(remaining);
        case SessionFinished(:final int completedIndex):
          final SessionTimer completedTimer = _state.timers[completedIndex];
          final String sessionTitle =
              _state.session?.title ?? completedTimer.title;
          unawaited(
            _finalizeSessionNaturally(
              completedTimer: completedTimer,
              sessionTitle: sessionTitle,
            ),
          );
      }
    }
    _syncBlockingForCurrentPhase();
  }

  Future<void> _finalizeSessionNaturally({
    required SessionTimer? completedTimer,
    required String sessionTitle,
  }) async {
    if (_isFinalizingSession) return;
    _isFinalizingSession = true;
    _stopTicker();

    Session? session;
    runInAction(() {
      session = _state.session;
      _resetState();
    });

    try {
      if (completedTimer != null && session != null) {
        await _logWorkChunk(
          session!,
          completedTimer,
          completedTimer.plannedDuration,
        );
        await _markTimerCompleted(completedTimer);
      }
      if (session != null) {
        await _completeSession(session!);
      }
      unawaited(
        _timerAlertService.notifySessionFinished(sessionTitle: sessionTitle),
      );
    } finally {
      _isFinalizingSession = false;
    }
  }

  Future<void> _advanceToNextTimer() async {
    final nextIndex = _state.currentIndex + 1;
    if (nextIndex >= _state.timers.length) {
      await _clearState(markSessionCompleted: true);
      return;
    }

    runInAction(() {
      final nextDuration = _state.timers[nextIndex].plannedDuration;
      _state
        ..currentIndex = nextIndex
        ..remaining = nextDuration
        ..isPaused = false
        ..endsAt = DateTime.now().add(nextDuration);
    });
    _startTicker();
    _syncBlockingForCurrentPhase();
    await _persist();
  }

  Future<void> _markTimerCompleted(SessionTimer timer) async {
    await _timerDao.updateTimer(
      timer.copyWith(
        actualDurationMs: timer.plannedDuration.inMilliseconds,
        status: TimerStatus.completed,
        updatedAt: DateTime.now(),
      ),
    );
    _analytics.trackEvent('timer_completed', {
      'type': timer.type.name,
      'duration_mins': timer.plannedDuration.inMinutes,
    });
  }

  Future<void> _markTimerSkipped(SessionTimer timer, Duration actual) async {
    await _timerDao.updateTimer(
      timer.copyWith(
        actualDurationMs: actual.inMilliseconds,
        status: TimerStatus.skipped,
        updatedAt: DateTime.now(),
      ),
    );
    _analytics.trackEvent('timer_skipped', {
      'type': timer.type.name,
      'planned_mins': timer.plannedDuration.inMinutes,
      'actual_mins': actual.inMinutes,
    });
  }

  Future<void> _completeSession(Session session) async {
    await _sessionDao.updateSession(
      session.copyWith(
        status: SessionStatus.completed,
        completedAt: DateTime.now().toIso8601String(),
      ),
    );
    _analytics.trackEvent('session_completed', {
      'has_task': session.taskId != null,
    });
  }

  /// Logs one completed work timer's time immediately, tagged with the
  /// session's task *at that moment*. Sessions are reusable and their task
  /// tag can change mid-session, so logging per-timer (rather than once for
  /// the whole session at the end) keeps each chunk attributed to whatever
  /// task was actually selected while it ran.
  Future<void> _logWorkChunk(
    Session session,
    SessionTimer timer,
    Duration actual,
  ) async {
    if (timer.type != TimerType.work || actual <= Duration.zero) return;
    final sessionId = session.id;
    if (sessionId == null) return;
    await _focusLogDao.insertRun(
      FocusLog.create(
        sessionId: sessionId,
        workMs: actual.inMilliseconds,
        taskId: session.taskId,
      ),
    );
  }

  Future<void> _persist() async {
    final snapshot = _state.toPersistedState();
    if (snapshot == null) {
      _stateStore.clear();
      return;
    }
    _stateStore.write(snapshot);
  }

  Future<void> _clearState({bool markSessionCompleted = false}) async {
    _stopTicker();
    final session = _state.session;
    runInAction(_resetState);
    _isFinalizingSession = false;

    if (markSessionCompleted && session != null) {
      await _completeSession(session);
    }
  }

  void _resetState() {
    _appBlocker.stopBlocking();
    unawaited(_siteBlocker.stopBlocking());
    _state.reset();
    _stateStore.clear();
  }
}
