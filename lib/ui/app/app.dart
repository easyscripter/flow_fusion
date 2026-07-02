import 'package:flow_fusion/l10n/app_localizations.dart';
import 'package:flow_fusion/ui/app/active_timer_controller.dart';
import 'package:flow_fusion/ui/app/app_view_model.dart';
import 'package:flow_fusion/ui/app/router.dart';
import 'package:flow_fusion/ui/theme/app_theme.dart';
import 'package:flow_fusion/ui/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _appViewModel = GetIt.I.get<AppViewModel>();

  @override
  void initState() {
    super.initState();

    _appViewModel.init();
    GetIt.I.get<ActiveTimerController>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return MaterialApp.router(
          title: 'Flow Fusion',
          themeMode: _appViewModel.themeMode,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          locale: _appViewModel.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return Scaffold(
              body: Column(
                children: [
                  const TitleBar(),
                  Expanded(child: child ?? const SizedBox.shrink()),
                ],
              )
            );
          },
        );
      },
    );
  }
}
