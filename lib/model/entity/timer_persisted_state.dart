class TimerPersistedState {
  const TimerPersistedState({
    required this.sessionId,
    required this.currentIndex,
    required this.isPaused,
    required this.runWorkMs,
    this.awaitingManualAdvance = false,
    this.remainingMs,
    this.endsAtMs,
  });

  final int sessionId;
  final int currentIndex;
  final bool isPaused;
  final int runWorkMs;
  final bool awaitingManualAdvance;

  final int? remainingMs;

  final int? endsAtMs;

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'currentIndex': currentIndex,
    'isPaused': isPaused,
    'runWorkMs': runWorkMs,
    if (awaitingManualAdvance) 'awaitingManualAdvance': awaitingManualAdvance,
    if (remainingMs != null) 'remainingMs': remainingMs,
    if (endsAtMs != null) 'endsAtMs': endsAtMs,
  };

  static TimerPersistedState? fromJson(Map<String, dynamic> json) {
    final sessionId = json['sessionId'] as int?;
    final currentIndex = json['currentIndex'] as int?;
    if (sessionId == null || currentIndex == null) return null;
    return TimerPersistedState(
      sessionId: sessionId,
      currentIndex: currentIndex,
      isPaused: json['isPaused'] as bool? ?? false,
      runWorkMs: json['runWorkMs'] as int? ?? 0,
      awaitingManualAdvance: json['awaitingManualAdvance'] as bool? ?? false,
      remainingMs: json['remainingMs'] as int?,
      endsAtMs: json['endsAtMs'] as int?,
    );
  }
}
