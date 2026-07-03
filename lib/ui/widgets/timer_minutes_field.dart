import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/views/session_editor_view/models/timer_draft.dart';
import 'package:flow_fusion/ui/widgets/number_stepper_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class TimerMinutesField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final fill = draft.type == TimerType.work
        ? colors.workSurface
        : colors.chillSurface;

    return Observer(
      builder: (_) => NumberStepperField(
        value: draft.plannedDuration.inMinutes,
        min: minMinutes,
        max: maxMinutes,
        suffixText: context.l10n.timerMinutesShort,
        fillColor: fill,
        showBorder: false,
        onChanged: (value) =>
            draft.setPlannedDuration(Duration(minutes: value)),
      ),
    );
  }
}
