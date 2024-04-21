import 'package:floor/floor.dart';

@entity
class Session {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  String name;

  Session({
    this.id,
    required this.name,
  });
}
