library;

sealed class TimerTransition {
  const TimerTransition();
}

class TimerCompleted extends TimerTransition {
  const TimerCompleted({required this.completedIndex, required this.nextIndex});

  final int completedIndex;
  final int nextIndex;
}

class SettleOn extends TimerTransition {
  const SettleOn({required this.index, required this.remaining});

  final int index;
  final Duration remaining;
}

class SessionFinished extends TimerTransition {
  const SessionFinished({required this.completedIndex});

  final int completedIndex;
}

List<TimerTransition> planAdvance({
  required Duration overshoot,
  required int currentIndex,
  required List<Duration> durations,
}) {
  final List<TimerTransition> transitions = <TimerTransition>[];
  if (currentIndex < 0 || currentIndex >= durations.length) {
    return transitions;
  }

  Duration extra = overshoot;
  int index = currentIndex;

  while (true) {
    final int completedIndex = index;
    final int nextIndex = index + 1;

    if (nextIndex >= durations.length) {
      transitions.add(SessionFinished(completedIndex: completedIndex));
      return transitions;
    }

    index = nextIndex;
    final Duration nextDuration = durations[index];
    transitions.add(
      TimerCompleted(completedIndex: completedIndex, nextIndex: index),
    );

    if (extra < nextDuration) {
      transitions.add(SettleOn(index: index, remaining: nextDuration - extra));
      return transitions;
    }

    extra -= nextDuration;
  }
}

Duration elapsedIn(Duration planned, Duration remaining) {
  final Duration elapsed = planned - remaining;
  if (elapsed <= Duration.zero) return Duration.zero;
  if (elapsed >= planned) return planned;
  return elapsed;
}
