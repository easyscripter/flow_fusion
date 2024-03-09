import 'package:flow_fusion/model/datasources/database/app_database.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'di.config.dart';

@module
abstract class PrefsModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}

@module
abstract class DatabaseModule {
   @preResolve
  Future<AppDatabase> get db =>
      $FloorAppDatabase.databaseBuilder('app_database.db').build();
}

@InjectableInit()
Future<void> configureDependencies() async => GetIt.instance.init();
