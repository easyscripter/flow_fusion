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
  String get homeTitle => 'Рабочее пространство';

  @override
  String get homeSubtitle =>
      'Спокойный фокус-таймер для рабочих сессий и пауз: открывайте сценарии, следите за фазами и держите ритм.';

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
  String get sessionsTitle => 'Сессии';

  @override
  String get sessionsSubtitle =>
      'Соберите библиотеку сценариев для глубокого фокуса, коротких спринтов и размеренных перерывов.';

  @override
  String get sessionsNew => 'Новая сессия';

  @override
  String get sessionsNewCardSubtitle =>
      'Добавить новый сценарий фокусировки в библиотеку.';

  @override
  String get sessionsOpenCardSubtitle =>
      'Открыть состав фаз, проверить ритм и подготовить запуск.';

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
  String get languageSystem => 'Системный';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get phaseAdd => 'Добавить фазу';

  @override
  String get phaseStartTimer => 'Запустить таймер';

  @override
  String phaseDurationMinutes(int minutes) {
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
  String get phaseWork => 'Работа';

  @override
  String get phaseChill => 'Отдых';
}
