import 'package:flow_fusion/controllers/site_blocker_service.dart';
import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_timer_dao.dart';
import 'package:flow_fusion/model/entity/blocked_app.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/model/entity/database/session_timer.dart';
import 'package:flow_fusion/ui/views/session_editor_view/models/timer_draft.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'session_editor_view_model.g.dart';

@injectable
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
  bool hasError = false;

  @observable
  String title = '';

  @observable
  String description = '';

  @observable
  String? icon;

  @observable
  ObservableList<TimerDraft> timers = ObservableList<TimerDraft>();

  @observable
  ObservableList<BlockedApp> blockedApps = ObservableList<BlockedApp>();

  @observable
  ObservableList<String> blockedSites = ObservableList<String>();

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
      blockedApps = ObservableList<BlockedApp>.of(session.blockedApps);
      blockedSites = ObservableList<String>.of(session.blockedSites);

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
  void addBlockedApp(BlockedApp app) {
    final bool alreadyAdded = blockedApps.any(
      (BlockedApp existing) =>
          existing.bundleId == app.bundleId &&
          existing.executable == app.executable,
    );
    if (!alreadyAdded) blockedApps.add(app);
  }

  @action
  void removeBlockedApp(BlockedApp app) => blockedApps.remove(app);

  @action
  void addBlockedSite(String domain) {
    final String? normalized = SiteBlockerService.normalizeDomain(domain);
    if (normalized == null) return;
    if (!blockedSites.contains(normalized)) blockedSites.add(normalized);
  }

  @action
  void removeBlockedSite(String domain) => blockedSites.remove(domain);

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
    hasError = false;
    try {
      final trimmedDescription = description.trim();
      final descriptionValue = trimmedDescription.isEmpty
          ? null
          : trimmedDescription;

      final int sessionId;
      if (_editingId != null) {
        final current = await _sessionDao.findSessionById(_editingId!);
        if (current == null) {
          hasError = true;
          return false;
        }
        final updated = Session(
          id: _editingId,
          title: title.trim(),
          description: descriptionValue,
          icon: icon,
          status: current.status,
          createdAt: current.createdAt,
          updatedAt: DateTime.now(),
          completedAt: current.completedAt,
          blockedApps: blockedApps.toList(),
          blockedSites: blockedSites.toList(),
        );
        await _sessionDao.updateSession(updated);
        sessionId = _editingId!;
      } else {
        final created = Session.create(
          title: title.trim(),
          description: descriptionValue,
          icon: icon,
          blockedApps: blockedApps.toList(),
          blockedSites: blockedSites.toList(),
        );
        sessionId = await _sessionDao.insertSession(created);
        _editingId = sessionId;
      }

      await _timerDao.deleteTimersForSession(sessionId);

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
    } catch (e, s) {
      AppLogger.error('SessionEditorViewModel.save', e, s);
      hasError = true;
      return false;
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
