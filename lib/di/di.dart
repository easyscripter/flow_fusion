import 'dart:io';

import 'package:desktop_updater/desktop_updater.dart';
import 'package:flow_fusion/model/datasources/database/app_database.dart';
import 'package:flow_fusion/model/datasources/update/release_notes_loader.dart';
import 'package:flow_fusion/ui/constants/app_config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
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
  Future<AppDatabase> get db async {
    final Directory supportDir = await getApplicationSupportDirectory();
    if (!supportDir.existsSync()) {
      supportDir.createSync(recursive: true);
    }
    final String dbPath =
        '${supportDir.path}${Platform.pathSeparator}flow_fusion.db';
    return $FroomAppDatabase.databaseBuilder(dbPath).addMigrations([
      migration1To2,
      migration2To3,
      migration3To4,
      migration4To5,
      migration5To6,
    ]).build();
  }
}

@module
abstract class PackageVersionModule {
  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();
}

@module
abstract class UpdaterModule {
  @lazySingleton
  DesktopUpdaterController updater(LocalizedReleaseNotesLoader notesLoader) =>
      DesktopUpdaterController(
        appArchiveUrl: Uri.parse(AppConfig.updateArchiveUrl),
        releaseNotesLoader: notesLoader.load,
      );
}

@InjectableInit()
Future<void> configureDependencies() async => GetIt.instance.init();
