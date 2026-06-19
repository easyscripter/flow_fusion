import 'dart:math';

import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'home_view_view_model.g.dart';

class HomeViewViewModel = _HomeViewViewModelBase with _$HomeViewViewModel;

abstract class _HomeViewViewModelBase with Store {
  late SessionDao _sessionDao;

  @observable
  bool isLoading = false;

  /// Минуты фокуса по дням за последний год — источник правды для всех метрик
  /// и тепловой карты (формат, который ждёт `HeatMap.datasets`).
  ///
  /// TODO: заменить синтетические данные на реальный журнал завершённых
  /// фокус-сессий (таблица с временной меткой), когда он появится в схеме.
  @observable
  ObservableMap<DateTime, int> focusByDay = ObservableMap<DateTime, int>();

  @computed
  int get totalSessions =>
      focusByDay.values.fold(0, (sum, m) => sum + (m / 25).round());

  /// Суммарное время фокуса.
  @computed
  Duration get totalFocus =>
      Duration(minutes: focusByDay.values.fold(0, (sum, m) => sum + m));

  /// Фокус за сегодня.
  @computed
  Duration get todayFocus => Duration(minutes: focusByDay[_today] ?? 0);

  /// Средняя длительность одной сессии.
  @computed
  Duration get avgSession {
    final sessions = totalSessions;
    if (sessions == 0) return Duration.zero;
    return Duration(minutes: totalFocus.inMinutes ~/ sessions);
  }

  @action
  Future<void> init() async {
    _sessionDao = GetIt.I.get<SessionDao>();
    await update();
  }

  @action
  Future<void> update() async {
    try {
      isLoading = true;
      // Реальный список сессий пока используется лишь как сигнал наличия данных;
      // временную карту активности генерируем детерминированно.
      await _sessionDao.findAllSession();
      focusByDay = ObservableMap.of(_generateFocusByDay());
    } finally {
      isLoading = false;
    }
  }

  /// Детерминированная (фиксированный seed) карта активности за 365 дней,
  /// чтобы дашборд выглядел осмысленно до появления реального трекинга.
  Map<DateTime, int> _generateFocusByDay() {
    final rng = Random(42);
    final today = _today;
    final result = <DateTime, int>{};
    for (var i = 0; i < 365; i++) {
      final date = today.subtract(Duration(days: i));
      // ~35% дней без активности, в выходные фокуса меньше.
      final isWeekend = date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday;
      if (rng.nextDouble() < (isWeekend ? 0.55 : 0.3)) continue;
      final sessions = 1 + rng.nextInt(isWeekend ? 3 : 6);
      result[date] = sessions * (20 + rng.nextInt(3) * 5); // 20/25/30 мин на сессию
    }
    return result;
  }

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
