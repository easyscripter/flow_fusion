import 'package:froom/froom.dart';

@Entity(tableName: 'focus_log')
class FocusLog {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int sessionId;


  final int workMs;


  final String completedAt;

  const FocusLog({
    this.id,
    required this.sessionId,
    required this.workMs,
    required this.completedAt,
  });

  factory FocusLog.create({required int sessionId, required int workMs}) {
    return FocusLog(
      sessionId: sessionId,
      workMs: workMs,
      completedAt: DateTime.now().toIso8601String(),
    );
  }
}
