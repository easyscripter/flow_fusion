import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'settings_view_view_model.g.dart';

class SettingsViewViewModel = _SettingsViewViewModelBase
    with _$SettingsViewViewModel;

abstract class _SettingsViewViewModelBase with Store {
  final prefs = GetIt.I.get<Prefs>();

  @computed
  ThemeMode get themeMode => ThemeMode.values[prefs.themeMode ?? 0];

  @action
  void setThemeMode(ThemeMode themeMode) {
    prefs.themeMode = themeMode.index;
  }
}
