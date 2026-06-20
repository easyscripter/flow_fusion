enum SessionStatus {
  idle('IDLE'),
  active('ACTIVE'),
  paused('PAUSED'),
  completed('COMPLETED'),
  archived('ARCHIVED');

  const SessionStatus(this.id);

  final String id;
}
