import 'package:froom/froom.dart';
import 'package:flow_fusion/enums/session_status.dart';
import 'package:flow_fusion/model/entity/blocked_app.dart';

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

  /// Raw TEXT column (ISO-8601). Use [completedAtDateTime] for a typed value.
  String? completedAt;

  List<BlockedApp> blockedApps;

  List<String> blockedSites;

  @ignore
  DateTime? get completedAtDateTime =>
      completedAt == null ? null : DateTime.parse(completedAt!);

  Session({
    this.id,
    required this.title,
    this.description,
    this.icon,
    this.status = SessionStatus.idle,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.blockedApps = const <BlockedApp>[],
    this.blockedSites = const <String>[],
  });

  factory Session.create({
    required String title,
    String? description,
    String? icon,
    SessionStatus status = SessionStatus.idle,
    List<BlockedApp> blockedApps = const <BlockedApp>[],
    List<String> blockedSites = const <String>[],
  }) {
    final now = DateTime.now();
    return Session(
      title: title,
      description: description,
      icon: icon,
      status: status,
      createdAt: now,
      updatedAt: now,
      blockedApps: blockedApps,
      blockedSites: blockedSites,
    );
  }

  Session copyWith({
    String? title,
    String? description,
    String? icon,
    SessionStatus? status,
    String? completedAt,
    List<BlockedApp>? blockedApps,
    List<String>? blockedSites,
  }) {
    return Session(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      completedAt: completedAt ?? this.completedAt,
      blockedApps: blockedApps ?? this.blockedApps,
      blockedSites: blockedSites ?? this.blockedSites,
    );
  }
}
