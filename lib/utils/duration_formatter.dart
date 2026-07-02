/// Форматирует длительность фокуса: "12h 30m" / "45m" / "0m".
String formatFocusDuration(Duration d) {
  final int hours = d.inHours;
  final int minutes = d.inMinutes.remainder(60);
  if (hours == 0) return '${minutes}m';
  if (minutes == 0) return '${hours}h';
  return '${hours}h ${minutes}m';
}
