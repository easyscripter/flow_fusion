import 'package:flow_fusion/model/datasources/database/dao/focus_log_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/task_dao.dart';
import 'package:flow_fusion/model/entity/database/focus_log.dart';
import 'package:flow_fusion/model/entity/database/task.dart';
import 'package:flow_fusion/ui/views/tasks_view/models/task_with_duration.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'tasks_view_view_model.g.dart';

@injectable
class TasksViewViewModel = _TasksViewViewModelBase with _$TasksViewViewModel;

abstract class _TasksViewViewModelBase with Store {
  _TasksViewViewModelBase(this._taskDao, this._focusLogDao);

  final TaskDao _taskDao;
  final FocusLogDao _focusLogDao;

  @observable
  bool isLoading = false;

  @observable
  bool hasError = false;

  @observable
  List<TaskWithDuration> tasks = [];

  @action
  Future<void> update() async {
    try {
      isLoading = true;
      hasError = false;

      final List<Task> allTasks = await _taskDao.findAllTasks();
      final List<FocusLog> allRuns = await _focusLogDao.findAllRuns();

      // Each run's taskId is a snapshot of what the session was tagged with
      // when that run completed — not a live join to sessions.taskId, since
      // sessions are reusable and re-run under different tasks over time.
      final Map<int, int> workMsByTaskId = {};
      for (final run in allRuns) {
        final int? taskId = run.taskId;
        if (taskId == null) continue;
        workMsByTaskId[taskId] = (workMsByTaskId[taskId] ?? 0) + run.workMs;
      }

      final List<TaskWithDuration> withDurations = [
        for (final task in allTasks)
          TaskWithDuration(
            task: task,
            totalDuration: Duration(
              milliseconds: workMsByTaskId[task.id] ?? 0,
            ),
          ),
      ];
      withDurations.sort((a, b) {
        final durationCompare = b.totalDuration.compareTo(a.totalDuration);
        if (durationCompare != 0) return durationCompare;
        return (a.task.id ?? 0).compareTo(b.task.id ?? 0);
      });

      tasks = withDurations;
    } catch (e, s) {
      AppLogger.error('TasksViewViewModel.update', e, s);
      hasError = true;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> init() async {
    await update();
  }

  @action
  Future<bool> createTask(String name) async {
    try {
      await _taskDao.insertTask(Task.create(name: name));
      await update();
      return true;
    } catch (e, s) {
      AppLogger.error('TasksViewViewModel.createTask', e, s);
      return false;
    }
  }

  @action
  Future<bool> renameTask(Task task, String name) async {
    try {
      await _taskDao.updateTask(task.copyWith(name: name));
      await update();
      return true;
    } catch (e, s) {
      AppLogger.error('TasksViewViewModel.renameTask', e, s);
      return false;
    }
  }

  @action
  Future<bool> deleteTask(Task task) async {
    try {
      final int? taskId = task.id;
      if (taskId != null) {
        await _taskDao.clearTaskFromSessions(taskId);
        await _taskDao.clearTaskFromFocusLogs(taskId);
      }
      await _taskDao.deleteTask(task);
      await update();
      return true;
    } catch (e, s) {
      AppLogger.error('TasksViewViewModel.deleteTask', e, s);
      return false;
    }
  }
}
