import 'package:flow_fusion/enums/timer_type.dart';
import 'package:mobx/mobx.dart';

part 'timer_draft.g.dart';

class TimerDraft = _TimerDraftBase with _$TimerDraft;

abstract class _TimerDraftBase with Store {
  final int localId;

  final TimerType type;

  @observable
  String title;

  @observable
  String description;

  @observable
  Duration plannedDuration;

  _TimerDraftBase({
    required this.localId,
    required this.type,
    required this.title,
    required this.description,
    required this.plannedDuration,
  });

  @action
  void setTitle(String value) => title = value;

  @action
  void setDescription(String value) => description = value;

  @action
  void setPlannedDuration(Duration value) => plannedDuration = value;
}
