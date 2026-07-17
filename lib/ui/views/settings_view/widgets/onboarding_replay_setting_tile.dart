import 'package:flow_fusion/controllers/onboarding_controller.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/views/settings_view/widgets/setting_row.dart';
import 'package:flow_fusion/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class OnboardingReplaySettingTile extends StatelessWidget {
  const OnboardingReplaySettingTile({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController onboarding =
        GetIt.I.get<OnboardingController>();

    return SettingRow(
      title: context.l10n.settingsOnboardingReplay,
      description: context.l10n.settingsOnboardingReplayDescription,
      control: AppButton(
        label: context.l10n.settingsOnboardingReplayButton,
        variant: AppButtonVariant.secondary,
        onPressed: () => onboarding.replay(context),
      ),
    );
  }
}
