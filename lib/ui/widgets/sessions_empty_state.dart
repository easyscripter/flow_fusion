import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';

class SessionsEmptyState extends StatelessWidget {
  final VoidCallback onCreate;

  const SessionsEmptyState({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.accentBackground,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusXL),
                border: Border.all(color: colors.cardBorder),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLarge),
                child: Icon(
                  Icons.layers_outlined,
                  size: AppSizes.iconSizeLarge,
                  color: colors.accentForeground,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingLarge),
            Text(
              context.l10n.sessionsEmptyTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.paddingSmall),
            Text(
              context.l10n.sessionsEmptyDescription,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.mutedForeground,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSizes.paddingLarge),
            AppButton(
              label: context.l10n.sessionsNew,
              icon: Icons.add,
              onPressed: onCreate,
            ),
          ],
        ),
      ),
    );
  }
}
