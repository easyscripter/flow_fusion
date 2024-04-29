import 'package:flow_fusion/di/di.dart';
import 'package:flow_fusion/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 700),
    minimumSize: Size(1200, 700),
    center: true,
    skipTaskbar: false,
    title: 'Flow Fusion',
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const App());
}
