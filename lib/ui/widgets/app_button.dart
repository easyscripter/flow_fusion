import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16),
          const SizedBox(width: 8),
        ],
        Text(label),
      ],
    );

    return switch (variant) {
      AppButtonVariant.primary => ElevatedButton(
        onPressed: onPressed,
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: onPressed,
        child: child,
      ),
      AppButtonVariant.ghost => TextButton(
        onPressed: onPressed,
        child: child,
      ),
    };
  }
}
