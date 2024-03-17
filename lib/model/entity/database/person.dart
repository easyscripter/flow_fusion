import 'package:floor/floor.dart';

// As an example
@entity
class Person {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  Person(this.id, this.name);

  factory Person.optional({
    int? id,
    String? name,
  }) =>
      Person(
        id,
        name ?? '',
      );

  @override
  String toString() {
    return 'Person(id: $id, name: $name)';
  }
}
