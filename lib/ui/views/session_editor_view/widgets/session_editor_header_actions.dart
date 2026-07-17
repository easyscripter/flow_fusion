import 'package:flow_fusion/controllers/onboarding_controller.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/views/onboarding/widgets/onboarding_tooltip.dart';
import 'package:flow_fusion/ui/views/session_editor_view/session_editor_view_model.dart';
import 'package:flow_fusion/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:showcaseview/showcaseview.dart';

class SessionEditorHeaderActions extends StatelessWidget {
  final SessionEditorViewModel viewModel;

  const SessionEditorHeaderActions({super.key, required this.viewModel});

  Future<void> _save(BuildContext context) async {
    final saved = await viewModel.save();
    if (!context.mounted) return;
    if (saved) {
      context.pop();
    } else if (viewModel.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errorSaveFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final OnboardingController onboarding =
        GetIt.I.get<OnboardingController>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton(
          label: context.l10n.sessionEditorCancel,
          variant: AppButtonVariant.ghost,
          onPressed: () => context.pop(),
        ),
        const SizedBox(width: AppSizes.paddingSmall),
        Showcase.withWidget(
          key: onboarding.editorSaveKey,
          container: OnboardingTooltip(
            title: context.l10n.onboardingEditorSaveTitle,
            description: context.l10n.onboardingEditorSaveDescription,
            currentStep: onboardingSaveStep,
            totalSteps: onboardingTotalSteps,
          ),
          child: Observer(
            builder: (_) => AppButton(
              label: context.l10n.sessionEditorSave,
              icon: Icons.check_rounded,
              onPressed: viewModel.canSave ? () => _save(context) : null,
            ),
          ),
        ),
      ],
    );
  }
}
