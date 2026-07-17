import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flutter/material.dart';

class TimerTypeIcon extends StatelessWidget {
  final TimerType type;

  const TimerTypeIcon({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final isWork = type == TimerType.work;
    final color = isWork ? colors.workColor : colors.chillColor;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.45), width: 1.5),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 8, spreadRadius: 0),
        ],
      ),
      child: Icon(
        isWork ? Icons.bolt_rounded : Icons.coffee_rounded,
        size: 20,
        color: color,
      ),
    );
  }
}
