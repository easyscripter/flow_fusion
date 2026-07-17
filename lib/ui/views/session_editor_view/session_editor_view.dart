import 'package:flow_fusion/controllers/onboarding_controller.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/views/onboarding/widgets/onboarding_tooltip.dart';
import 'package:flow_fusion/ui/views/session_editor_view/session_editor_view_model.dart';
import 'package:flow_fusion/ui/views/session_editor_view/widgets/blocked_apps_section.dart';
import 'package:flow_fusion/ui/views/session_editor_view/widgets/blocked_sites_section.dart';
import 'package:flow_fusion/ui/views/session_editor_view/widgets/session_details_panel.dart';
import 'package:flow_fusion/ui/views/session_editor_view/widgets/session_editor_header_actions.dart';
import 'package:flow_fusion/ui/views/session_editor_view/widgets/session_timers_section.dart';
import 'package:flow_fusion/ui/widgets/app_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:showcaseview/showcaseview.dart';

class SessionEditorView extends StatefulWidget {
  final int? sessionId;

  const SessionEditorView({super.key, this.sessionId});

  @override
  State<SessionEditorView> createState() => _SessionEditorViewState();
}

class _SessionEditorViewState extends State<SessionEditorView> {
  late final SessionEditorViewModel _viewModel;
  late final OnboardingController _onboarding;
  final _scrollController = ScrollController();
  ReactionDisposer? _onboardingTourDisposer;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I.get<SessionEditorViewModel>();
    _onboarding = GetIt.I.get<OnboardingController>();
    _viewModel.init(widget.sessionId);
    _scheduleOnboardingTour();
  }

  /// Starts the editor leg of the onboarding tour once loading finished and the
  /// section widgets (the showcase targets) have been laid out.
  void _scheduleOnboardingTour() {
    if (!_onboarding.isAwaitingEditor) return;
    _onboardingTourDisposer = when(
      (_) => !_viewModel.isLoading,
      () {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _onboarding.startEditorTour();
        });
      },
    );
  }

  @override
  void dispose() {
    _onboardingTourDisposer?.call();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Observer(
        builder: (context) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppPageHeader(
                  title: _viewModel.isEditing
                      ? context.l10n.sessionEditorEditTitle
                      : context.l10n.sessionEditorCreateTitle,
                  subtitle: _viewModel.isEditing
                      ? context.l10n.sessionEditorEditSubtitle
                      : context.l10n.sessionEditorCreateSubtitle,
                  trailing: SessionEditorHeaderActions(viewModel: _viewModel),
                ),
                const SizedBox(height: AppSizes.paddingLarge),
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      Showcase.withWidget(
                        key: _onboarding.editorDetailsKey,
                        container: OnboardingTooltip(
                          title: context.l10n.onboardingEditorDetailsTitle,
                          description:
                              context.l10n.onboardingEditorDetailsDescription,
                          currentStep: 5,
                          totalSteps: onboardingTotalSteps,
                        ),
                        child: SessionDetailsPanel(viewModel: _viewModel),
                      ),
                      const SizedBox(height: AppSizes.paddingLarge),
                      Showcase.withWidget(
                        key: _onboarding.editorTimersKey,
                        container: OnboardingTooltip(
                          title: context.l10n.onboardingEditorTimersTitle,
                          description:
                              context.l10n.onboardingEditorTimersDescription,
                          currentStep: 6,
                          totalSteps: onboardingTotalSteps,
                        ),
                        child: SessionTimersSection(
                          viewModel: _viewModel,
                          onTimerAdded: _scrollToBottom,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingLarge),
                      Showcase.withWidget(
                        key: _onboarding.editorBlockedAppsKey,
                        container: OnboardingTooltip(
                          title: context.l10n.onboardingEditorBlockedAppsTitle,
                          description: context
                              .l10n.onboardingEditorBlockedAppsDescription,
                          currentStep: 7,
                          totalSteps: onboardingTotalSteps,
                        ),
                        child: BlockedAppsSection(viewModel: _viewModel),
                      ),
                      const SizedBox(height: AppSizes.paddingLarge),
                      Showcase.withWidget(
                        key: _onboarding.editorBlockedSitesKey,
                        container: OnboardingTooltip(
                          title: context.l10n.onboardingEditorBlockedSitesTitle,
                          description: context
                              .l10n.onboardingEditorBlockedSitesDescription,
                          currentStep: 8,
                          totalSteps: onboardingTotalSteps,
                        ),
                        child: BlockedSitesSection(viewModel: _viewModel),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
