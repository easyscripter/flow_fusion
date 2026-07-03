import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flutter/material.dart';

class AppPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppPanel({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.fusionColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.fusionColors.cardBorder),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSizes.paddingLarge),
        child: child,
      ),
    );
  }
}
