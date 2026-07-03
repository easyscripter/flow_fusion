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

  /// Raw INTEGER column (milliseconds). Use [actualDuration] getter for a typed value.
  @ColumnInfo(name: 'actualDuration')
  int? actualDurationMs;

  @ignore
  Duration? get actualDuration =>
      actualDurationMs == null ? null : Duration(milliseconds: actualDurationMs!);

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
    this.actualDurationMs,
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

  SessionTimer copyWith({
    int? id,
    int? sessionId,
    int? position,
    String? title,
    String? description,
    bool clearDescription = false,
    String? icon,
    bool clearIcon = false,
    TimerType? type,
    Duration? plannedDuration,
    int? actualDurationMs,
    bool clearActualDurationMs = false,
    TimerStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SessionTimer(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      position: position ?? this.position,
      title: title ?? this.title,
      description: clearDescription ? null : (description ?? this.description),
      icon: clearIcon ? null : (icon ?? this.icon),
      type: type ?? this.type,
      plannedDuration: plannedDuration ?? this.plannedDuration,
      actualDurationMs: clearActualDurationMs
          ? null
          : (actualDurationMs ?? this.actualDurationMs),
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
