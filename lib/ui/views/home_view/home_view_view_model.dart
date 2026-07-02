import 'package:flow_fusion/model/datasources/database/dao/focus_log_dao.dart';
import 'package:flow_fusion/model/entity/database/focus_log.dart';
import 'package:mobx/mobx.dart';

part 'home_view_view_model.g.dart';

class HomeViewViewModel = _HomeViewViewModelBase with _$HomeViewViewModel;

abstract class _HomeViewViewModelBase with Store {
  _HomeViewViewModelBase(this._focusLogDao);

  final FocusLogDao _focusLogDao;

  @observable
  bool isLoading = false;

  @observable
  bool hasError = false;

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
    await update();
  }

  @action
  Future<void> update() async {
    runInAction(() {
      isLoading = true;
      hasError = false;
    });
    try {
      final now = DateTime.now();
      final start = DateTime(now.year - 1, now.month, now.day);
      final runs = await _focusLogDao.findRunsBetween(
        start.toIso8601String(),
        now.toIso8601String(),
      );
      final newFocusByDay = _focusByDayFromRuns(runs);
      final newTotalSessions = runs.length;
      runInAction(() {
        focusByDay = ObservableMap.of(newFocusByDay);
        totalSessions = newTotalSessions;
        isLoading = false;
      });
    } catch (_) {
      runInAction(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  Map<DateTime, int> _focusByDayFromRuns(List<FocusLog> runs) {
    const int maxMinutesPerDay = 480;
    final result = <DateTime, int>{};
    for (final run in runs) {
      final d = DateTime.parse(run.completedAt);
      final day = DateTime(d.year, d.month, d.day);
      final minutes = Duration(milliseconds: run.workMs).inMinutes;
      result[day] = ((result[day] ?? 0) + minutes).clamp(0, maxMinutesPerDay);
    }
    result.removeWhere((_, minutes) => minutes <= 0);
    return result;
  }

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
