import 'package:froom/froom.dart';
import 'package:flow_fusion/model/entity/database/task.dart';

@Entity(
  tableName: 'focus_log',
  foreignKeys: [
    ForeignKey(
      childColumns: ['taskId'],
      parentColumns: ['id'],
      entity: Task,
      onDelete: ForeignKeyAction.setNull,
    ),
  ],
)
class FocusLog {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int sessionId;


  final int workMs;


  final String completedAt;

  /// The task the session was tagged with at the moment this run completed —
  /// a snapshot, not a live join. Sessions are reusable and can be re-run
  /// under a different (or no) task later, so aggregating via a live join to
  /// `sessions.taskId` would retroactively attribute a session's entire
  /// history to whatever task happens to be tagged on it now.
  final int? taskId;

  const FocusLog({
    this.id,
    required this.sessionId,
    required this.workMs,
    required this.completedAt,
    this.taskId,
  });

  factory FocusLog.create({
    required int sessionId,
    required int workMs,
    int? taskId,
  }) {
    return FocusLog(
      sessionId: sessionId,
      workMs: workMs,
      completedAt: DateTime.now().toIso8601String(),
      taskId: taskId,
    );
  }
}
