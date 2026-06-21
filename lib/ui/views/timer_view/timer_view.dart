import 'dart:math' as math;

import 'package:flow_fusion/enums/routes.dart';
import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/model/entity/database/session_timer.dart';
import 'package:flow_fusion/ui/app/active_timer_controller.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/widgets/app_badge.dart';
import 'package:flow_fusion/ui/widgets/app_button.dart';
import 'package:flow_fusion/ui/widgets/app_page_header.dart';
import 'package:flow_fusion/ui/widgets/app_panel.dart';
import 'package:flow_fusion/ui/widgets/timer_empty_state.dart';
import 'package:flutter/material.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  final _controller = ActiveTimerController.instance;
  final _routeScrollController = ScrollController();

  int _lastAutoScrolledIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTimerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentStation(animated: false);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTimerChanged);
    _routeScrollController.dispose();
    super.dispose();
  }

  void _handleTimerChanged() {
    if (!mounted) return;
    final index = _controller.currentIndex;
    if (index != _lastAutoScrolledIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCurrentStation();
      });
    }
  }

  void _scrollToCurrentStation({bool animated = true}) {
    if (!_routeScrollController.hasClients || !_controller.hasActiveSession) {
      return;
    }

    final index = _controller.currentIndex;
    if (index < 0) return;

    _lastAutoScrolledIndex = index;
    const itemWidth = 136.0;
    const gap = 8.0;
    final viewport = _routeScrollController.position.viewportDimension;
    final target = (index * (itemWidth + gap)) - (viewport / 2) + (itemWidth / 2);
    final offset = target.clamp(
      0.0,
      _routeScrollController.position.maxScrollExtent,
    );

    if (!animated) {
      _routeScrollController.jumpTo(offset);
      return;
    }

    _routeScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (!_controller.hasActiveSession) {
            return const TimerEmptyState();
          }

          final session = _controller.session!;
          final timer = _controller.currentTimer!;
          final colors = context.fusionColors;
          final typeColor = timer.type == TimerType.work
              ? colors.workColor
              : colors.chillColor;

          return Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppPageHeader(
                  title: context.l10n.timerScreenTitle,
                  subtitle: session.title,
                  trailing: AppBadge(
                    label:
                        '${_controller.currentIndex + 1}/${_controller.timers.length}',
                    icon: Icons.layers_outlined,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingLarge),
                Expanded(
                  child: AppPanel(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final compact = constraints.maxHeight < 640;

                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _TimerProgressCircle(
                                  progress: _controller.progress,
                                  color: typeColor,
                                  timeLabel: _controller.formattedRemaining,
                                  timerLabel: timer.title,
                                  size: compact ? 250 : 320,
                                ),
                                SizedBox(
                                  height: compact
                                      ? AppSizes.paddingMedium
                                      : AppSizes.paddingLarge,
                                ),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    AppBadge(
                                      label: timer.type == TimerType.work
                                          ? context.l10n.timerWork
                                          : context.l10n.timerChill,
                                      icon: timer.type == TimerType.work
                                          ? Icons.bolt_rounded
                                          : Icons.coffee_rounded,
                                    ),
                                    AppBadge(
                                      label: context.l10n.timerPlannedDuration(
                                        math.max(1, timer.plannedDuration.inMinutes).toInt(),
                                      ),
                                      icon: Icons.schedule_rounded,
                                    ),
                                  ],
                                ),
                                if ((timer.description ?? '').trim().isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: AppSizes.paddingMedium,
                                    ),
                                    child: Text(
                                      timer.description!.trim(),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodyLarge
                                          ?.copyWith(
                                            color: colors.mutedForeground,
                                          ),
                                    ),
                                  ),
                                SizedBox(
                                  height: compact
                                      ? AppSizes.paddingMedium
                                      : AppSizes.paddingLarge,
                                ),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: AppSizes.paddingSmall,
                                  runSpacing: AppSizes.paddingSmall,
                                  children: [
                                    SizedBox(
                                      width: 176,
                                      height: 48,
                                      child: AppButton(
                                        label: _controller.isPaused
                                            ? context.l10n.timerResume
                                            : context.l10n.timerPause,
                                        icon: _controller.isPaused
                                            ? Icons.play_arrow_rounded
                                            : Icons.pause_rounded,
                                        onPressed: () async {
                                          if (_controller.isPaused) {
                                            await _controller.resume();
                                            return;
                                          }
                                          await _controller.pause();
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 176,
                                      height: 48,
                                      child: AppButton(
                                        label: context.l10n.timerSkip,
                                        icon: Icons.skip_next_rounded,
                                        variant: AppButtonVariant.secondary,
                                        onPressed: () async {
                                          await _controller.skipCurrentTimer();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSizes.paddingLarge),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    context.l10n.timerQueueTitle,
                                    style: Theme.of(context).textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const SizedBox(height: AppSizes.paddingMedium),
                                SizedBox(
                                  height: 98,
                                  child: SingleChildScrollView(
                                    controller: _routeScrollController,
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        for (var index = 0;
                                            index < _controller.timers.length;
                                            index++) ...[
                                          _QueueItem(
                                            timer: _controller.timers[index],
                                            index: index,
                                            total: _controller.timers.length,
                                            isCurrent:
                                                index == _controller.currentIndex,
                                            isDone:
                                                index < _controller.currentIndex,
                                          ),
                                          if (index < _controller.timers.length - 1)
                                            const SizedBox(width: 8),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TimerProgressCircle extends StatelessWidget {
  final double progress;
  final Color color;
  final String timeLabel;
  final String timerLabel;
  final double size;

  const _TimerProgressCircle({
    required this.progress,
    required this.color,
    required this.timeLabel,
    required this.timerLabel,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CirclePainter(
          progress: progress,
          color: color,
          trackColor: colors.panelMuted,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timeLabel,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                timerLabel,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.mutedForeground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  const _CirclePainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 18.0;
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [color.withValues(alpha: 0.3), color],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      ((2 * math.pi) * progress.clamp(0, 1)).toDouble(),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CirclePainter other) {
    return other.progress != progress ||
        other.color != color ||
        other.trackColor != trackColor;
  }
}

class _QueueItem extends StatelessWidget {
  final SessionTimer timer;
  final int index;
  final int total;
  final bool isCurrent;
  final bool isDone;

  const _QueueItem({
    required this.timer,
    required this.index,
    required this.total,
    required this.isCurrent,
    required this.isDone,
  });

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
                    child: Text(
                      timer.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: labelColor,
                    ),
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
