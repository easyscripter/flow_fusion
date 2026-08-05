import 'package:flow_fusion/controllers/active_timer_controller.dart';
import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/model/entity/active_timer_state.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/views/timer_view/widgets/timer_progress_circle.dart';
import 'package:flow_fusion/ui/views/timer_view/widgets/timer_queue_item.dart';
import 'package:flow_fusion/ui/widgets/app_badge.dart';
import 'package:flow_fusion/ui/widgets/app_icon_button.dart';
import 'package:flow_fusion/ui/widgets/app_page_header.dart';
import 'package:flow_fusion/ui/widgets/app_panel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TimerBody extends StatelessWidget {
  const TimerBody({
    super.key,
    required this.state,
    required this.controller,
    required this.routeScrollController,
    required this.smoothProgress,
  });

  final ActiveTimerState state;
  final ActiveTimerController controller;
  final ScrollController routeScrollController;
  final ValueListenable<double> smoothProgress;

  @override
  Widget build(BuildContext context) {
    final session = state.session!;
    final timer = state.currentTimer!;
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
              label: '${state.currentIndex + 1}/${state.timers.length}',
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
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder<double>(
                            valueListenable: smoothProgress,
                            builder: (context, progress, _) {
                              return TimerProgressCircle(
                                progress: progress,
                                color: typeColor,
                                timeLabel: state.formattedRemaining,
                                timerLabel: timer.title,
                                size: compact ? 250 : 320,
                              );
                            },
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
                                  timer.plannedDuration.inMinutes < 1
                                      ? 1
                                      : timer.plannedDuration.inMinutes,
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
                                    ?.copyWith(color: colors.mutedForeground),
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
                            children: state.awaitingManualAdvance
                                ? [
                                    AppIconButton(
                                      icon: Icons.arrow_forward_rounded,
                                      tooltip: context.l10n.timerNextPhase,
                                      onPressed: () async {
                                        await controller
                                            .advanceToNextPhaseManually();
                                      },
                                    ),
                                    AppIconButton(
                                      icon: Icons.stop_rounded,
                                      tooltip: context.l10n.timerEndSession,
                                      variant: AppIconButtonVariant.danger,
                                      onPressed: () =>
                                          _confirmEndSession(context),
                                    ),
                                  ]
                                : [
                                    AppIconButton(
                                      icon: state.isPaused
                                          ? Icons.play_arrow_rounded
                                          : Icons.pause_rounded,
                                      tooltip: state.isPaused
                                          ? context.l10n.timerResume
                                          : context.l10n.timerPause,
                                      onPressed: () async {
                                        if (state.isPaused) {
                                          await controller.resume();
                                          return;
                                        }
                                        await controller.pause();
                                      },
                                    ),
                                    AppIconButton(
                                      icon: Icons.skip_next_rounded,
                                      tooltip: context.l10n.timerSkip,
                                      variant: AppIconButtonVariant.secondary,
                                      onPressed: () async {
                                        await controller.skipCurrentTimer();
                                      },
                                    ),
                                    AppIconButton(
                                      icon: Icons.stop_rounded,
                                      tooltip: context.l10n.timerEndSession,
                                      variant: AppIconButtonVariant.danger,
                                      onPressed: () =>
                                          _confirmEndSession(context),
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
                            height: 112,
                            child: SingleChildScrollView(
                              controller: routeScrollController,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (
                                    var index = 0;
                                    index < state.timers.length;
                                    index++
                                  ) ...[
                                    TimerQueueItem(
                                      timer: state.timers[index],
                                      index: index,
                                      total: state.timers.length,
                                      isCurrent: index == state.currentIndex,
                                      isDone: index < state.currentIndex,
                                      liveProgress: index == state.currentIndex
                                          ? smoothProgress
                                          : null,
                                    ),
                                    if (index < state.timers.length - 1)
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
  }

  Future<void> _confirmEndSession(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.timerEndSessionModalTitle),
        content: Text(context.l10n.timerEndSessionModalContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.deleteModalCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.timerEndSession),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await controller.endSessionNow();
    }
  }
}
