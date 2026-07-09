import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flutter/material.dart';

class SessionEditorEmptyTimers extends StatelessWidget {
  const SessionEditorEmptyTimers({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        color: colors.panelSoft,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Text(
        context.l10n.sessionEditorNoTimers,
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: colors.mutedForeground),
      ),
    );
  }
}
