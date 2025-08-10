import 'package:flow_fusion/di/di.dart';
import 'package:flow_fusion/ui/pages/home_page/home_page.dart';
import 'package:flow_fusion/ui/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = GetIt.instance<ThemeProvider>();
    _themeProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeProvider,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flow Fusion',
          themeMode: _themeProvider.themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
