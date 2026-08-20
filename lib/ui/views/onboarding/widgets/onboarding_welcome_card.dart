import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/widgets/app_button.dart';
import 'package:flow_fusion/ui/widgets/app_panel.dart';
import 'package:flow_fusion/ui/widgets/brand_logo.dart';
import 'package:flow_fusion/ui/app/app_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';


class OnboardingWelcomeCard extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onSkip;

  const OnboardingWelcomeCard({
    super.key,
    required this.onStart,
    required this.onSkip,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onStart,
    required VoidCallback onSkip,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return OnboardingWelcomeCard(
          onStart: () {
            Navigator.of(dialogContext).pop();
            onStart();
          },
          onSkip: () {
            Navigator.of(dialogContext).pop();
            onSkip();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: AppPanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandLogo(size: 56),
              const SizedBox(height: AppSizes.paddingMedium),
              Text(
                context.l10n.onboardingWelcomeTitle,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSizes.paddingSmall),
              Text(
                context.l10n.onboardingWelcomeSubtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: context.fusionColors.mutedForeground,
                ),
              ),
              const SizedBox(height: AppSizes.paddingMedium),
              Observer(
                builder: (_) {
                  final appViewModel = GetIt.I.get<AppViewModel>();
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      context.l10n.onboardingAnalyticsOptIn,
                      style: textTheme.bodySmall?.copyWith(
                        color: context.fusionColors.mutedForeground,
                      ),
                    ),
                    value: appViewModel.analyticsOptIn,
                    onChanged: (value) {
                      if (value != null) {
                        appViewModel.setAnalyticsOptIn(value);
                      }
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
              ),
              const SizedBox(height: AppSizes.paddingLarge),
              Row(
                children: [
                  AppButton(
                    label: context.l10n.onboardingSkip,
                    variant: AppButtonVariant.ghost,
                    onPressed: onSkip,
                  ),
                  const Spacer(),
                  AppButton(
                    label: context.l10n.onboardingStart,
                    onPressed: onStart,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
