import 'package:floor/floor.dart';

@Entity(tableName: 'Session')
class Session {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'name')
  String name;

  Session({
    this.id,
    required this.name,
  });
}
