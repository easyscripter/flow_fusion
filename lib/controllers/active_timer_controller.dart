import 'dart:async';

import 'package:flow_fusion/enums/session_status.dart';
import 'package:flow_fusion/enums/timer_status.dart';
import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/model/datasources/database/dao/focus_log_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_timer_dao.dart';
import 'package:flow_fusion/model/datasources/local/timer_state_store.dart';
import 'package:flow_fusion/model/entity/database/focus_log.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/model/entity/database/session_timer.dart';
import 'package:flow_fusion/model/entity/timer_persisted_state.dart';
import 'package:flow_fusion/ui/app/timer_alert_service.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ActiveTimerController extends ChangeNotifier with WidgetsBindingObserver {
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

  Timer? _ticker;
  bool _initialized = false;

  Session? _session;
  List<SessionTimer> _timers = const [];
  int _currentIndex = -1;
  Duration _remaining = Duration.zero;
  DateTime? _endsAt;
  bool _isPaused = false;

  int _runWorkMs = 0;

  Session? get session => _session;
  List<SessionTimer> get timers => List.unmodifiable(_timers);
  int get currentIndex => _currentIndex;
  Duration get remaining => _remaining;
  bool get isPaused => _isPaused;
  bool get hasActiveSession => _session != null && currentTimer != null;
  int? get currentSessionId => _session?.id;

  SessionTimer? get currentTimer {
    if (_currentIndex < 0 || _currentIndex >= _timers.length) return null;
    return _timers[_currentIndex];
  }

  double get progress {
    final timer = currentTimer;
    if (timer == null) return 0;
    final totalMs = timer.plannedDuration.inMilliseconds;
    if (totalMs <= 0) return 1;
    final doneMs = totalMs - _remaining.inMilliseconds;
    return (doneMs / totalMs).clamp(0, 1).toDouble();
  }

  String get formattedRemaining {
    final totalSeconds = _remaining.inSeconds.clamp(0, 599999);
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

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

    _session = session;
    _timers = timers;
    _currentIndex = 0;
    _remaining = timers.first.plannedDuration;
    _isPaused = false;
    _runWorkMs = 0;
    _endsAt = DateTime.now().add(_remaining);
    _startTicker();
    await _persist();
    notifyListeners();
  }

  Future<void> pause() async {
    if (!hasActiveSession || _isPaused) return;
    _syncRunningState();
    _isPaused = true;
    _endsAt = null;
    _stopTicker();
    await _persist();
    notifyListeners();
  }

  Future<void> resume() async {
    if (!hasActiveSession || !_isPaused) return;
    _isPaused = false;
    _endsAt = DateTime.now().add(_remaining);
    _startTicker();
    await _persist();
    notifyListeners();
  }

  Future<void> skipCurrentTimer() async {
    if (!hasActiveSession) return;
    final skipped = currentTimer;
    if (skipped != null) {
      final actualMs = (skipped.plannedDuration - _remaining).inMilliseconds;
      _accrueWork(skipped, Duration(milliseconds: actualMs));
      await _timerDao.updateTimer(
        SessionTimer(
          id: skipped.id,
          sessionId: skipped.sessionId,
          position: skipped.position,
          title: skipped.title,
          description: skipped.description,
          icon: skipped.icon,
          type: skipped.type,
          plannedDuration: skipped.plannedDuration,
          actualDurationMs: actualMs,
          status: TimerStatus.skipped,
          createdAt: skipped.createdAt,
          updatedAt: DateTime.now(),
        ),
      );
    }
    await _advanceToNextTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncRunningState(notify: true);
      unawaited(_persist());
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      _syncRunningState();
      unawaited(_persist());
    }
  }

  Future<void> _restore() async {
    final state = _stateStore.read();
    if (state == null) return;

    try {
      final session = await _sessionDao.findSessionById(state.sessionId);
      final timers = await _timerDao.findTimersBySessionId(state.sessionId);
      if (session == null ||
          timers.isEmpty ||
          state.currentIndex >= timers.length) {
        await _clearState();
        return;
      }

      _session = session;
      _timers = timers;
      _currentIndex = state.currentIndex;
      _isPaused = state.isPaused;
      _runWorkMs = state.runWorkMs;

      if (_isPaused) {
        _remaining = _durationFromMs(
          state.remainingMs ?? 0,
          timers[state.currentIndex],
        );
        _endsAt = null;
      } else {
        final endsAtMs = state.endsAtMs;
        if (endsAtMs == null) {
          await _clearState();
          return;
        }
        _remaining = timers[state.currentIndex].plannedDuration;
        _endsAt = DateTime.fromMillisecondsSinceEpoch(endsAtMs);
        _syncRunningState();
        if (hasActiveSession && !_isPaused) {
          _startTicker();
        }
      }

      notifyListeners();
    } catch (_) {
      await _clearState();
    }
  }

  void _startTicker() {
    _stopTicker();
    _ticker = Timer.periodic(_tickInterval, (_) {
      _syncRunningState(notify: true);
      unawaited(_persist());
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void _syncRunningState({bool notify = false}) {
    if (!hasActiveSession || _isPaused || _endsAt == null) return;

    final now = DateTime.now();
    final diff = _endsAt!.difference(now);
    if (diff > Duration.zero) {
      _remaining = diff;
      if (notify) notifyListeners();
      return;
    }

    _advanceAcrossElapsedTime(now.difference(_endsAt!), notify: notify);
  }

  void _advanceAcrossElapsedTime(Duration overshoot, {bool notify = false}) {
    var extra = overshoot;

    while (_session != null) {
      final completedTimer = currentTimer;
      final nextIndex = _currentIndex + 1;
      if (nextIndex >= _timers.length) {
        final sessionTitle = _session?.title ?? completedTimer?.title ?? '';
        unawaited(
          _finalizeSessionNaturally(
            completedTimer: completedTimer,
            sessionTitle: sessionTitle,
            notify: notify,
          ),
        );
        return;
      }

      _currentIndex = nextIndex;
      final nextTimer = _timers[_currentIndex];
      final nextDuration = _timers[_currentIndex].plannedDuration;

      if (completedTimer != null) {
        _accrueWork(completedTimer, completedTimer.plannedDuration);
        unawaited(
          _timerDao.updateTimer(
            SessionTimer(
              id: completedTimer.id,
              sessionId: completedTimer.sessionId,
              position: completedTimer.position,
              title: completedTimer.title,
              description: completedTimer.description,
              icon: completedTimer.icon,
              type: completedTimer.type,
              plannedDuration: completedTimer.plannedDuration,
              actualDurationMs: completedTimer.plannedDuration.inMilliseconds,
              status: TimerStatus.completed,
              createdAt: completedTimer.createdAt,
              updatedAt: DateTime.now(),
            ),
          ),
        );
        unawaited(
          _timerAlertService.notifyTimerFinished(
            timerTitle: completedTimer.title,
            nextTimerTitle: nextTimer.title,
          ),
        );
      }

      if (extra < nextDuration) {
        _remaining = nextDuration - extra;
        _endsAt = DateTime.now().add(_remaining);
        if (notify) notifyListeners();
        return;
      }

      extra -= nextDuration;
    }
  }

  Future<void> _finalizeSessionNaturally({
    required SessionTimer? completedTimer,
    required String sessionTitle,
    required bool notify,
  }) async {
    if (completedTimer != null) {
      _accrueWork(completedTimer, completedTimer.plannedDuration);
      await _timerDao.updateTimer(
        SessionTimer(
          id: completedTimer.id,
          sessionId: completedTimer.sessionId,
          position: completedTimer.position,
          title: completedTimer.title,
          description: completedTimer.description,
          icon: completedTimer.icon,
          type: completedTimer.type,
          plannedDuration: completedTimer.plannedDuration,
          actualDurationMs: completedTimer.plannedDuration.inMilliseconds,
          status: TimerStatus.completed,
          createdAt: completedTimer.createdAt,
          updatedAt: DateTime.now(),
        ),
      );
    }
    if (_session != null) {
      final finishedSession = _session!;
      await _sessionDao.updateSession(
        Session(
          id: finishedSession.id,
          title: finishedSession.title,
          description: finishedSession.description,
          icon: finishedSession.icon,
          status: SessionStatus.completed,
          createdAt: finishedSession.createdAt,
          updatedAt: DateTime.now(),
          completedAt: DateTime.now().toIso8601String(),
        ),
      );
      await _logCompletedRun(finishedSession);
    }
    unawaited(
      _timerAlertService.notifySessionFinished(sessionTitle: sessionTitle),
    );
    await _clearState(notify: notify);
  }

  Future<void> _advanceToNextTimer() async {
    final nextIndex = _currentIndex + 1;
    if (nextIndex >= _timers.length) {
      await _clearState(markSessionCompleted: true);
      return;
    }

    _currentIndex = nextIndex;
    _remaining = _timers[nextIndex].plannedDuration;
    _isPaused = false;
    _endsAt = DateTime.now().add(_remaining);
    _startTicker();
    await _persist();
    notifyListeners();
  }

  void _accrueWork(SessionTimer timer, Duration actual) {
    if (timer.type == TimerType.work) {
      _runWorkMs += actual.inMilliseconds;
    }
  }

  Future<void> _logCompletedRun(Session session) async {
    final sessionId = session.id;
    if (sessionId == null) return;
    await _focusLogDao.insertRun(
      FocusLog.create(sessionId: sessionId, workMs: _runWorkMs),
    );
  }

  Future<void> _persist() async {
    final sessionId = _session?.id;
    if (!hasActiveSession || sessionId == null) {
      _stateStore.clear();
      return;
    }

    _stateStore.write(
      TimerPersistedState(
        sessionId: sessionId,
        currentIndex: _currentIndex,
        isPaused: _isPaused,
        runWorkMs: _runWorkMs,
        remainingMs: _isPaused ? _remaining.inMilliseconds : null,
        endsAtMs: (!_isPaused && _endsAt != null)
            ? _endsAt!.millisecondsSinceEpoch
            : null,
      ),
    );
  }

  Future<void> _clearState({
    bool notify = true,
    bool markSessionCompleted = false,
  }) async {
    _stopTicker();
    if (markSessionCompleted && _session != null) {
      final finishedSession = _session!;
      await _sessionDao.updateSession(
        Session(
          id: finishedSession.id,
          title: finishedSession.title,
          description: finishedSession.description,
          icon: finishedSession.icon,
          status: SessionStatus.completed,
          createdAt: finishedSession.createdAt,
          updatedAt: DateTime.now(),
          completedAt: DateTime.now().toIso8601String(),
        ),
      );
      await _logCompletedRun(finishedSession);
    }
    _session = null;
    _timers = const [];
    _currentIndex = -1;
    _remaining = Duration.zero;
    _endsAt = null;
    _isPaused = false;
    _runWorkMs = 0;
    _stateStore.clear();
    if (notify) notifyListeners();
  }

  Duration _durationFromMs(int value, SessionTimer timer) {
    final clamped = value.clamp(0, timer.plannedDuration.inMilliseconds).toInt();
    return Duration(milliseconds: clamped);
  }
}
