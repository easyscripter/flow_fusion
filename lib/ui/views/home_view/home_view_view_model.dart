import 'package:flow_fusion/model/datasources/database/dao/focus_log_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'home_view_view_model.g.dart';

class HomeViewViewModel = _HomeViewViewModelBase with _$HomeViewViewModel;

abstract class _HomeViewViewModelBase with Store {
  late SessionDao _sessionDao;
  late FocusLogDao _focusLogDao;

  @observable
  bool isLoading = false;

  /// Минуты фокуса по дням за последний год — источник правды для всех метрик
  /// и тепловой карты (формат, который ждёт `HeatMap.datasets`).
  ///
  /// TODO: заменить синтетические данные на реальный журнал завершённых
  /// фокус-сессий (таблица с временной меткой), когда он появится в схеме.
  @observable
  ObservableMap<DateTime, int> focusByDay = ObservableMap<DateTime, int>();

  @observable
  int totalSessions = 0;

  @computed
  Duration get totalFocus =>
      Duration(minutes: focusByDay.values.fold(0, (sum, m) => sum + m));

  @computed
  Duration get todayFocus => Duration(minutes: focusByDay[_today] ?? 0);

  @computed
  Duration get avgSession {
    final sessions = totalSessions;
    if (sessions == 0) return Duration.zero;
    return Duration(minutes: totalFocus.inMinutes ~/ sessions);
  }

  @action
  Future<void> init() async {
    _sessionDao = GetIt.I.get<SessionDao>();
    _focusLogDao = GetIt.I.get<FocusLogDao>();
    await update();
  }

  @action
  Future<void> update() async {
    debugPrint('[HomeVM] update() called');
    runInAction(() => isLoading = true);
    try {
      final newFocusByDay = await _loadFocusByDay();
      final totalMinutes = newFocusByDay.values.fold(0, (s, m) => s + m);
      debugPrint('[HomeVM] _loadFocusByDay() returned ${newFocusByDay.length} day entries, $totalMinutes total minutes');
      final newTotalSessions = await _sessionDao.countCompletedSessions() ?? 0;
      debugPrint('[HomeVM] countCompletedSessions() returned $newTotalSessions');
      runInAction(() {
        debugPrint('[HomeVM] runInAction: setting focusByDay=${newFocusByDay.length} entries, totalSessions=$newTotalSessions');
        focusByDay = ObservableMap.of(newFocusByDay);
        totalSessions = newTotalSessions;
        isLoading = false;
      });
    } catch (_) {
      runInAction(() => isLoading = false);
      rethrow;
    }
  }

  Future<Map<DateTime, int>> _loadFocusByDay() async {

    final now = DateTime.now();
    final start = DateTime(now.year - 1, now.month, now.day);
    final logs = await _focusLogDao.findWorkFocusBetween(
      start.toIso8601String(),
      now.toIso8601String(),
    );
    debugPrint('[HomeVM] _loadFocusByDay: focus_log returned ${logs.length} rows');
    const int maxMinutesPerDay = 480;
    final result = <DateTime, int>{};
    for (final log in logs) {
      final d = DateTime.parse(log.completedAt);
      final day = DateTime(d.year, d.month, d.day);
      final minutes = Duration(milliseconds: log.durationMs).inMinutes;
      result[day] = ((result[day] ?? 0) + minutes).clamp(0, maxMinutesPerDay);
    }
    result.removeWhere((_, minutes) => minutes <= 0);
    debugPrint('[HomeVM] _loadFocusByDay: built map with ${result.length} days (zeros removed)');
    return result;
  }

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
