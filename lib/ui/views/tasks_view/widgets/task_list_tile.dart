import 'package:flow_fusion/model/entity/database/task.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/widgets/app_icon_button.dart';
import 'package:flow_fusion/utils/duration_formatter.dart';
import 'package:flutter/material.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({
    super.key,
    required this.task,
    required this.totalDuration,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final Duration totalDuration;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              task.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.paddingMedium),
          Text(
            formatFocusDuration(totalDuration),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.mutedForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSizes.paddingSmall),
          AppIconButton(
            icon: Icons.edit_outlined,
            tooltip: context.l10n.taskListTileEdit,
            variant: AppIconButtonVariant.secondary,
            onPressed: onEdit,
          ),
          const SizedBox(width: AppSizes.paddingSmall),
          AppIconButton(
            icon: Icons.delete_outline,
            tooltip: context.l10n.taskListTileDelete,
            variant: AppIconButtonVariant.danger,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
