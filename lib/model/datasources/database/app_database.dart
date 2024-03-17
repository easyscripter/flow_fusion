import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flow_fusion/model/datasources/database/dao/person_dao.dart';
import 'package:flow_fusion/model/entity/database/person.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [Person])
abstract class AppDatabase extends FloorDatabase {
  // As an example
  PersonDao get personDao;
}
