import 'package:flow_fusion/model/entity/database/task.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/views/tasks_view/tasks_view_view_model.dart';
import 'package:flow_fusion/ui/views/tasks_view/widgets/task_edit_dialog.dart';
import 'package:flow_fusion/ui/views/tasks_view/widgets/task_list_tile.dart';
import 'package:flow_fusion/ui/widgets/app_button.dart';
import 'package:flow_fusion/ui/widgets/app_page_header.dart';
import 'package:flow_fusion/ui/widgets/error_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  late final TasksViewViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I.get<TasksViewViewModel>();
    _viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Observer(
        builder: (context) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_viewModel.hasError) {
            return Padding(
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              child: ErrorRetry(
                message: context.l10n.errorLoadFailed,
                onRetry: _viewModel.update,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppPageHeader(
                  title: context.l10n.tasksTitle,
                  subtitle: context.l10n.tasksSubtitle,
                  trailing: AppButton(
                    label: context.l10n.tasksNew,
                    icon: Icons.add,
                    onPressed: _createTask,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingLarge),
                Expanded(
                  child: _viewModel.tasks.isEmpty
                      ? _EmptyState(onCreate: _createTask)
                      : ListView.separated(
                          itemCount: _viewModel.tasks.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSizes.paddingSmall),
                          itemBuilder: (context, index) {
                            final taskWithDuration = _viewModel.tasks[index];
                            return TaskListTile(
                              task: taskWithDuration.task,
                              totalDuration: taskWithDuration.totalDuration,
                              onEdit: () => _editTask(taskWithDuration.task),
                              onDelete: () =>
                                  _deleteTask(taskWithDuration.task),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _createTask() async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => const TaskEditDialog(),
    );
    if (name == null || !mounted) return;

    final created = await _viewModel.createTask(name);
    if (!created && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errorTaskSaveFailed)),
      );
    }
  }

  Future<void> _editTask(Task task) async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => TaskEditDialog(initialName: task.name),
    );
    if (name == null || !mounted) return;

    final renamed = await _viewModel.renameTask(task, name);
    if (!renamed && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errorTaskSaveFailed)),
      );
    }
  }

  Future<void> _deleteTask(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.deleteTaskModalTitle),
        content: Text(context.l10n.deleteTaskModalContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.deleteModalCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.deleteModalConfirm),
          ),
        ],
      ),
    );
    if (!mounted) return;

    if (confirmed == true) {
      final deleted = await _viewModel.deleteTask(task);
      if (!deleted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.errorTaskDeleteFailed)),
        );
      }
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.tasksEmptyTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.paddingSmall),
            Text(
              context.l10n.tasksEmptyDescription,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.mutedForeground,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSizes.paddingLarge),
            AppButton(
              label: context.l10n.tasksNew,
              icon: Icons.add,
              onPressed: onCreate,
            ),
          ],
        ),
      ),
    );
  }
}
