import 'package:froom/froom.dart';

@Entity(tableName: 'tasks')
class Task {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  String name;

  Task({this.id, required this.name});

  factory Task.create({required String name}) => Task(name: name);

  Task copyWith({String? name}) => Task(id: id, name: name ?? this.name);
}
