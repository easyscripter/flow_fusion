import 'package:flow_fusion/di/di.dart';
import 'package:flow_fusion/ui/app/app.dart';
import 'package:flow_fusion/ui/app/app_view_model.dart';
import 'package:flow_fusion/ui/app/timer_alert_service.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final timerAlertService = GetIt.I.get<TimerAlertService>();
  await timerAlertService.init();
  await windowManager.ensureInitialized();
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
