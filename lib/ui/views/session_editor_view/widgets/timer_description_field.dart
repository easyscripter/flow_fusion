import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/views/session_editor_view/models/timer_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class TimerDescriptionField extends StatefulWidget {
  final TimerDraft draft;
  final bool editing;

  const TimerDescriptionField({
    super.key,
    required this.draft,
    this.editing = false,
  });

  @override
  State<TimerDescriptionField> createState() => _TimerDescriptionFieldState();
}

class _TimerDescriptionFieldState extends State<TimerDescriptionField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.draft.description);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final style = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: colors.mutedForeground);

    if (!widget.editing) {
      return Observer(
        builder: (_) {
          if (widget.draft.description.trim().isEmpty) {
            return const SizedBox.shrink();
          }
          return Text(
            widget.draft.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: style,
          );
        },
      );
    }

    return TextField(
      controller: _controller,
      onChanged: widget.draft.setDescription,
      textCapitalization: TextCapitalization.sentences,
      minLines: 1,
      maxLines: 2,
      style: style,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.transparent,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        hintText: context.l10n.timerDescriptionHint,
      ),
    );
  }
}
