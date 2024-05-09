import 'package:floor/floor.dart';

@Entity()
class Session {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  String name;

  Session({
    this.id,
    required this.name,
  });
}
