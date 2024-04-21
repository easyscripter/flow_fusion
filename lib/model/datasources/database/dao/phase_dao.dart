import 'package:floor/floor.dart';
import 'package:flow_fusion/enums/PhaseType.dart';
import 'package:flow_fusion/model/datasources/database/app_database.dart';
import 'package:flow_fusion/model/entity/database/phase.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:injectable/injectable.dart';

@singleton
@dao
abstract class PhaseDao {
  @Query('SELECT * FROM Phase WHERE sessionId = :sessionId')
  Future<List<Phase>> findPhasesBySessionId(int sessionId);

  @Query('SELECT * FROM Phase WHERE id = :id')
  Stream<Phase?> findPhaseById(int id);

  @Query('DELETE FROM Phase WHERE sessionId = :sessionId AND id = :id')
  Future<void> deletePhaseById(int sessionId, int id);

  @Query(
      'UPDATE Phase SET name = :name WHERE id = :id AND sessionId = :sessionId')
  Future<void> updatePhaseName(int id, int sessionId, String name);

  @Query(
      'UPDATE Phase SET duration = :duration WHERE id = :id AND sessionId = :sessionId')
  Future<void> updatePhaseDuration(int id, int sessionId, Duration duration);

  @Query(
      'UPDATE Phase SET type = :type WHERE id = :id AND sessionId = :sessionId')
  Future<void> updatePhaseType(int id, int sessionId, PhaseType type);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSession(Session session);

  @factoryMethod
  static PhaseDao create(AppDatabase appDatabase) => appDatabase.phaseDao;
}
