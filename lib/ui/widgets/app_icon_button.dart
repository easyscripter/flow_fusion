import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flutter/material.dart';

enum AppIconButtonVariant { primary, secondary, danger }

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.variant = AppIconButtonVariant.primary,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final AppIconButtonVariant variant;

  static const double _size = 44;

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final radius = BorderRadius.circular(AppSizes.borderRadiusMedium);
    final enabled = onPressed != null;

    final Widget button = switch (variant) {
      AppIconButtonVariant.primary => _GradientIconButton(
        icon: icon,
        onPressed: onPressed,
      ),
      AppIconButtonVariant.secondary => Opacity(
        opacity: enabled ? 1 : 0.45,
        child: SizedBox(
          width: _size,
          height: _size,
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: radius),
            ),
            child: Icon(icon, size: AppSizes.iconSizeSmall),
          ),
        ),
      ),
      AppIconButtonVariant.danger => Opacity(
        opacity: enabled ? 1 : 0.45,
        child: SizedBox(
          width: _size,
          height: _size,
          child: Material(
            color: colors.dangerSoft,
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: Icon(
                icon,
                size: AppSizes.iconSizeSmall,
                color: colors.danger,
              ),
            ),
          ),
        ),
      ),
    };

    return Tooltip(message: tooltip, child: button);
  }
}

class _GradientIconButton extends StatelessWidget {
  const _GradientIconButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final scheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null;
    final radius = BorderRadius.circular(AppSizes.borderRadiusMedium);

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
              child: SizedBox(
                width: AppIconButton._size,
                height: AppIconButton._size,
                child: Icon(
                  icon,
                  size: AppSizes.iconSizeSmall,
                  color: scheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
