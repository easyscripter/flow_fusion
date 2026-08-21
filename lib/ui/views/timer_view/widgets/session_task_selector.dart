import 'package:flow_fusion/controllers/active_timer_controller.dart';
import 'package:flow_fusion/model/datasources/database/dao/task_dao.dart';
import 'package:flow_fusion/model/entity/database/task.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/widgets/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SessionTaskSelector extends StatefulWidget {
  const SessionTaskSelector({
    super.key,
    required this.selectedTaskId,
    required this.controller,
  });

  final int? selectedTaskId;
  final ActiveTimerController controller;

  @override
  State<SessionTaskSelector> createState() => _SessionTaskSelectorState();
}

class _SessionTaskSelectorState extends State<SessionTaskSelector> {
  final TaskDao _taskDao = GetIt.I.get<TaskDao>();
  List<Task> _tasks = const <Task>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final tasks = await _taskDao.findAllTasks();
    if (!mounted) return;
    setState(() => _tasks = tasks);
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = _tasks.any((task) => task.id == widget.selectedTaskId)
        ? widget.selectedTaskId
        : null;

    return AppDropdown<int?>(
      value: selectedId,
      onChanged: (taskId) => widget.controller.setTask(taskId),
      items: [
        DropdownMenuItem<int?>(
          value: null,
          child: Text(context.l10n.taskSelectorNoTask),
        ),
        for (final task in _tasks)
          DropdownMenuItem<int?>(value: task.id, child: Text(task.name)),
      ],
    );
  }
}
