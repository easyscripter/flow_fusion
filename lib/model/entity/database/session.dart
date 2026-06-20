import 'package:froom/froom.dart';
import 'package:flow_fusion/enums/session_status.dart';

@Entity(tableName: 'sessions')
class Session {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  String title;

  String? description;

  String? icon;

  SessionStatus status;

  DateTime createdAt;

  DateTime updatedAt;

  Session({
    this.id,
    required this.title,
    this.description,
    this.icon,
    this.status = SessionStatus.idle,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Session.create({
    required String title,
    String? description,
    String? icon,
    SessionStatus status = SessionStatus.idle,
  }) {
    final now = DateTime.now();
    return Session(
      title: title,
      description: description,
      icon: icon,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  Session copyWith({
    String? title,
    String? description,
    String? icon,
    SessionStatus? status,
  }) {
    return Session(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
