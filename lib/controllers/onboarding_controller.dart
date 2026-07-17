import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'onboarding_controller.g.dart';

/// Total number of steps across the whole onboarding tour: 4 sidebar steps
/// (brand, overview, sessions, settings) + 5 editor steps (details, timers,
/// blocked apps, blocked sites, save). Used by [OnboardingTooltip] to render
/// the "step N of M" counter as a single continuous flow.
const int kOnboardingTotalSteps = 9;

@lazySingleton
class OnboardingController = _OnboardingControllerBase
    with _$OnboardingController;

abstract class _OnboardingControllerBase with Store {
  _OnboardingControllerBase(this._prefs);

  final Prefs _prefs;

  final GlobalKey brandKey = GlobalKey();
  final GlobalKey navOverviewKey = GlobalKey();
  final GlobalKey navSessionsKey = GlobalKey();
  final GlobalKey navSettingsKey = GlobalKey();

  final GlobalKey editorDetailsKey = GlobalKey();
  final GlobalKey editorTimersKey = GlobalKey();
  final GlobalKey editorBlockedAppsKey = GlobalKey();
  final GlobalKey editorBlockedSitesKey = GlobalKey();
  final GlobalKey editorSaveKey = GlobalKey();

  bool get shouldRun => !_prefs.hasSeenOnboarding;

  @action
  void complete() {
    _prefs.hasSeenOnboarding = true;
  }

  @action
  void restart() {
    _prefs.hasSeenOnboarding = false;
  }
}
