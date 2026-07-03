import 'dart:io';

import 'package:flow_fusion/l10n/app_localizations.dart';
import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

@lazySingleton
class TimerAlertService {
  TimerAlertService(this._prefs, this._packageInfo);

  /// Stable GUID identifying the Windows notification activation callback.
  /// Must stay constant across launches so the OS keeps associating toasts
  /// with this app.
  static const String _windowsGuid = 'b6f9e3c2-1a4d-4f8e-9c3b-2e7a5d8f1c0b';

  final Prefs _prefs;
  final PackageInfo _packageInfo;

  final FlutterLocalNotificationsPlugin _darwinPlugin =
      FlutterLocalNotificationsPlugin();

  // Created lazily and only on Windows: its constructor loads a Windows-only
  // dynamic library via FFI, which would crash on other platforms.
  FlutterLocalNotificationsWindows? _windowsPlugin;

  bool _initialized = false;
  int _nextId = 0;

  FlutterLocalNotificationsWindows get _windows =>
      _windowsPlugin ??= FlutterLocalNotificationsWindows();

  bool get _isSupportedPlatform => Platform.isMacOS || Platform.isWindows;

  bool get _notificationsAllowed => _prefs.notificationsEnabled;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    if (!_isSupportedPlatform) return;

    if (Platform.isMacOS) {
      await _darwinPlugin.initialize(
        const InitializationSettings(
          macOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
      );
    } else if (Platform.isWindows) {
      await _windows.initialize(
        WindowsInitializationSettings(
          appName: _packageInfo.appName,
          appUserModelId: _packageInfo.packageName,
          guid: _windowsGuid,
        ),
      );
    }
  }

  Future<bool> requestPermission() async {
    await _ensureInitialized();
    if (!_isSupportedPlatform) return false;

    if (Platform.isMacOS) {
      final granted = await _darwinPlugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }

    return true;
  }

  /// Returns whether notifications are currently allowed by the OS.
  ///
  /// macOS reports the real authorization status. Windows has no permission
  /// concept for unpackaged apps, so this returns `true` there.
  Future<bool> checkPermission() async {
    await _ensureInitialized();
    if (!_isSupportedPlatform) return false;

    if (Platform.isMacOS) {
      final options = await _darwinPlugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.checkPermissions();
      return (options?.isEnabled ?? false) ||
          (options?.isProvisionalEnabled ?? false);
    }

    return true;
  }

  Future<void> openSystemNotificationSettings() async {
    final uri = Platform.isWindows
        ? Uri.parse('ms-settings:notifications')
        : Uri.parse(
            'x-apple.systempreferences:com.apple.Notifications-Settings.extension',
          );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> notifyTimerFinished({
    required String timerTitle,
    String? nextTimerTitle,
  }) async {
    if (!_notificationsAllowed) return;
    await _ensureInitialized();
    if (!_isSupportedPlatform) return;

    final l10n = await _loadL10n();
    final safeTimerTitle = _normalizeTitle(
      timerTitle,
      fallback: l10n.timerScreenTitle,
    )!;
    final safeNextTitle = _normalizeTitle(nextTimerTitle);
    final body = safeNextTitle == null
        ? l10n.timerFinishedBody(safeTimerTitle)
        : l10n.timerFinishedNextBody(safeTimerTitle, safeNextTitle);

    await _showNotification(title: l10n.timerFinishedTitle, body: body);
  }

  Future<void> notifySessionFinished({required String sessionTitle}) async {
    if (!_notificationsAllowed) return;
    await _ensureInitialized();
    if (!_isSupportedPlatform) return;

    final l10n = await _loadL10n();
    final safeSessionTitle = _normalizeTitle(
      sessionTitle,
      fallback: l10n.timerScreenTitle,
    )!;

    await _showNotification(
      title: l10n.sessionFinishedTitle,
      body: l10n.sessionFinishedBody(safeSessionTitle),
    );
  }

  /// Shows a one-off confirmation notification, used by the settings toggle to
  /// verify that notifications are delivered.
  Future<void> sendTestNotification() async {
    await _ensureInitialized();
    if (!_isSupportedPlatform) return;

    final l10n = await _loadL10n();
    await _showNotification(
      title: l10n.notificationTestTitle,
      body: l10n.notificationTestBody,
    );
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await init();
  }

  Future<AppLocalizations> _loadL10n() async {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    final supportedLocale = AppLocalizations.supportedLocales.firstWhere(
      (candidate) => candidate.languageCode == locale.languageCode,
      orElse: () => AppLocalizations.supportedLocales.first,
    );
    return AppLocalizations.delegate.load(supportedLocale);
  }

  Future<void> _showNotification({
    required String title,
    required String body,
  }) async {
    final id = _nextId++;

    if (Platform.isMacOS) {
      await _darwinPlugin.show(
        id,
        title,
        body,
        const NotificationDetails(macOS: DarwinNotificationDetails()),
      );
    } else if (Platform.isWindows) {
      await _windows.show(id, title, body);
    }
  }

  String? _normalizeTitle(String? value, {String? fallback}) {
    final trimmed = value?.trim();
    if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    return fallback;
  }
}
