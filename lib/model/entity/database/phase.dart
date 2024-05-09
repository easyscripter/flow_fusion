import 'package:floor/floor.dart';
import 'package:flow_fusion/enums/phase_type.dart';
import 'package:flow_fusion/model/entity/database/session.dart';

@Entity(
  tableName: 'Phase',
  foreignKeys: [
    ForeignKey(
      childColumns: ['sessionId'],
      parentColumns: ['id'],
      entity: Session,
    )
  ],
)
class Phase {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'name')
  String name;

  @ColumnInfo(name: 'duration')
  Duration duration;

  @ColumnInfo(name: 'type')
  PhaseType type;

  final int sessionId;

  Phase({
    this.id,
    required this.name,
    required this.duration,
    required this.type,
    required this.sessionId,
  });
}
