import 'package:flow_fusion/di/di.dart';
import 'package:flow_fusion/ui/app/app.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    size: Size(AppSizes.windowDefaultWidth, AppSizes.windowDefaultHeight),
    minimumSize: Size(AppSizes.windowMinWidth, AppSizes.windowMinHeight),
    center: true,
    skipTaskbar: false,
    backgroundColor: Colors.transparent,
    title: 'Flow Fusion',
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const App());
}
