import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:flow_fusion/ui/app/timer_alert_service.dart';
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
  final _timerAlertService = GetIt.I.get<TimerAlertService>();
  static const _defaultThemeMode = ThemeMode.system;

  @observable
  ThemeMode themeMode = _defaultThemeMode;

  @observable
  Locale? locale;

  @observable
  bool notificationsEnabled = true;

  /// Whether the OS currently allows notifications.
  @observable
  bool notificationsGranted = true;

  @computed
  bool get notificationsActive => notificationsEnabled && notificationsGranted;

  @observable
  PackageInfo? _packageInfo;

  AppLifecycleListener? _lifecycleListener;

  @action
  Future<void> init() async {
    themeMode = ThemeMode.values[prefs.themeMode ?? 0];
    final languageCode = prefs.language ?? 'en';
    locale = Locale(languageCode);
    notificationsEnabled = prefs.notificationsEnabled;
    _packageInfo = GetIt.I.get<PackageInfo>();
    await refreshNotificationsPermission();
    _lifecycleListener ??= AppLifecycleListener(
      onResume: refreshNotificationsPermission,
    );
  }

  @action
  Future<void> refreshNotificationsPermission() async {
    final granted = await _timerAlertService.checkPermission();
    runInAction(() => notificationsGranted = granted);
  }

  @action
  void setThemeMode(ThemeMode themeMode) {
    prefs.themeMode = themeMode.index;
    this.themeMode = themeMode;
  }

  @action
  void setLocale(Locale? locale) {
    prefs.language = locale?.languageCode;
    this.locale = locale;
  }

  @action
  Future<bool> setNotificationsEnabled(bool value) async {
    prefs.notificationsEnabled = value;
    notificationsEnabled = value;

    if (!value) return false;

    final granted = await _timerAlertService.requestPermission();
    runInAction(() => notificationsGranted = granted);
    if (granted) {
      await _timerAlertService.sendTestNotification();
    }
    return granted;
  }

  Future<void> openSystemNotificationSettings() =>
      _timerAlertService.openSystemNotificationSettings();

  String get packageVersion => _packageInfo?.version ?? '';
}
