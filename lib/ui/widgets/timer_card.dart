import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/views/session_editor_view/models/timer_draft.dart';
import 'package:flow_fusion/ui/widgets/timer_description_field.dart';
import 'package:flow_fusion/ui/widgets/timer_minutes_field.dart';
import 'package:flow_fusion/ui/widgets/timer_title_field.dart';
import 'package:flow_fusion/ui/widgets/timer_type_icon.dart';
import 'package:flutter/material.dart';

class TimerCard extends StatelessWidget {
  final TimerDraft draft;

  final int index;

  final bool editing;
  final VoidCallback? onRemove;

  const TimerCard({
    super.key,
    required this.draft,
    required this.index,
    this.editing = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final isWork = draft.type == TimerType.work;
    final background = isWork ? colors.workSurface : colors.chillSurface;
    final borderColor = isWork ? colors.workColor : colors.chillColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          if (editing)
            ReorderableDragStartListener(
              index: index,
              child: Icon(
                Icons.drag_indicator_rounded,
                color: colors.mutedForeground,
                size: 20,
              ),
            )
          else
            SizedBox(
              width: 20,
              child: Text(
                '${index + 1}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.mutedForeground,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          const SizedBox(width: 8),
          TimerTypeIcon(type: draft.type),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TimerTitleField(draft: draft, editing: editing),
                const SizedBox(height: 4),
                TimerDescriptionField(draft: draft, editing: editing),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TimerMinutesField(draft: draft, editing: editing),
          if (editing) ...[
            const SizedBox(width: 4),
            IconButton(
              tooltip: context.l10n.sessionEditorRemoveTimer,
              onPressed: onRemove,
              icon: Icon(Icons.close_rounded, size: 18, color: colors.danger),
            ),
          ],
        ],
      ),
    );
  }
}
