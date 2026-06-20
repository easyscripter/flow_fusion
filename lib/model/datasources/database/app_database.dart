import 'dart:async';

import 'package:froom/froom.dart';
import 'package:flow_fusion/enums/phase_type.dart';
import 'package:flow_fusion/enums/session_status.dart';
import 'package:flow_fusion/enums/timer_status.dart';
import 'package:flow_fusion/model/datasources/database/converter/date_time_converter.dart';
import 'package:flow_fusion/model/datasources/database/converter/duration_converter.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_timer_dao.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/model/entity/database/session_timer.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@TypeConverters([DurationConverter, DateTimeConverter])
@Database(version: 1, entities: [Session, SessionTimer])
abstract class AppDatabase extends FroomDatabase {
  SessionDao get sessionDao;
  SessionTimerDao get sessionTimerDao;
}
