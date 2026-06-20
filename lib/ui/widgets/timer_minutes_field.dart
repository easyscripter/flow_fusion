import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/views/session_editor_view/models/timer_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';


class TimerMinutesField extends StatefulWidget {
  final TimerDraft draft;
  final bool editing;

  static const int minMinutes = 1;
  static const int maxMinutes = 100;

  const TimerMinutesField({
    super.key,
    required this.draft,
    this.editing = false,
  });

  @override
  State<TimerMinutesField> createState() => _TimerMinutesFieldState();
}

class _TimerMinutesFieldState extends State<TimerMinutesField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: '${widget.draft.plannedDuration.inMinutes}',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null) return;
    final clamped = parsed
        .clamp(TimerMinutesField.minMinutes, TimerMinutesField.maxMinutes)
        .toInt();
    widget.draft.setPlannedDuration(Duration(minutes: clamped));
  }

  void _normalize() {
    final text = '${widget.draft.plannedDuration.inMinutes}';
    if (_controller.text != text) {
      _controller.text = text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;

    if (!widget.editing) {
      return Observer(
        builder: (_) => Text(
          context.l10n.timerDurationMinutes(
            widget.draft.plannedDuration.inMinutes,
          ),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colors.mutedForeground,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return SizedBox(
      width: 96,
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        onEditingComplete: _normalize,
        onTapOutside: (_) => _normalize(),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          isDense: true,
          suffixText: context.l10n.timerMinutesShort,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide(color: colors.cardBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide(color: colors.cardBorder),
          ),
        ),
      ),
    );
  }
}
