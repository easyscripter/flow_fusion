import 'package:floor/floor.dart';
import 'package:flow_fusion/enums/PhaseType.dart';
import 'package:flow_fusion/model/datasources/database/app_database.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:injectable/injectable.dart';

@singleton
@dao
abstract class SessionDao {
  @Query('SELECT * FROM Session')
  Future<List<Session>> findAllSession();

  @Query('SELECT name FROM Session')
  Stream<List<String>> findAllSessionNames();

  @Query('SELECT * FROM Session WHERE id = :id')
  Stream<Session?> findSessionById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSession(Session session);

  @Query('DELETE FROM Session')
  Future<void> clear();

  @Query('UPDATE Session SET name = :name WHERE id = :id')
  Future<void> updateSessionName(String name, int id);

  @factoryMethod
  static SessionDao create(AppDatabase appDatabase) => appDatabase.sessionDao;
}
