import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flow_fusion/di/di.dart';
import 'package:flow_fusion/model/seed/session_seeder.dart';
import 'package:flow_fusion/ui/app/app.dart';
import 'package:flow_fusion/ui/app/app_view_model.dart';
import 'package:flow_fusion/ui/app/timer_alert_service.dart';
import 'package:flow_fusion/ui/app/tray_service.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  runZonedGuarded(_startup, (error, stack) {
    AppLogger.error('Zone', error, stack);
  });
}

Future<void> _startup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLogger.init();

  FlutterError.onError = (details) {
    AppLogger.error('FlutterError', details.exception, details.stack);
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error('PlatformDispatcher', error, stack);
    return true;
  };

  await configureDependencies();
  await GetIt.I.get<SessionSeeder>().seedIfNeeded();
  final timerAlertService = GetIt.I.get<TimerAlertService>();
  final trayService = GetIt.I.get<TrayService>();
  await timerAlertService.init();
  await windowManager.ensureInitialized();
  await trayService.init();

  WindowOptions windowOptions = WindowOptions(
    size: Size(AppSizes.windowDefaultWidth, AppSizes.windowDefaultHeight),
    minimumSize: Size(AppSizes.windowMinWidth, AppSizes.windowMinHeight),
    center: true,
    skipTaskbar: false,
    backgroundColor: Colors.transparent,
    title: 'Flow Fusion',
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await timerAlertService.requestPermission();
    await GetIt.I.get<AppViewModel>().refreshNotificationsPermission();
  });

  runApp(const App());
}
