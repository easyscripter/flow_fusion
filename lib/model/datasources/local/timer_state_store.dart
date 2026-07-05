import 'dart:convert';

import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:flow_fusion/model/entity/timer_persisted_state.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TimerStateStore {
  TimerStateStore(this._prefs);

  final Prefs _prefs;

  TimerPersistedState? read() {
    final raw = _prefs.activeTimerState;
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return TimerPersistedState.fromJson(json);
    } catch (e, s) {
      AppLogger.warn('TimerStateStore.read', 'Discarding corrupt state: $e');
      AppLogger.debug('TimerStateStore.read', s);
      return null;
    }
  }

  void write(TimerPersistedState state) {
    _prefs.activeTimerState = jsonEncode(state.toJson());
  }

  void clear() {
    _prefs.activeTimerState = null;
  }
}
