import 'package:desktop_updater/desktop_updater.dart';
import 'package:flow_fusion/model/datasources/database/app_database.dart';
import 'package:flow_fusion/ui/constants/app_config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
  Future<AppDatabase> get db => $FroomAppDatabase
      .databaseBuilder('flow_fusion.db')
      .addMigrations([migration1To2, migration2To3])
      .build();
}

@module
abstract class PackageVersionModule {
  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();
}

@module
abstract class UpdaterModule {
  @lazySingleton
  DesktopUpdaterController get updater => DesktopUpdaterController(
    appArchiveUrl: Uri.parse(AppConfig.updateArchiveUrl),
  );
}

@InjectableInit()
Future<void> configureDependencies() async => GetIt.instance.init();
