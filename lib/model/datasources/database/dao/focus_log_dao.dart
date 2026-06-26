import 'package:froom/froom.dart';
import 'package:flow_fusion/model/datasources/database/app_database.dart';
import 'package:flow_fusion/model/entity/database/focus_log.dart';
import 'package:injectable/injectable.dart';

@singleton
@dao
abstract class FocusLogDao {
  @insert
  Future<void> insertFocus(FocusLog log);

  @Query(
    'SELECT * FROM focus_log '
    'WHERE type = 0 AND completedAt >= :startIso AND completedAt <= :endIso',
  )
  Future<List<FocusLog>> findWorkFocusBetween(String startIso, String endIso);

  @factoryMethod
  static FocusLogDao create(AppDatabase appDatabase) =>
      appDatabase.focusLogDao;
}
