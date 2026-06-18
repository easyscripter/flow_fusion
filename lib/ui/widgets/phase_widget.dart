import 'package:flow_fusion/enums/phase_type.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/widgets/phase_type_badge.dart';
import 'package:flutter/material.dart';

class PhaseWidget extends StatelessWidget {
  final int number;
  final String title;
  final PhaseType type;
  final Duration duration;
  final double width;

  const PhaseWidget({
    super.key,
    this.width = 300.0,
    required this.number,
    required this.title,
    required this.type,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final isWork = type == PhaseType.work;
    final color = isWork ? colors.workColor : colors.chillColor;

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: colors.cardBorder, width: 1.0),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 16,
            backgroundColor: color,
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8.0),
          PhaseTypeBadge(type: type),
          const SizedBox(width: 10.0),
          Text(
            context.l10n.phaseDurationMinutes(duration.inMinutes),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.mutedForeground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
