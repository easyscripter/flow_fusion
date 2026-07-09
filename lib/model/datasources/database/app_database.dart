import 'dart:async';

import 'package:froom/froom.dart';
import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/enums/session_status.dart';
import 'package:flow_fusion/enums/timer_status.dart';
import 'package:flow_fusion/model/datasources/database/converter/blocked_app_list_converter.dart';
import 'package:flow_fusion/model/datasources/database/converter/date_time_converter.dart';
import 'package:flow_fusion/model/datasources/database/converter/duration_converter.dart';
import 'package:flow_fusion/model/datasources/database/converter/string_list_converter.dart';
import 'package:flow_fusion/model/datasources/database/dao/focus_log_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_timer_dao.dart';
import 'package:flow_fusion/model/entity/database/focus_log.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/model/entity/database/session_timer.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

final migration1To2 = Migration(1, 2, (database) async {
  await database.execute(
    'ALTER TABLE sessions ADD COLUMN completedAt TEXT',
  );
  await database.execute(
    'ALTER TABLE timers ADD COLUMN actualDuration INTEGER',
  );
});

// Schema version 3 introduced the `focus_log` table (see app_database.g.dart).
// Without this migration, users upgrading from a v2 database crash on launch.
final migration2To3 = Migration(2, 3, (database) async {
  await database.execute(
    'CREATE TABLE IF NOT EXISTS `focus_log` ('
    '`id` INTEGER PRIMARY KEY AUTOINCREMENT, '
    '`sessionId` INTEGER NOT NULL, '
    '`workMs` INTEGER NOT NULL, '
    '`completedAt` TEXT NOT NULL)',
  );
});


final migration3To4 = Migration(3, 4, (database) async {
  await database.execute(
    "ALTER TABLE sessions ADD COLUMN blockedApps TEXT NOT NULL DEFAULT '[]'",
  );
  await database.execute(
    "ALTER TABLE sessions ADD COLUMN blockedSites TEXT NOT NULL DEFAULT '[]'",
  );
});

@TypeConverters([
  DurationConverter,
  DateTimeConverter,
  BlockedAppListConverter,
  StringListConverter,
])
@Database(version: 4, entities: [Session, SessionTimer, FocusLog])
abstract class AppDatabase extends FroomDatabase {
  SessionDao get sessionDao;
  SessionTimerDao get sessionTimerDao;
  FocusLogDao get focusLogDao;
}
