import 'package:froom/froom.dart';
import 'package:flow_fusion/model/datasources/database/app_database.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:injectable/injectable.dart';

@singleton
@dao
abstract class SessionDao {
  @Query('SELECT * FROM sessions ORDER BY updatedAt DESC')
  Future<List<Session>> findAllSession();

  @Query('SELECT * FROM sessions WHERE id = :id')
  Future<Session?> findSessionById(int id);

  /// Inserts a session and returns its auto-generated id.
  @Insert(onConflict: OnConflictStrategy.abort)
  Future<int> insertSession(Session session);

  @update
  Future<void> updateSession(Session session);

  @delete
  Future<void> deleteSession(Session session);

  @Query('DELETE FROM sessions')
  Future<void> clear();

  @Query('SELECT COUNT(*) FROM sessions WHERE status = 3')
  Future<int?> countCompletedSessions();

  @factoryMethod
  static SessionDao create(AppDatabase appDatabase) => appDatabase.sessionDao;
}
