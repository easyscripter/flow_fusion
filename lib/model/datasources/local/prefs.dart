import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class Prefs {
  final SharedPreferences _prefs;
  Prefs(this._prefs);

  static const String _bucketsKey = 'buckets';
  int? get buckets => _prefs.getInt(_bucketsKey);
  set buckets(int? value) {
    if (value != null) {
      _prefs.setInt(_bucketsKey, value);
    } else {
      _prefs.remove(_bucketsKey);
    }
  }

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
}
