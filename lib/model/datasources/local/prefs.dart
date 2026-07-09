import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class Prefs {
  final SharedPreferences _prefs;
  Prefs(this._prefs);

  static const String _themeModeKey = 'theme_mode';
  int? get themeMode => _prefs.getInt(_themeModeKey);
  set themeMode(int? value) {
    if (value != null) {
      _prefs.setInt(_themeModeKey, value);
    } else {
      _prefs.remove(_themeModeKey);
    }
  }

  static const String _languageKey = 'language';
  String? get language => _prefs.getString(_languageKey);
  set language(String? value) {
    if (value != null) {
      _prefs.setString(_languageKey, value);
    } else {
      _prefs.remove(_languageKey);
    }
  }

  static const String _activeTimerStateKey = 'active_timer_state';
  String? get activeTimerState => _prefs.getString(_activeTimerStateKey);
  set activeTimerState(String? value) {
    if (value != null) {
      _prefs.setString(_activeTimerStateKey, value);
    } else {
      _prefs.remove(_activeTimerStateKey);
    }
  }

  static const String _notificationsEnabledKey = 'notifications_enabled';
  bool get notificationsEnabled =>
      _prefs.getBool(_notificationsEnabledKey) ?? true;
  set notificationsEnabled(bool value) {
    _prefs.setBool(_notificationsEnabledKey, value);
  }

  static const String _manualPhaseSwitchKey = 'manual_phase_switch';
  bool get manualPhaseSwitch =>
      _prefs.getBool(_manualPhaseSwitchKey) ?? false;
  set manualPhaseSwitch(bool value) {
    _prefs.setBool(_manualPhaseSwitchKey, value);
  }
}
