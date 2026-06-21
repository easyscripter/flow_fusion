import 'package:flow_fusion/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:local_notifier/local_notifier.dart';

class TimerAlertService {
  TimerAlertService._();

  static final TimerAlertService instance = TimerAlertService._();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
  }

  Future<void> notifyTimerFinished({
    required String timerTitle,
    String? nextTimerTitle,
  }) async {
    await _ensureInitialized();

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

  Future<void> _showNotification({
    required String title,
    required String body,
  }) async {
    final notification = LocalNotification(
      title: title,
      body: body,
      silent: false,
    );
    await notification.show();
  }

  String? _normalizeTitle(String? value, {String? fallback}) {
    final trimmed = value?.trim();
    if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    return fallback;
  }
}
