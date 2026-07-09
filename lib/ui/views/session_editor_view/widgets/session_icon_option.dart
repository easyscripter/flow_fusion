import 'package:flow_fusion/ui/constants/session_icons.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flutter/material.dart';

/// A single selectable session icon used by [SessionIconPicker].
class SessionIconOption extends StatelessWidget {
  final String name;
  final bool selected;
  final VoidCallback onTap;

  const SessionIconOption({
    super.key,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? colors.accentBackground : colors.panelSoft,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? colors.accent : colors.cardBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Icon(
          SessionIcons.resolve(name),
          size: 20,
          color: selected ? colors.accentForeground : colors.mutedForeground,
        ),
      ),
    );
  }
}
