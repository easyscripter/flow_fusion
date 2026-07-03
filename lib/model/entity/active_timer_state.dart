import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/model/entity/database/session_timer.dart';
import 'package:flow_fusion/model/entity/timer_persisted_state.dart';

class ActiveTimerState {
  Session? session;
  List<SessionTimer> timers = const [];
  int currentIndex = -1;
  Duration remaining = Duration.zero;
  DateTime? endsAt;
  bool isPaused = false;
  int runWorkMs = 0;

  SessionTimer? get currentTimer {
    if (currentIndex < 0 || currentIndex >= timers.length) return null;
    return timers[currentIndex];
  }

  bool get hasActiveSession => session != null && currentTimer != null;

  int? get currentSessionId => session?.id;

  double get progress {
    final timer = currentTimer;
    if (timer == null) return 0;
    final totalMs = timer.plannedDuration.inMilliseconds;
    if (totalMs <= 0) return 1;
    final doneMs = totalMs - remaining.inMilliseconds;
    return (doneMs / totalMs).clamp(0, 1).toDouble();
  }

  String get formattedRemaining {
    final totalSeconds = remaining.inSeconds.clamp(0, 599999);
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void accrueWork(SessionTimer timer, Duration actual) {
    if (timer.type == TimerType.work) {
      runWorkMs += actual.inMilliseconds;
    }
  }

  void reset() {
    session = null;
    timers = const [];
    currentIndex = -1;
    remaining = Duration.zero;
    endsAt = null;
    isPaused = false;
    runWorkMs = 0;
  }

  TimerPersistedState? toPersistedState() {
    final sessionId = session?.id;
    if (!hasActiveSession || sessionId == null) return null;
    return TimerPersistedState(
      sessionId: sessionId,
      currentIndex: currentIndex,
      isPaused: isPaused,
      runWorkMs: runWorkMs,
      remainingMs: isPaused ? remaining.inMilliseconds : null,
      endsAtMs: (!isPaused && endsAt != null)
          ? endsAt!.millisecondsSinceEpoch
          : null,
    );
  }

  static Duration durationFromMs(int value, SessionTimer timer) {
    final clamped = value
        .clamp(0, timer.plannedDuration.inMilliseconds)
        .toInt();
    return Duration(milliseconds: clamped);
  }
}
