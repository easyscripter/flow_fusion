import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  late SharedPreferences _prefs;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _saveThemeMode();
    notifyListeners();
  }

  Future<void> _loadThemeMode() async {
    final themeIndex = _prefs.getInt(_themeKey) ?? 0;
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }

  Future<void> _saveThemeMode() async {
    await _prefs.setInt(_themeKey, _themeMode.index);
  }
}
