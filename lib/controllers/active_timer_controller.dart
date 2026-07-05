import 'dart:async';

import 'package:flow_fusion/enums/session_status.dart';
import 'package:flow_fusion/enums/timer_status.dart';
import 'package:flow_fusion/model/datasources/database/dao/focus_log_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_timer_dao.dart';
import 'package:flow_fusion/model/datasources/local/timer_state_store.dart';
import 'package:flow_fusion/model/entity/active_timer_state.dart';
import 'package:flow_fusion/model/entity/database/focus_log.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/model/entity/database/session_timer.dart';
import 'package:flow_fusion/ui/app/timer_alert_service.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

@lazySingleton
class ActiveTimerController with WidgetsBindingObserver {
  ActiveTimerController(
    this._sessionDao,
    this._timerDao,
    this._focusLogDao,
    this._stateStore,
    this._timerAlertService,
  );

  static const _tickInterval = Duration(seconds: 1);

  final SessionDao _sessionDao;
  final SessionTimerDao _timerDao;
  final FocusLogDao _focusLogDao;
  final TimerStateStore _stateStore;
  final TimerAlertService _timerAlertService;

  final ActiveTimerState _state = ActiveTimerState();

  Timer? _ticker;
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

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addObserver(this);
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
        ..runWorkMs = 0
        ..endsAt = DateTime.now().add(firstDuration);
    });
    _startTicker();
    await _persist();
  }

  Future<void> pause() async {
    if (!hasActiveSession || _state.isPaused) return;
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
    if (!hasActiveSession || _isFinalizingSession) return;
    final skipped = _state.currentTimer;
    if (skipped != null) {
      final actual = _resolveElapsed(skipped);
      _state.accrueWork(skipped, actual);
      await _markTimerSkipped(skipped, actual);
    }
    await _advanceToNextTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      runInAction(_syncRunningState);
      unawaited(_persist());
    }
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
    _stopTicker();
    _ticker = Timer.periodic(_tickInterval, (_) {
      runInAction(_syncRunningState);
      unawaited(_persist());
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void _syncRunningState() {
    if (_isFinalizingSession ||
        !hasActiveSession ||
        _state.isPaused ||
        _state.endsAt == null) {
      return;
    }

    final now = DateTime.now();
    final diff = _state.endsAt!.difference(now);
    if (diff > Duration.zero) {
      _state.remaining = diff;
      return;
    }

    _advanceAcrossElapsedTime(now.difference(_state.endsAt!));
  }

  void _advanceAcrossElapsedTime(Duration overshoot) {
    var extra = overshoot;

    while (_state.session != null) {
      final completedTimer = _state.currentTimer;
      final nextIndex = _state.currentIndex + 1;
      if (nextIndex >= _state.timers.length) {
        final sessionTitle =
            _state.session?.title ?? completedTimer?.title ?? '';
        unawaited(
          _finalizeSessionNaturally(
            completedTimer: completedTimer,
            sessionTitle: sessionTitle,
          ),
        );
        return;
      }

      _state.currentIndex = nextIndex;
      final nextTimer = _state.timers[_state.currentIndex];
      final nextDuration = nextTimer.plannedDuration;

      if (completedTimer != null) {
        _state.accrueWork(completedTimer, completedTimer.plannedDuration);
        unawaited(_markTimerCompleted(completedTimer));
        unawaited(
          _timerAlertService.notifyTimerFinished(
            timerTitle: completedTimer.title,
            nextTimerTitle: nextTimer.title,
          ),
        );
      }

      if (extra < nextDuration) {
        final nextRemaining = nextDuration - extra;
        _state
          ..remaining = nextRemaining
          ..endsAt = DateTime.now().add(nextRemaining);
        return;
      }

      extra -= nextDuration;
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

  Duration _resolveElapsed(SessionTimer timer) {
    final elapsed = timer.plannedDuration - _state.remaining;
    if (elapsed <= Duration.zero) return Duration.zero;
    if (elapsed >= timer.plannedDuration) return timer.plannedDuration;
    return elapsed;
  }
}
