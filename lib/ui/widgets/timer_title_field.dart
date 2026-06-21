import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/views/session_editor_view/models/timer_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class TimerTitleField extends StatefulWidget {
  final TimerDraft draft;
  final bool editing;

  const TimerTitleField({super.key, required this.draft, this.editing = false});

  @override
  State<TimerTitleField> createState() => _TimerTitleFieldState();
}

class _TimerTitleFieldState extends State<TimerTitleField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.draft.title);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final fill = widget.draft.type == TimerType.work
        ? colors.workSurface
        : colors.chillSurface;
    final style = Theme.of(
      context,
    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700);

    if (!widget.editing) {
      return Observer(
        builder: (_) => Text(
          widget.draft.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style,
        ),
      );
    }

    return TextField(
      controller: _controller,
      onChanged: widget.draft.setTitle,
      textCapitalization: TextCapitalization.sentences,
      style: style,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: fill,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        hintText: context.l10n.timerTitleHint,
      ),
    );
  }
}
