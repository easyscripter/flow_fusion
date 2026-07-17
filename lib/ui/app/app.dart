import 'package:desktop_updater/desktop_updater.dart';
import 'package:flow_fusion/l10n/app_localizations.dart';
import 'package:flow_fusion/controllers/active_timer_controller.dart';
import 'package:flow_fusion/controllers/onboarding_controller.dart';
import 'package:flow_fusion/ui/app/app_view_model.dart';
import 'package:flow_fusion/ui/app/router.dart';
import 'package:flow_fusion/ui/theme/app_theme.dart';
import 'package:flow_fusion/ui/widgets/title_bar.dart';
import 'package:flow_fusion/ui/widgets/update/update_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:showcaseview/showcaseview.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _appViewModel = GetIt.I.get<AppViewModel>();
  final _updateController = GetIt.I.get<DesktopUpdaterController>();
  final _onboarding = GetIt.I.get<OnboardingController>();

  @override
  void initState() {
    super.initState();

    ShowcaseView.register(
      onFinish: _onboarding.handleShowcaseFinish,
      onDismiss: (_) => _onboarding.handleShowcaseDismiss(),
      // The perpetual bouncing/scale animations repaint every frame and feel
      // janky on desktop — the highlight is enough on its own.
      disableMovingAnimation: true,
      disableScaleAnimation: true,
    );

    _appViewModel.init();
    GetIt.I.get<ActiveTimerController>().init();
  }

  @override
  void dispose() {
    ShowcaseView.get().unregister();
    super.dispose();
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
                  UpdateBanner(controller: _updateController),
                  Expanded(child: child ?? const SizedBox.shrink()),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
