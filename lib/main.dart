import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:flow_fusion/ui/app.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await prefs.init();
  runApp(const App());
}
