import 'dart:io';

import 'package:flow_fusion/enums/routes.dart';
import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:flow_fusion/ui/app/router.dart';
import 'package:flow_fusion/ui/views/onboarding/widgets/onboarding_welcome_card.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:showcaseview/showcaseview.dart';

part 'onboarding_controller.g.dart';

/// Whether the site-blocking step is part of the tour. Site blocking is
/// Windows-only, so the "blocked sites" step is skipped everywhere else.
bool get onboardingHasSitesStep => Platform.isWindows;

/// Total number of steps in the whole tour, rendered by [OnboardingTooltip] as
/// a single continuous "step N of M" counter. 4 sidebar steps + editor steps
/// (details, timers, blocked apps, [blocked sites,] save); the blocked-sites
/// step only exists on Windows.
int get onboardingTotalSteps => onboardingHasSitesStep ? 9 : 8;

/// The step number of the final "Save" step, which shifts down by one when the
/// blocked-sites step is absent.
int get onboardingSaveStep => onboardingHasSitesStep ? 9 : 8;

/// Where in the onboarding flow we currently are.
///
/// The flow is a single continuous tour split across two screens:
/// [sidebar] highlights the navigation, then we navigate to the session
/// editor ([awaitingEditor] → [editor]) and highlight its sections.
enum OnboardingPhase { idle, sidebar, awaitingEditor, editor }

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

  /// Current position in the flow. Plain (non-reactive) field — it is only
  /// read imperatively by the views that drive the tour.
  OnboardingPhase _phase = OnboardingPhase.idle;

  /// Guards against showing the welcome card twice. Replaying from Settings
  /// navigates Home, which rebuilds [HomeView] and re-fires its own launch —
  /// so both paths can race to open the dialog. Stays true from the moment the
  /// welcome card opens until the flow ends via [complete].
  bool _flowActive = false;

  bool get shouldRun => !_prefs.hasSeenOnboarding;

  /// True after the sidebar tour finished and we are waiting for the session
  /// editor to mount so its tour can begin.
  bool get isAwaitingEditor => _phase == OnboardingPhase.awaitingEditor;

  /// Shows the welcome card and wires its actions into the tour. The single
  /// entry point used both on first launch and when replaying from Settings.
  /// A no-op if a welcome card / tour is already in progress.
  Future<void> launchWelcome(BuildContext context) async {
    if (_flowActive) return;
    _flowActive = true;
    await OnboardingWelcomeCard.show(
      context,
      onStart: beginSidebarTour,
      onSkip: complete,
    );
  }

  /// Resets the flag, returns to Home and replays the whole tour from the
  /// welcome card. Called from the "Show again" tile in Settings.
  void replay(BuildContext context) {
    restart();
    router.go(Routes.home.path);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      launchWelcome(context);
    });
  }

  /// Starts the first (sidebar) leg of the tour. Called from the welcome card's
  /// "Start" action.
  void beginSidebarTour() {
    _phase = OnboardingPhase.sidebar;
    ShowcaseView.get().startShowCase([
      brandKey,
      navOverviewKey,
      navSessionsKey,
      navSettingsKey,
    ]);
  }

  /// Starts the second (editor) leg of the tour. Called by the session editor
  /// once it has mounted; a no-op unless we are waiting for it.
  void startEditorTour() {
    if (_phase != OnboardingPhase.awaitingEditor) return;
    _phase = OnboardingPhase.editor;
    ShowcaseView.get().startShowCase([
      editorDetailsKey,
      editorTimersKey,
      editorBlockedAppsKey,
      // Site blocking is Windows-only, so its target does not exist elsewhere.
      if (onboardingHasSitesStep) editorBlockedSitesKey,
      editorSaveKey,
    ]);
  }

  /// Wired to [ShowcaseView] `onFinish`. Fires when the user taps "Next" past
  /// the last step of a leg.
  void handleShowcaseFinish() {
    switch (_phase) {
      case OnboardingPhase.sidebar:
        _phase = OnboardingPhase.awaitingEditor;
        // Defer navigation until after the overlay teardown frame.
        SchedulerBinding.instance.addPostFrameCallback((_) {
          router.push(Routes.sessionNew.path);
        });
      case OnboardingPhase.editor:
        complete();
      case OnboardingPhase.idle:
      case OnboardingPhase.awaitingEditor:
        break;
    }
  }

  /// Wired to [ShowcaseView] `onDismiss`. Fires when the user taps "Skip" on
  /// any step. Ends the whole onboarding.
  void handleShowcaseDismiss() {
    if (_phase == OnboardingPhase.idle) return;
    complete();
  }

  @action
  void complete() {
    _phase = OnboardingPhase.idle;
    _flowActive = false;
    _prefs.hasSeenOnboarding = true;
  }

  @action
  void restart() {
    _phase = OnboardingPhase.idle;
    _flowActive = false;
    _prefs.hasSeenOnboarding = false;
  }
}
