import 'package:froom/froom.dart';
import 'package:flow_fusion/model/datasources/database/app_database.dart';
import 'package:flow_fusion/model/entity/database/task.dart';
import 'package:injectable/injectable.dart';

@singleton
@dao
abstract class TaskDao {
  @Query('SELECT * FROM tasks ORDER BY id ASC')
  Future<List<Task>> findAllTasks();

  @Insert(onConflict: OnConflictStrategy.abort)
  Future<int> insertTask(Task task);

  @update
  Future<void> updateTask(Task task);

  @delete
  Future<void> deleteTask(Task task);

  @factoryMethod
  static TaskDao create(AppDatabase appDatabase) => appDatabase.taskDao;
}
