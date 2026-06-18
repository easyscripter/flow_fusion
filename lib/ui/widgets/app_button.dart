import 'package:flow_fusion/ui/theme/theme_context.dart';
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
      AppButtonVariant.primary => _GradientButton(
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

class _GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const _GradientButton({required this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final scheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null;
    final radius = BorderRadius.circular(11);

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: colors.accent.withValues(alpha: 0.24),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: Ink(
            decoration: BoxDecoration(
              gradient: colors.primaryButtonGradient,
              borderRadius: radius,
            ),
            child: InkWell(
              onTap: onPressed,
              borderRadius: radius,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: DefaultTextStyle.merge(
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  child: IconTheme.merge(
                    data: IconThemeData(color: scheme.onPrimary),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
