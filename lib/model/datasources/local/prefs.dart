import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

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

// TODO: Add `injectable` to project
final prefs = Prefs();
