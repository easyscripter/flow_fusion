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
}
