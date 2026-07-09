import 'dart:async';

import 'package:flow_fusion/controllers/session_lifecycle_observer.dart';
import 'package:flow_fusion/controllers/session_ticker.dart';
import 'package:flow_fusion/controllers/session_timeline.dart';
import 'package:flow_fusion/enums/session_status.dart';
import 'package:flow_fusion/enums/timer_status.dart';
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
  );

  final SessionDao _sessionDao;
  final SessionTimerDao _timerDao;
  final FocusLogDao _focusLogDao;
  final TimerStateStore _stateStore;
  final TimerAlertService _timerAlertService;
  final Prefs _prefs;

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

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    _lifecycleObserver.start();
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
        ..runWorkMs = 0
        ..endsAt = DateTime.now().add(firstDuration);
    });
    _startTicker();
    await _persist();
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
      _state.accrueWork(skipped, actual);
      await _markTimerSkipped(skipped, actual);
    }
    await _advanceToNextTimer();
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
            ..runWorkMs = persisted.runWorkMs
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
          ..isPaused = persisted.isPaused
          ..runWorkMs = persisted.runWorkMs;

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

    _state.accrueWork(completedTimer, completedTimer.plannedDuration);
    _state
      ..remaining = Duration.zero
      ..endsAt = null
      ..awaitingManualAdvance = true;
    _stopTicker();

    unawaited(_markTimerCompleted(completedTimer));
    unawaited(
      _timerAlertService.notifyTimerFinished(
        timerTitle: completedTimer.title,
        nextTimerTitle: nextTimer.title,
      ),
    );
  }

  void _advanceAcrossElapsedTime(Duration overshoot) {
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
          _state.accrueWork(completedTimer, completedTimer.plannedDuration);
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
  }

  Future<void> _finalizeSessionNaturally({
    required SessionTimer? completedTimer,
    required String sessionTitle,
  }) async {
    if (_isFinalizingSession) return;
    _isFinalizingSession = true;
    _stopTicker();

    Session? session;
    var workMs = 0;
    runInAction(() {
      if (completedTimer != null) {
        _state.accrueWork(completedTimer, completedTimer.plannedDuration);
      }
      session = _state.session;
      workMs = _state.runWorkMs;
      _resetState();
    });

    try {
      if (completedTimer != null) {
        await _markTimerCompleted(completedTimer);
      }
      if (session != null) {
        await _completeSession(session!, workMs: workMs);
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
    await _persist();
  }

  Future<void> _markTimerCompleted(SessionTimer timer) {
    return _timerDao.updateTimer(
      timer.copyWith(
        actualDurationMs: timer.plannedDuration.inMilliseconds,
        status: TimerStatus.completed,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> _markTimerSkipped(SessionTimer timer, Duration actual) {
    return _timerDao.updateTimer(
      timer.copyWith(
        actualDurationMs: actual.inMilliseconds,
        status: TimerStatus.skipped,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> _completeSession(Session session, {required int workMs}) async {
    await _sessionDao.updateSession(
      session.copyWith(
        status: SessionStatus.completed,
        completedAt: DateTime.now().toIso8601String(),
      ),
    );
    await _logCompletedRun(session, workMs: workMs);
  }

  Future<void> _logCompletedRun(Session session, {required int workMs}) async {
    final sessionId = session.id;
    if (sessionId == null) return;
    await _focusLogDao.insertRun(
      FocusLog.create(sessionId: sessionId, workMs: workMs),
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
    final workMs = _state.runWorkMs;
    runInAction(_resetState);
    _isFinalizingSession = false;

    if (markSessionCompleted && session != null) {
      await _completeSession(session, workMs: workMs);
    }
  }

  void _resetState() {
    _state.reset();
    _stateStore.clear();
  }
}
