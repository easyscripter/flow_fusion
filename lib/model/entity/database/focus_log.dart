import 'package:froom/froom.dart';
import 'package:flow_fusion/enums/timer_type.dart';

@Entity(tableName: 'focus_log')
class FocusLog {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int sessionId;

  final int? timerId;

  final TimerType type;

  final int durationMs;

  final String completedAt;

  const FocusLog({
    this.id,
    required this.sessionId,
    this.timerId,
    required this.type,
    required this.durationMs,
    required this.completedAt,
  });

  factory FocusLog.create({
    required int sessionId,
    int? timerId,
    required TimerType type,
    required Duration duration,
  }) {
    return FocusLog(
      sessionId: sessionId,
      timerId: timerId,
      type: type,
      durationMs: duration.inMilliseconds,
      completedAt: DateTime.now().toIso8601String(),
    );
  }
}
