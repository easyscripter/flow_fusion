import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flutter/material.dart';

class SidebarNavButton extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SidebarNavButton({
    super.key,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(12);

    final foreground = selected ? colors.accent : scheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        hoverColor: colors.panelMuted,
        child: Ink(
          decoration: BoxDecoration(
            color: selected ? colors.panelMuted : Colors.transparent,
            borderRadius: radius,
            border: Border.all(
              color: selected
                  ? colors.accent.withValues(alpha: 0.16)
                  : Colors.transparent,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(
                  selected ? selectedIcon : icon,
                  size: 20,
                  color: foreground,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
