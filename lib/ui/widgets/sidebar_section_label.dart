import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flutter/material.dart';

class SidebarSectionLabel extends StatelessWidget {
  final String label;

  const SidebarSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: context.fusionColors.mutedForeground,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
