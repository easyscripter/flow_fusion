import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flow_fusion/enums/PhaseType.dart';
import 'package:flow_fusion/model/datasources/database/converter/duration_converter.dart';
import 'package:flow_fusion/model/datasources/database/dao/phase_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/entity/database/phase.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@TypeConverters([DurationConverter])
@Database(version: 1, entities: [Session, Phase])
abstract class AppDatabase extends FloorDatabase {
  SessionDao get sessionDao;
  PhaseDao get phaseDao;
}
