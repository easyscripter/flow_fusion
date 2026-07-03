import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  final String label;
  final IconData? icon;

  const AppBadge({super.key, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.fusionColors.accentBackground,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.fusionColors.cardBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: context.fusionColors.accentForeground),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: context.fusionColors.accentForeground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
