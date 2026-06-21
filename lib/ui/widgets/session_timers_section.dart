import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/views/session_editor_view/session_editor_view_model.dart';
import 'package:flow_fusion/ui/widgets/session_editor_empty_timers.dart';
import 'package:flow_fusion/ui/widgets/timer_card.dart';
import 'package:flow_fusion/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SessionTimersSection extends StatelessWidget {
  final SessionEditorViewModel viewModel;
  final VoidCallback? onTimerAdded;

  const SessionTimersSection({
    super.key,
    required this.viewModel,
    this.onTimerAdded,
  });

  String _formatDuration(BuildContext context, Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h == 0) return context.l10n.timerDurationMinutes(m);
    if (m == 0) return context.l10n.timerDurationHoursOnly(h);
    return context.l10n.timerDurationHoursMinutes(h, m);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.sessionEditorTimersTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Observer(
              builder: (_) => Text(
                _formatDuration(context, viewModel.totalDuration),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.fusionColors.mutedForeground,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingSmall),
        Row(
          children: [
            AppButton(
              label: context.l10n.sessionEditorAddWork,
              icon: Icons.bolt_rounded,
              variant: AppButtonVariant.secondary,
              onPressed: () {
                viewModel.addTimer(TimerType.work);
                onTimerAdded?.call();
              },
            ),
            const SizedBox(width: AppSizes.paddingSmall),
            AppButton(
              label: context.l10n.sessionEditorAddChill,
              icon: Icons.coffee_rounded,
              variant: AppButtonVariant.secondary,
              onPressed: () {
                viewModel.addTimer(TimerType.chill);
                onTimerAdded?.call();
              },
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        Observer(
          builder: (_) {
            if (viewModel.timers.isEmpty) {
              return const SessionEditorEmptyTimers();
            }
            return ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              itemCount: viewModel.timers.length,
              onReorder: viewModel.reorder,
              proxyDecorator: (child, index, animation) => child,
              itemBuilder: (context, index) {
                final draft = viewModel.timers[index];
                return Padding(
                  key: ValueKey(draft.localId),
                  padding: const EdgeInsets.only(bottom: AppSizes.paddingSmall),
                  child: TimerCard(
                    draft: draft,
                    index: index,
                    editing: true,
                    onRemove: () => viewModel.removeTimer(draft),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
