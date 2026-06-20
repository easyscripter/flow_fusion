import 'package:froom/froom.dart';
import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/enums/timer_status.dart';
import 'package:flow_fusion/model/entity/database/session.dart';

@Entity(
  tableName: 'timers',
  foreignKeys: [
    ForeignKey(
      childColumns: ['sessionId'],
      parentColumns: ['id'],
      entity: Session,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
  indices: [
    Index(value: ['sessionId', 'position'], unique: true),
  ],
)
class SessionTimer {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int sessionId;

  int position;

  String title;

  String? description;

  String? icon;

  TimerType type;

  Duration plannedDuration;

  TimerStatus status;

  DateTime createdAt;

  DateTime updatedAt;

  SessionTimer({
    this.id,
    required this.sessionId,
    required this.position,
    required this.title,
    this.description,
    this.icon,
    this.type = TimerType.work,
    required this.plannedDuration,
    this.status = TimerStatus.idle,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SessionTimer.create({
    required int sessionId,
    required int position,
    required String title,
    String? description,
    String? icon,
    TimerType type = TimerType.work,
    required Duration plannedDuration,
    TimerStatus status = TimerStatus.idle,
  }) {
    final now = DateTime.now();
    return SessionTimer(
      sessionId: sessionId,
      position: position,
      title: title,
      description: description,
      icon: icon,
      type: type,
      plannedDuration: plannedDuration,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }
}
