import 'package:froom/froom.dart';
import 'package:flow_fusion/model/datasources/database/app_database.dart';
import 'package:flow_fusion/model/entity/database/session_timer.dart';
import 'package:injectable/injectable.dart';

@singleton
@dao
abstract class SessionTimerDao {
  @Query(
    'SELECT * FROM timers WHERE sessionId = :sessionId ORDER BY position ASC',
  )
  Future<List<SessionTimer>> findTimersBySessionId(int sessionId);

  @Insert(onConflict: OnConflictStrategy.abort)
  Future<int> insertTimer(SessionTimer timer);

  @insert
  Future<void> insertTimers(List<SessionTimer> timers);

  @update
  Future<void> updateTimer(SessionTimer timer);

  @delete
  Future<void> deleteTimer(SessionTimer timer);

  @Query('DELETE FROM timers WHERE sessionId = :sessionId')
  Future<void> deleteTimersForSession(int sessionId);

  @factoryMethod
  static SessionTimerDao create(AppDatabase appDatabase) =>
      appDatabase.sessionTimerDao;
}
