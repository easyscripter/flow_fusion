import 'package:flow_fusion/model/datasources/database/dao/task_dao.dart';
import 'package:flow_fusion/model/entity/database/task.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'tasks_view_view_model.g.dart';

@injectable
class TasksViewViewModel = _TasksViewViewModelBase with _$TasksViewViewModel;

abstract class _TasksViewViewModelBase with Store {
  _TasksViewViewModelBase(this._taskDao);

  final TaskDao _taskDao;

  @observable
  bool isLoading = false;

  @observable
  bool hasError = false;

  @observable
  List<Task> tasks = [];

  @action
  Future<void> update() async {
    try {
      isLoading = true;
      hasError = false;
      tasks = await _taskDao.findAllTasks();
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
}
