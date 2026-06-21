import 'package:audioplayers/audioplayers.dart';
import 'package:flow_fusion/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TimerAlertService {
  TimerAlertService._();

  static final TimerAlertService instance = TimerAlertService._();

  static const String _windowsGuid = 'f612cd84-2a22-4d65-b0c8-4d7b0b82de16';

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _player = AudioPlayer();

  bool _initialized = false;
  int _notificationId = 0;

  Future<void> init() async {
    if (_initialized) return;

    const settings = InitializationSettings(
      macOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      windows: WindowsInitializationSettings(
        appName: 'Flow Fusion',
        appUserModelId: 'Com.FlowFusion.Desktop',
        guid: _windowsGuid,
      ),
    );

    await _notifications.initialize(
      settings: settings,
    );
    await _notifications
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    await _player.setReleaseMode(ReleaseMode.stop);

    _initialized = true;
  }

  Future<void> notifyTimerFinished({
    required String timerTitle,
    String? nextTimerTitle,
  }) async {
    await _ensureInitialized();
    await _playAlert();

    final l10n = await _loadL10n();
    final safeTimerTitle = _normalizeTitle(
      timerTitle,
      fallback: l10n.timerScreenTitle,
    )!;
    final safeNextTitle = _normalizeTitle(nextTimerTitle);
    final body =
        safeNextTitle == null
            ? l10n.timerFinishedBody(safeTimerTitle)
            : l10n.timerFinishedNextBody(safeTimerTitle, safeNextTitle);

    await _showNotification(
      title: l10n.timerFinishedTitle,
      body: body,
    );
  }

  Future<void> notifySessionFinished({required String sessionTitle}) async {
    await _ensureInitialized();
    await _playAlert();

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

  Future<void> _playAlert() async {
    await _player.stop();
    await _player.play(AssetSource('audio/timer_done.wav'));
  }

  Future<void> _showNotification({
    required String title,
    required String body,
  }) async {
    final details = NotificationDetails(
      macOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: false,
      ),
      windows: WindowsNotificationDetails(
        audio: WindowsNotificationAudio.silent(),
      ),
    );

    await _notifications.show(
      id: _notificationId++,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

  String? _normalizeTitle(String? value, {String? fallback}) {
    final trimmed = value?.trim();
    if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    return fallback;
  }
}
