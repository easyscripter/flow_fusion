import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'app_view_model.g.dart';

@lazySingleton
class AppViewModel = _AppViewModelBase with _$AppViewModel;

abstract class _AppViewModelBase with Store {
  final prefs = GetIt.I.get<Prefs>();

  @observable
  ThemeMode themeMode = ThemeMode.system;

  @observable
  PackageInfo? _packageInfo;

  @action
  void init() {
    themeMode = ThemeMode.values[prefs.themeMode ?? 0];
     _packageInfo = GetIt.I.get<PackageInfo>();
  }

  @action
  void setThemeMode(ThemeMode themeMode) {
    prefs.themeMode = themeMode.index;
    this.themeMode = themeMode;
  }

  String get packageVersion => _packageInfo?.version ?? '';
}
