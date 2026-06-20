enum TimerStatus {
  idle('IDLE'),
  running('RUNNING'),
  paused('PAUSED'),
  completed('COMPLETED'),
  skipped('SKIPPED');

  const TimerStatus(this.id);

  final String id;
}
