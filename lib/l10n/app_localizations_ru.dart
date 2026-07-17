// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get brandSubtitle => 'Пространство фокуса';

  @override
  String get navOverview => 'Обзор';

  @override
  String get navSessions => 'Сессии';

  @override
  String get navTimer => 'Таймер';

  @override
  String get navSettings => 'Настройки';

  @override
  String get sidebarSectionApp => 'Приложение';

  @override
  String get sidebarSectionActive => 'Активно';

  @override
  String versionLabel(String version) {
    return 'v$version';
  }

  @override
  String get homeTitle => 'Аналитика';

  @override
  String get homeSubtitle => 'Ваша активность и фокус';

  @override
  String get badgePomodoro => 'Pomodoro';

  @override
  String get homeOpenSessions => 'Открыть сессии';

  @override
  String get homeThemeSettings => 'Настройки темы';

  @override
  String get homeCardSessionsTitle => 'Сессии фокуса';

  @override
  String get homeCardSessionsSubtitle =>
      'Откройте сценарии, проверьте таймеры и переходите к следующему циклу без лишнего шума.';

  @override
  String get homeCardThemeTitle => 'Тема и поведение';

  @override
  String get homeCardThemeSubtitle =>
      'Переключайте светлую и тёмную тему, сохраняя тот же строгий и спокойный визуальный язык.';

  @override
  String get homeStatTotalSessions => 'Всего сессий';

  @override
  String get homeStatTotalFocus => 'Всего фокуса';

  @override
  String get homeStatTodayFocus => 'Фокус сегодня';

  @override
  String get homeStatAvgSession => 'Средняя сессия';

  @override
  String get homeStatTotalSessionsCaption => 'Завершённых блоков фокуса';

  @override
  String get homeStatTotalFocusCaption => 'За все сессии';

  @override
  String get homeStatTodayFocusCaption => 'Не теряйте темп';

  @override
  String get homeStatAvgSessionCaption => 'На один блок фокуса';

  @override
  String get homeActivityTitle => 'Карта фокуса';

  @override
  String get homeActivitySubtitle => 'Минуты фокуса за последний год.';

  @override
  String get homeActivityLess => 'Меньше';

  @override
  String get homeActivityMore => 'Больше';

  @override
  String get sessionsTitle => 'Сессии';

  @override
  String get sessionsSubtitle => 'Ваши сессии';

  @override
  String get sessionsNew => 'Новая сессия';

  @override
  String get sessionsStart => 'Запустить сессию';

  @override
  String get sessionsOpenTimer => 'Открыть таймер';

  @override
  String get sessionsEdit => 'Редактировать сессию';

  @override
  String get sessionsOpenCardSubtitle =>
      'Откройте состав фаз, проверьте ритм и подготовьте запуск.';

  @override
  String get sessionsEmptyTitle => 'Сессий пока нет';

  @override
  String get sessionsEmptyDescription =>
      'Создайте свою первую сессию прямо сейчас';

  @override
  String get sessionsCreateNotConnected =>
      'Создание новой сессии пока не подключено.';

  @override
  String sessionsOpening(String name) {
    return 'Открытие сессии: $name';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSubtitle => 'Настройки приложения';

  @override
  String get badgeTheme => 'Тема';

  @override
  String get settingsSectionAppearance => 'Оформление';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeDescription =>
      'Системная тема активна по умолчанию. Светлая тема сохраняет тот же строгий компонентный стиль без ярких акцентов.';

  @override
  String get badgeNeutralSurfaces => 'Нейтральные поверхности';

  @override
  String get badgeSubtleBorders => 'Мягкие границы';

  @override
  String get badgeRoundedCorners => 'Скруглённые углы';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get settingsSectionLanguage => 'Язык';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get settingsLanguageDescription => 'Выберите предпочитаемый язык';

  @override
  String get settingsSectionTimer => 'Таймер';

  @override
  String get settingsManualPhaseSwitch => 'Ручное переключение фаз';

  @override
  String get settingsManualPhaseSwitchDescription =>
      'Когда включено, фазы не переключаются автоматически — вы сами нажимаете «Следующая фаза», чтобы перейти дальше. Когда выключено, таймеры работают в автоматическом режиме.';

  @override
  String get settingsSectionNotifications => 'Уведомления';

  @override
  String get settingsNotificationsEnabled => 'Уведомления таймера';

  @override
  String get settingsNotificationsDescription =>
      'Показывать уведомление, когда таймер или сессия завершаются. Если уведомления не появляются, включите их для Flow Fusion в системных настройках.';

  @override
  String get notificationTestTitle => 'Уведомления включены';

  @override
  String get notificationTestBody =>
      'Вы получите уведомление, когда таймер завершится.';

  @override
  String get notificationPermissionTitle => 'Уведомления выключены';

  @override
  String get notificationPermissionMessage =>
      'Flow Fusion не разрешено отправлять уведомления. Откройте системные настройки, включите уведомления для Flow Fusion и вернитесь обратно.';

  @override
  String get notificationPermissionOpenSettings => 'Открыть настройки';

  @override
  String get notificationPermissionCancel => 'Не сейчас';

  @override
  String get settingsSectionDiagnostics => 'Диагностика';

  @override
  String get settingsLogs => 'Логи приложения';

  @override
  String get settingsLogsDescription =>
      'Если что-то работает не так, откройте папку с логами и отправьте файл разработчику.';

  @override
  String get settingsLogsOpenFolder => 'Открыть папку с логами';

  @override
  String get settingsCopyDiagnostics => 'Скопировать данные';

  @override
  String get settingsDiagnosticsCopied =>
      'Диагностика скопирована в буфер обмена';

  @override
  String get settingsLogsUnavailable => 'Логи недоступны';

  @override
  String updateAvailable(String version) {
    return 'Доступна новая версия $version';
  }

  @override
  String get updateActionUpdate => 'Обновить';

  @override
  String get updateActionLater => 'Позже';

  @override
  String get updateDownloading => 'Загрузка обновления…';

  @override
  String get updateReady => 'Обновление готово к установке';

  @override
  String get updateActionRestart => 'Перезапустить и установить';

  @override
  String get updateInstalling => 'Установка…';

  @override
  String get updateFailed => 'Не удалось обновиться';

  @override
  String get updateActionRetry => 'Повторить';

  @override
  String get updateWhatsNew => 'Что нового';

  @override
  String updateWhatsNewTitle(String version) {
    return 'Что нового в $version';
  }

  @override
  String get updateActionClose => 'Закрыть';

  @override
  String get releaseNotesEmpty => 'Для этой версии нет описания изменений.';

  @override
  String get releaseNotesFailed => 'Не удалось загрузить список изменений.';

  @override
  String get releaseNotesFeatures => 'Новое';

  @override
  String get releaseNotesFixes => 'Исправления';

  @override
  String get releaseNotesSecurity => 'Безопасность';

  @override
  String get releaseNotesBreaking => 'Важные изменения';

  @override
  String get releaseNotesOther => 'Прочее';

  @override
  String get settingsSectionUpdates => 'Обновления';

  @override
  String get settingsCheckUpdates => 'Проверить обновления';

  @override
  String get settingsCheckUpdatesDescription =>
      'Проверить, есть ли новая версия на GitHub.';

  @override
  String get updateChecking => 'Проверка…';

  @override
  String get updateUpToDate => 'У вас установлена последняя версия';

  @override
  String get updateCheckFailed => 'Не удалось проверить обновления';

  @override
  String get timerWork => 'Работа';

  @override
  String get timerChill => 'Отдых';

  @override
  String get timerScreenTitle => 'Таймер';

  @override
  String get timerPause => 'Пауза';

  @override
  String get timerResume => 'Продолжить';

  @override
  String get timerSkip => 'Пропустить';

  @override
  String get timerNextPhase => 'Следующая фаза';

  @override
  String get timerQueueTitle => 'Очередь';

  @override
  String get timerEmptyTitle => 'Нет активного таймера';

  @override
  String get timerEmptyDescription =>
      'Запустите сессию из списка сессий. Активный таймер останется в сайдбаре.';

  @override
  String get timerFinishedTitle => 'Таймер завершён';

  @override
  String timerFinishedBody(String timerTitle) {
    return '\"$timerTitle\" завершён.';
  }

  @override
  String timerFinishedNextBody(String timerTitle, String nextTimerTitle) {
    return '\"$timerTitle\" завершён. Дальше: \"$nextTimerTitle\".';
  }

  @override
  String get sessionFinishedTitle => 'Сессия завершена';

  @override
  String sessionFinishedBody(String sessionTitle) {
    return '\"$sessionTitle\" завершена.';
  }

  @override
  String timerPlannedDuration(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes мин',
      many: '$minutes мин',
      few: '$minutes мин',
      one: '$minutes мин',
    );
    return '$_temp0';
  }

  @override
  String get timerTitleHint => 'Название таймера';

  @override
  String get timerDescriptionHint => 'Описание (необязательно)';

  @override
  String get timerMinutesShort => 'мин';

  @override
  String timerDurationMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes мин',
      many: '$minutes мин',
      few: '$minutes мин',
      one: '$minutes мин',
    );
    return '$_temp0';
  }

  @override
  String timerDurationHoursOnly(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours часа',
      many: '$hours часов',
      few: '$hours часа',
      one: '1 час',
    );
    return '$_temp0';
  }

  @override
  String timerDurationHoursMinutes(int hours, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours часа',
      many: '$hours часов',
      few: '$hours часа',
      one: '1 час',
    );
    return '$_temp0 $minutes мин';
  }

  @override
  String get sessionEditorCreateTitle => 'Новая сессия';

  @override
  String get sessionEditorEditTitle => 'Редактирование сессии';

  @override
  String get sessionEditorCreateSubtitle =>
      'Добавьте таймеры и детали, затем сохраните.';

  @override
  String get sessionEditorEditSubtitle =>
      'Измените таймеры и детали этой сессии.';

  @override
  String get sessionEditorIconLabel => 'Иконка';

  @override
  String get sessionEditorTitleLabel => 'Название';

  @override
  String get sessionEditorTitleHint => 'напр. Глубокая работа';

  @override
  String get sessionEditorTitleRequired => 'Введите название';

  @override
  String get sessionEditorDescriptionLabel => 'Описание';

  @override
  String get sessionEditorDescriptionHint => 'О чём эта сессия?';

  @override
  String get sessionEditorTimersTitle => 'Таймеры';

  @override
  String get sessionEditorAddWork => 'Добавить работу';

  @override
  String get sessionEditorAddChill => 'Добавить отдых';

  @override
  String get sessionEditorNoTimers =>
      'Пока нет таймеров. Добавьте блок работы или отдыха.';

  @override
  String get sessionEditorRemoveTimer => 'Удалить таймер';

  @override
  String get sessionEditorBlockedAppsTitle => 'Блокируемые приложения';

  @override
  String get sessionEditorBlockedAppsSubtitle =>
      'Автоматически закрываются во время фаз работы.';

  @override
  String get sessionEditorAddBlockedApp => 'Добавить приложение';

  @override
  String get sessionEditorNoBlockedApps =>
      'Приложения не выбраны. Добавьте, чтобы закрывать его во время работы.';

  @override
  String get sessionEditorRemoveBlockedApp => 'Убрать приложение';

  @override
  String get sessionEditorCannotBlockSelf =>
      'Нельзя заблокировать сам Flow Fusion.';

  @override
  String get sessionEditorBlockedSitesTitle => 'Блокируемые сайты';

  @override
  String get sessionEditorBlockedSitesSubtitle =>
      'Во время фаз работы перенаправляются в никуда во всех браузерах. Требуются права администратора.';

  @override
  String get sessionEditorBlockedSitesHint => 'напр. youtube.com';

  @override
  String get sessionEditorAddBlockedSite => 'Добавить сайт';

  @override
  String get sessionEditorNoBlockedSites =>
      'Сайты не добавлены. Введите домен, чтобы блокировать его во время работы.';

  @override
  String get sessionEditorRemoveBlockedSite => 'Убрать сайт';

  @override
  String get blockedAppsPickerTitle => 'Выберите приложение';

  @override
  String get blockedAppsPickerEmpty => 'Приложения не найдены.';

  @override
  String get blockedAppsPickerCancel => 'Отмена';

  @override
  String get sessionEditorSave => 'Сохранить';

  @override
  String get sessionEditorCancel => 'Отмена';

  @override
  String get sessionDelete => 'Удалить сессию';

  @override
  String get deleteSessionModalTitle => 'Удалить сессию';

  @override
  String get deleteSessionModalContent =>
      'Вы действительно хотите удалить данную сессию?';

  @override
  String get deleteModalCancel => 'Отмена';

  @override
  String get deleteModalConfirm => 'Удалить';

  @override
  String get showWindow => 'Открыть';

  @override
  String get exitApp => 'Выйти';

  @override
  String get errorLoadFailed =>
      'Не удалось загрузить данные. Попробуйте ещё раз.';

  @override
  String get errorRetry => 'Повторить';

  @override
  String get errorSaveFailed =>
      'Не удалось сохранить сессию. Попробуйте ещё раз.';

  @override
  String get errorDeleteFailed =>
      'Не удалось удалить сессию. Попробуйте ещё раз.';

  @override
  String get onboardingWelcomeTitle => 'Добро пожаловать в Flow Fusion';

  @override
  String get onboardingWelcomeSubtitle =>
      'Пройдите короткий тур, чтобы узнать, как настраивать сессии фокуса, блокировать отвлечения и оставаться в потоке.';

  @override
  String get onboardingStart => 'Начать тур';

  @override
  String get onboardingBack => 'Назад';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String onboardingStepCounter(int current, int total) {
    return 'Шаг $current из $total';
  }

  @override
  String get onboardingBrandTitle => 'Это Flow Fusion';

  @override
  String get onboardingBrandDescription =>
      'Ваше пространство для сессий глубокого фокуса. Давайте быстро осмотримся.';

  @override
  String get onboardingNavOverviewTitle => 'Обзор';

  @override
  String get onboardingNavOverviewDescription =>
      'Ваша панель — прогресс и запуск сессии одним взглядом.';

  @override
  String get onboardingNavSessionsTitle => 'Сессии';

  @override
  String get onboardingNavSessionsDescription =>
      'Создавайте и настраивайте сессии фокуса: таймеры, блокировка приложений и сайтов.';

  @override
  String get onboardingNavSettingsTitle => 'Настройки';

  @override
  String get onboardingNavSettingsDescription =>
      'Настройте приложение под себя — и повторите этот тур в любой момент.';
}
