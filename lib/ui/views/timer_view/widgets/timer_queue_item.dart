import 'dart:math' as math;

import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/model/entity/database/session_timer.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flutter/material.dart';

class TimerQueueItem extends StatelessWidget {
  const TimerQueueItem({
    super.key,
    required this.timer,
    required this.index,
    required this.total,
    required this.isCurrent,
    required this.isDone,
  });

  final SessionTimer timer;
  final int index;
  final int total;
  final bool isCurrent;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final typeColor = timer.type == TimerType.work
        ? colors.workColor
        : colors.chillColor;
    final stationColor = isDone || isCurrent ? typeColor : colors.lineStrong;
    final leftVisible = index > 0;
    final rightVisible = index < total - 1;
    final pointSize = isCurrent ? 18.0 : 14.0;
    final pointBorder = isCurrent ? 4.0 : 3.0;
    final labelColor = isCurrent ? stationColor : colors.mutedForeground;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 128,
              height: 24,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (leftVisible)
                    Positioned(
                      left: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutCubic,
                        width: 52,
                        height: 3,
                        color: stationColor.withValues(alpha: 0.7),
                      ),
                    ),
                  if (rightVisible)
                    Positioned(
                      right: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutCubic,
                        width: 52,
                        height: 3,
                        color: stationColor.withValues(alpha: 0.7),
                      ),
                    ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    width: pointSize,
                    height: pointSize,
                    decoration: BoxDecoration(
                      color: isDone
                          ? stationColor
                          : isCurrent
                          ? colors.cardBackground
                          : colors.panelMuted,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: stationColor,
                        width: pointBorder,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: stationColor.withValues(alpha: 0.22),
                                blurRadius: 14,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 128,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                    ),
                    child: Tooltip(
                      message: timer.title,
                      child: Text(
                        timer.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: labelColor),
                    child: Text(
                      context.l10n.timerPlannedDuration(
                        math.max(1, timer.plannedDuration.inMinutes).toInt(),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
