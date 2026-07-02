import 'package:flow_fusion/ui/app/active_timer_controller.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/constants/session_icons.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SessionCard extends StatelessWidget {
  final Session session;
  final VoidCallback onTap;
  final VoidCallback onStart;
  final VoidCallback onDelete;

  const SessionCard({
    super.key,
    required this.session,
    required this.onTap,
    required this.onStart,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final theme = Theme.of(context);
    final description = session.description;
    final timerController = GetIt.I.get<ActiveTimerController>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.accentBackground,
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusSmall,
                    ),
                    border: Border.all(color: colors.cardBorder),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      SessionIcons.resolve(session.icon),
                      color: colors.accentForeground,
                      size: AppSizes.iconSizeMedium,
                    ),
                  ),
                ),
                const Spacer(),
                AnimatedBuilder(
                  animation: timerController,
                  builder: (context, _) {
                    final isCurrent =
                        timerController.currentSessionId == session.id;
                    return Row(
                      children: [
                        _CardActionButton(
                          tooltip: context.l10n.sessionsEdit,
                          icon: Icons.edit_outlined,
                          onPressed: isCurrent ? null : onTap,
                        ),
                        const SizedBox(width: 8),
                        _CardActionButton(
                          tooltip: context.l10n.sessionDelete,
                          icon: Icons.delete_rounded,
                          onPressed: isCurrent ? null : onDelete,
                        ),
                        const SizedBox(width: 8),
                        _CardActionButton(
                          tooltip: context.l10n.sessionsStart,
                          icon: Icons.play_arrow_rounded,
                          onPressed: isCurrent ? null : onStart,
                          active: !isCurrent,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const Spacer(flex: 2),
            Text(
              session.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            if (description != null && description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.mutedForeground,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _CardActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool active;

  const _CardActionButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;

    return Tooltip(
      message: tooltip,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: active ? colors.accentBackground : colors.panelSoft,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
          border: Border.all(
            color: active ? colors.accentSoft : colors.cardBorder,
          ),
        ),
        child: SizedBox(
          width: 40,
          height: 40,
          child: IconButton(
            onPressed: onPressed,
            tooltip: tooltip,
            icon: Icon(icon, size: 18),
            color: active ? colors.accentForeground : colors.mutedForeground,
            disabledColor: colors.mutedForeground.withValues(alpha: 0.45),
          ),
        ),
      ),
    );
  }
}
