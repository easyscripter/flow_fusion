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
    final background = isWork ? colors.accentSoft : colors.successSoft;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(
        isWork ? Icons.bolt_rounded : Icons.coffee_rounded,
        size: 18,
        color: color,
      ),
    );
  }
}
