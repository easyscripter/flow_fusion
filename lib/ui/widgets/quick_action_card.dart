import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flutter/material.dart';

class QuickActionCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Icon? icon;
  final String? subtitle;
  final double? maxHeight;
  final double? minHeight;
  final double? maxWidth;
  final double? minWidth;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
    this.subtitle,
    this.maxHeight,
    this.minHeight,
    this.maxWidth,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        hoverColor: colors.cardHover,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: maxHeight ?? AppSizes.cardMaxHeight,
            minHeight: minHeight ?? AppSizes.cardMinHeight,
            maxWidth: maxWidth ?? AppSizes.cardMaxWidth,
            minWidth: minWidth ?? AppSizes.cardMinWidth,
          ),
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.accentBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.cardBorder),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child:
                          icon ??
                          Icon(
                            Icons.arrow_outward_rounded,
                            color: colors.accentForeground,
                            size: AppSizes.iconSizeMedium,
                          ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_upward_rounded,
                    size: 16,
                    color: colors.mutedForeground,
                  ),
                ],
              ),
              const Spacer(flex: 2),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.15,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSizes.paddingSmall),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.mutedForeground,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
