import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_timer_dao.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'home_view_view_model.g.dart';

class HomeViewViewModel = _HomeViewViewModelBase with _$HomeViewViewModel;

abstract class _HomeViewViewModelBase with Store {
  late SessionDao _sessionDao;
  late SessionTimerDao _timerDao;

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
    _timerDao = GetIt.I.get<SessionTimerDao>();
    await update();
  }

  @action
  Future<void> update() async {
    try {
      isLoading = true;
      focusByDay = ObservableMap.of(await _loadFocusByDay());
      totalSessions = await _sessionDao.countCompletedSessions() ?? 0;
    } finally {
      isLoading = false;
    }
  }

  Future<Map<DateTime, int>> _loadFocusByDay() async {
    final timers = await _timerDao.findCompletedWorkTimers();
    final result = <DateTime, int>{};
    for (final t in timers) {
      final d = t.updatedAt;
      final day = DateTime(d.year, d.month, d.day);
      result[day] = (result[day] ?? 0) +
          (t.actualDuration ?? t.plannedDuration).inMinutes;
    }
    return result;
  }

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
