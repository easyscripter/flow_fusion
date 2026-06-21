import 'package:flow_fusion/enums/routes.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/widgets/app_button.dart';
import 'package:flow_fusion/ui/widgets/app_panel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TimerEmptyState extends StatelessWidget {
  const TimerEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: AppPanel(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_off_outlined,
                  size: 42,
                  color: context.fusionColors.mutedForeground,
                ),
                const SizedBox(height: AppSizes.paddingMedium),
                Text(
                  context.l10n.timerEmptyTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingSmall),
                Text(
                  context.l10n.timerEmptyDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: context.fusionColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingLarge),
                AppButton(
                  label: context.l10n.navSessions,
                  icon: Icons.schedule_rounded,
                  onPressed: () => context.go(Routes.sessions.path),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
