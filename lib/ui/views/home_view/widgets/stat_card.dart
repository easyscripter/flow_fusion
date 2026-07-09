import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flutter/material.dart';

/// Карточка статистики для дашборда: иконка, крупное значение и подпись.
class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String? caption;
  final double? minHeight;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.caption,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.cardBorder),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight ?? 104),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.accentBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.cardBorder),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    icon,
                    color: colors.accentForeground,
                    size: AppSizes.iconSizeSmall,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.paddingSmall),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.mutedForeground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (caption != null) ...[
                    const SizedBox(height: AppSizes.paddingSmall),
                    Text(
                      caption!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.mutedForeground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
