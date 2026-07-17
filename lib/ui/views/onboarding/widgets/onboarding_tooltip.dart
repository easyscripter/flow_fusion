import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/app_theme_extension.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/widgets/app_button.dart';
import 'package:flow_fusion/ui/widgets/app_panel.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class OnboardingTooltip extends StatelessWidget {
  final String title;
  final String description;
  final int currentStep;
  final int totalSteps;

  const OnboardingTooltip({
    super.key,
    required this.title,
    required this.description,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final FlowFusionColors colors = context.fusionColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isFirst = currentStep <= 1;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 340),
      child: AppPanel(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  context.l10n.onboardingStepCounter(currentStep, totalSteps),
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
                const Spacer(),
                AppButton(
                  label: context.l10n.onboardingSkip,
                  variant: AppButtonVariant.ghost,
                  onPressed: () => ShowcaseView.get().dismiss(),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingSmall),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.mutedForeground,
              ),
            ),
            const SizedBox(height: AppSizes.paddingMedium),
            Row(
              children: [
                if (!isFirst)
                  AppButton(
                    label: context.l10n.onboardingBack,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => ShowcaseView.get().previous(),
                  ),
                const Spacer(),
                AppButton(
                  label: context.l10n.onboardingNext,
                  onPressed: () => ShowcaseView.get().next(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
