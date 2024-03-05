import 'package:flow_fusion/di/di.dart';
import 'package:flow_fusion/ui/app.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const App());
}
