import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/model/entity/database/session_timer.dart';
import 'package:flow_fusion/model/entity/timer_persisted_state.dart';
import 'package:mobx/mobx.dart';

part 'active_timer_state.g.dart';

class ActiveTimerState = _ActiveTimerState with _$ActiveTimerState;

abstract class _ActiveTimerState with Store {
  @observable
  Session? session;

  @observable
  List<SessionTimer> timers = const [];

  @observable
  int currentIndex = -1;

  @observable
  Duration remaining = Duration.zero;

  @observable
  DateTime? endsAt;

  @observable
  bool isPaused = false;

  @observable
  int runWorkMs = 0;

  @observable
  bool awaitingManualAdvance = false;

  @computed
  SessionTimer? get currentTimer {
    if (currentIndex < 0 || currentIndex >= timers.length) return null;
    return timers[currentIndex];
  }

  @computed
  bool get hasActiveSession => session != null && currentTimer != null;

  @computed
  int? get currentSessionId => session?.id;

  @computed
  double get progress {
    final timer = currentTimer;
    if (timer == null) return 0;
    final totalMs = timer.plannedDuration.inMilliseconds;
    if (totalMs <= 0) return 1;
    final doneMs = totalMs - remaining.inMilliseconds;
    return (doneMs / totalMs).clamp(0, 1).toDouble();
  }

  @computed
  String get formattedRemaining {
    final totalSeconds = remaining.inSeconds.clamp(0, 599999);
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @action
  void accrueWork(SessionTimer timer, Duration actual) {
    if (timer.type == TimerType.work) {
      runWorkMs += actual.inMilliseconds;
    }
  }

  @action
  void reset() {
    session = null;
    timers = const [];
    currentIndex = -1;
    remaining = Duration.zero;
    endsAt = null;
    isPaused = false;
    runWorkMs = 0;
    awaitingManualAdvance = false;
  }

  TimerPersistedState? toPersistedState() {
    final sessionId = session?.id;
    if (!hasActiveSession || sessionId == null) return null;
    return TimerPersistedState(
      sessionId: sessionId,
      currentIndex: currentIndex,
      isPaused: isPaused,
      runWorkMs: runWorkMs,
      awaitingManualAdvance: awaitingManualAdvance,
      remainingMs: isPaused ? remaining.inMilliseconds : null,
      endsAtMs: (!isPaused && endsAt != null)
          ? endsAt!.millisecondsSinceEpoch
          : null,
    );
  }
}

Duration remainingFromPersistedMs(int value, SessionTimer timer) {
  final clamped = value.clamp(0, timer.plannedDuration.inMilliseconds).toInt();
  return Duration(milliseconds: clamped);
}
