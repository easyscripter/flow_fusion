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

  const SessionTimersSection({super.key, required this.viewModel});

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
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Observer(
              builder: (_) => Text(
                context.l10n.timerDurationMinutes(
                  viewModel.totalDuration.inMinutes,
                ),
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
              onPressed: () => viewModel.addTimer(TimerType.work),
            ),
            const SizedBox(width: AppSizes.paddingSmall),
            AppButton(
              label: context.l10n.sessionEditorAddChill,
              icon: Icons.coffee_rounded,
              variant: AppButtonVariant.secondary,
              onPressed: () => viewModel.addTimer(TimerType.chill),
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
