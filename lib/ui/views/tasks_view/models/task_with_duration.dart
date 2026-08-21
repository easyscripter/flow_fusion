import 'package:flow_fusion/model/entity/database/task.dart';

class TaskWithDuration {
  final Task task;
  final Duration totalDuration;

  TaskWithDuration({required this.task, required this.totalDuration});
}
