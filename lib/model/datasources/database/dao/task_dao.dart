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

  // Belt-and-suspenders alongside the FK's `onDelete: setNull`: a database
  // that reached this schema via the raw migration SQL (rather than a fresh
  // install's `onCreate`) has that FK as `NO ACTION`, since SQLite can't
  // change a column's FK action in place and `PRAGMA foreign_keys` is a
  // no-op inside the transaction sqflite wraps migrations in. Clearing these
  // explicitly before delete works regardless of which FK action is
  // actually in effect on disk.
  @Query('UPDATE sessions SET taskId = NULL WHERE taskId = :taskId')
  Future<void> clearTaskFromSessions(int taskId);

  @Query('UPDATE focus_log SET taskId = NULL WHERE taskId = :taskId')
  Future<void> clearTaskFromFocusLogs(int taskId);

  @factoryMethod
  static TaskDao create(AppDatabase appDatabase) => appDatabase.taskDao;
}
