// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get brandSubtitle => 'Focus workspace';

  @override
  String get navOverview => 'Overview';

  @override
  String get navSessions => 'Sessions';

  @override
  String get navSettings => 'Settings';

  @override
  String get sidebarSectionApp => 'App';

  @override
  String versionLabel(String version) {
    return 'v$version';
  }

  @override
  String get homeTitle => 'Workspace';

  @override
  String get homeSubtitle =>
      'A calm focus timer for work sessions and breaks: open scenarios, track phases, and keep your rhythm.';

  @override
  String get badgePomodoro => 'Pomodoro';

  @override
  String get homeOpenSessions => 'Open sessions';

  @override
  String get homeThemeSettings => 'Theme settings';

  @override
  String get homeCardSessionsTitle => 'Focus sessions';

  @override
  String get homeCardSessionsSubtitle =>
      'Open scenarios, review phases, and move to the next cycle without any noise.';

  @override
  String get homeCardThemeTitle => 'Theme & behavior';

  @override
  String get homeCardThemeSubtitle =>
      'Switch between light and dark themes while keeping the same strict, calm visual language.';

  @override
  String get sessionsTitle => 'Sessions';

  @override
  String get sessionsSubtitle =>
      'Build a library of scenarios for deep focus, short sprints, and steady breaks.';

  @override
  String get sessionsNew => 'New session';

  @override
  String get sessionsNewCardSubtitle =>
      'Add a new focus scenario to the library.';

  @override
  String get sessionsOpenCardSubtitle =>
      'Open the phase layout, check the rhythm, and prepare to launch.';

  @override
  String get sessionsCreateNotConnected =>
      'Creating a new session is not wired up yet.';

  @override
  String sessionsOpening(String name) {
    return 'Opening session: $name';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Application settings';

  @override
  String get badgeTheme => 'Theme';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeDescription =>
      'The system theme is active by default. The light theme keeps the same strict component style without bright accents.';

  @override
  String get badgeNeutralSurfaces => 'Neutral surfaces';

  @override
  String get badgeSubtleBorders => 'Subtle borders';

  @override
  String get badgeRoundedCorners => 'Rounded corners';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get settingsSectionLanguage => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get phaseAdd => 'Add Phase';

  @override
  String get phaseStartTimer => 'Start Timer';

  @override
  String phaseDurationMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min',
      one: '$minutes min',
    );
    return '$_temp0';
  }

  @override
  String get phaseWork => 'Work';

  @override
  String get phaseChill => 'Chill';
}
