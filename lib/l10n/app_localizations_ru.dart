// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get brandSubtitle => 'Focus workspace';

  @override
  String get navOverview => 'Обзор';

  @override
  String get navSessions => 'Сессии';

  @override
  String get navSettings => 'Настройки';

  @override
  String get sidebarSectionApp => 'Приложение';

  @override
  String versionLabel(String version) {
    return 'v$version';
  }

  @override
  String get homeTitle => 'Аналитика';

  @override
  String get homeSubtitle => 'Аналитика вашей активности и фокусировки';

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
      'Откройте сценарии, просмотрите фазы и переходите к следующему циклу без лишнего шума.';

  @override
  String get homeCardThemeTitle => 'Тема и поведение';

  @override
  String get homeCardThemeSubtitle =>
      'Меняйте светлую и темную тему, сохраняя тот же строгий и спокойный визуальный язык.';

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
  String get sessionsOpenCardSubtitle =>
      'Открыть состав фаз, проверить ритм и подготовить запуск.';

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
  String get badgeTheme => 'Theme';

  @override
  String get settingsSectionAppearance => 'Оформление';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeDescription =>
      'Системная тема активна по умолчанию. Светлая тема сохраняет тот же строгий компонентный стиль без ярких акцентов.';

  @override
  String get badgeNeutralSurfaces => 'Neutral surfaces';

  @override
  String get badgeSubtleBorders => 'Subtle borders';

  @override
  String get badgeRoundedCorners => 'Rounded corners';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeDark => 'Темная';

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
  String get timerWork => 'Работа';

  @override
  String get timerChill => 'Отдых';

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
  String get sessionEditorSave => 'Сохранить';

  @override
  String get sessionEditorCancel => 'Отмена';
}
