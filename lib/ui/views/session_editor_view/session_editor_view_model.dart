import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_timer_dao.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/model/entity/database/session_timer.dart';
import 'package:flow_fusion/ui/views/session_editor_view/models/timer_draft.dart';
import 'package:mobx/mobx.dart';

part 'session_editor_view_model.g.dart';

class SessionEditorViewModel = _SessionEditorViewModelBase
    with _$SessionEditorViewModel;

abstract class _SessionEditorViewModelBase with Store {
  _SessionEditorViewModelBase(this._sessionDao, this._timerDao);

  final SessionDao _sessionDao;
  final SessionTimerDao _timerDao;

  int? _editingId;

  int _nextLocalId = 0;

  @observable
  bool isLoading = false;

  @observable
  bool isSaving = false;

  @observable
  bool showErrors = false;

  @observable
  String title = '';

  @observable
  String description = '';

  @observable
  String? icon;

  @observable
  ObservableList<TimerDraft> timers = ObservableList<TimerDraft>();

  @computed
  bool get isEditing => _editingId != null;

  @computed
  bool get hasTitle => title.trim().isNotEmpty;

  @computed
  bool get canSave => hasTitle && timers.isNotEmpty && !isSaving;

  @computed
  Duration get totalDuration =>
      timers.fold(Duration.zero, (sum, timer) => sum + timer.plannedDuration);

  @action
  Future<void> init(int? sessionId) async {
    _editingId = sessionId;

    if (sessionId == null) {
      timers = ObservableList<TimerDraft>.of([_buildDraft(TimerType.work)]);
      return;
    }

    isLoading = true;
    try {
      final session = await _sessionDao.findSessionById(sessionId);
      if (session == null) {
        _editingId = null;
        timers = ObservableList<TimerDraft>.of([_buildDraft(TimerType.work)]);
        return;
      }
      title = session.title;
      description = session.description ?? '';
      icon = session.icon;

      final exisitinTimers = await _timerDao.findTimersBySessionId(sessionId);
      timers = ObservableList<TimerDraft>.of([
        for (final timer in exisitinTimers)
          TimerDraft(
            localId: _nextLocalId++,
            type: timer.type,
            title: timer.title,
            description: timer.description ?? '',
            plannedDuration: timer.plannedDuration,
          ),
      ]);
    } finally {
      isLoading = false;
    }
  }

  @action
  void setTitle(String value) => title = value;

  @action
  void setDescription(String value) => description = value;

  @action
  void setIcon(String? value) => icon = value;

  @action
  void addTimer(TimerType type) => timers.add(_buildDraft(type));

  @action
  void removeTimer(TimerDraft draft) => timers.remove(draft);

  @action
  void reorder(int oldIndex, int newIndex) {
    var target = newIndex;
    if (target > oldIndex) target -= 1;
    final moved = timers.removeAt(oldIndex);
    timers.insert(target, moved);
  }

  @action
  Future<bool> save() async {
    showErrors = true;
    if (!canSave) return false;

    isSaving = true;
    try {
      final trimmedDescription = description.trim();
      final descriptionValue = trimmedDescription.isEmpty
          ? null
          : trimmedDescription;

      final int sessionId;
      if (_editingId != null) {
        final current = await _sessionDao.findSessionById(_editingId!);
        if (current == null) return false;
        final updated = Session(
          id: _editingId,
          title: title.trim(),
          description: descriptionValue,
          icon: icon,
          status: current.status,
          createdAt: current.createdAt,
          updatedAt: DateTime.now(),
        );
        await _sessionDao.updateSession(updated);
        sessionId = _editingId!;
        // Delete only idle timers — completed/skipped rows are analytics history.
        await _timerDao.deleteIdleTimersForSession(sessionId);
      } else {
        final created = Session.create(
          title: title.trim(),
          description: descriptionValue,
          icon: icon,
        );
        sessionId = await _sessionDao.insertSession(created);
      }

      final entities = <SessionTimer>[
        for (var i = 0; i < timers.length; i++)
          SessionTimer.create(
            sessionId: sessionId,
            position: i,
            title: _resolveTimerTitle(timers[i]),
            description: _resolveTimerDescription(timers[i]),
            type: timers[i].type,
            plannedDuration: timers[i].plannedDuration,
          ),
      ];
      await _timerDao.insertTimers(entities);
      return true;
    } finally {
      isSaving = false;
    }
  }

  TimerDraft _buildDraft(TimerType type) {
    return TimerDraft(
      localId: _nextLocalId++,
      type: type,
      title: type == TimerType.work ? 'Work' : 'Chill',
      description: '',
      plannedDuration: Duration(minutes: type == TimerType.work ? 25 : 5),
    );
  }

  String _resolveTimerTitle(TimerDraft draft) {
    final trimmed = draft.title.trim();
    if (trimmed.isNotEmpty) return trimmed;
    return draft.type == TimerType.work ? 'Focus' : 'Break';
  }

  String? _resolveTimerDescription(TimerDraft draft) {
    final trimmed = draft.description.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
