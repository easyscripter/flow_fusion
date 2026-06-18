import 'package:flow_fusion/enums/phase_type.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flutter/material.dart';

class PhaseTypeBadge extends StatelessWidget {
  final PhaseType type;

  const PhaseTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final isWork = type == PhaseType.work;
    final foreground = isWork ? colors.workColor : colors.chillColor;
    final background = isWork ? colors.accentSoft : colors.successSoft;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isWork ? Icons.bolt_rounded : Icons.coffee_rounded,
            size: 14,
            color: foreground,
          ),
          const SizedBox(width: 6),
          Text(
            isWork ? context.l10n.phaseWork : context.l10n.phaseChill,
            style: TextStyle(
              color: foreground,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
