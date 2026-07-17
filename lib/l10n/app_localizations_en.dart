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
  String get navTimer => 'Timer';

  @override
  String get navSettings => 'Settings';

  @override
  String get sidebarSectionApp => 'App';

  @override
  String get sidebarSectionActive => 'Active';

  @override
  String versionLabel(String version) {
    return 'v$version';
  }

  @override
  String get homeTitle => 'Analytics';

  @override
  String get homeSubtitle => 'Your personal activity and focus';

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
      'Open scenarios, review timers, and move to the next cycle without any noise.';

  @override
  String get homeCardThemeTitle => 'Theme & behavior';

  @override
  String get homeCardThemeSubtitle =>
      'Switch between light and dark themes while keeping the same strict, calm visual language.';

  @override
  String get homeStatTotalSessions => 'Total sessions';

  @override
  String get homeStatTotalFocus => 'Total focus time';

  @override
  String get homeStatTodayFocus => 'Today\'s focus';

  @override
  String get homeStatAvgSession => 'Avg session';

  @override
  String get homeStatTotalSessionsCaption => 'Completed focus blocks';

  @override
  String get homeStatTotalFocusCaption => 'Across all sessions';

  @override
  String get homeStatTodayFocusCaption => 'Keep your streak going';

  @override
  String get homeStatAvgSessionCaption => 'Per focus block';

  @override
  String get homeActivityTitle => 'Focus Map';

  @override
  String get homeActivitySubtitle => 'Focus minutes over the last year.';

  @override
  String get homeActivityLess => 'Less';

  @override
  String get homeActivityMore => 'More';

  @override
  String get sessionsTitle => 'Sessions';

  @override
  String get sessionsSubtitle => 'Your sessions';

  @override
  String get sessionsNew => 'New session';

  @override
  String get sessionsStart => 'Start session';

  @override
  String get sessionsOpenTimer => 'Open timer';

  @override
  String get sessionsEdit => 'Edit session';

  @override
  String get sessionsOpenCardSubtitle =>
      'Open the timer layout, check the rhythm, and prepare to launch.';

  @override
  String get sessionsEmptyTitle => 'No sessions yet';

  @override
  String get sessionsEmptyDescription => 'Create your first session';

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
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get settingsLanguageDescription => 'Choose your preferred language';

  @override
  String get settingsSectionTimer => 'Timer';

  @override
  String get settingsManualPhaseSwitch => 'Manual phase switching';

  @override
  String get settingsManualPhaseSwitchDescription =>
      'When on, phases don\'t switch automatically — you tap \"Next phase\" to move on. When off, timers run in automatic mode.';

  @override
  String get settingsSectionNotifications => 'Notifications';

  @override
  String get settingsNotificationsEnabled => 'Timer notifications';

  @override
  String get settingsNotificationsDescription =>
      'Show a notification when a timer or session finishes. If notifications don\'t appear, enable them for Flow Fusion in your system settings.';

  @override
  String get notificationTestTitle => 'Notifications enabled';

  @override
  String get notificationTestBody =>
      'You\'ll be notified when a timer finishes.';

  @override
  String get notificationPermissionTitle => 'Notifications are turned off';

  @override
  String get notificationPermissionMessage =>
      'Flow Fusion isn\'t allowed to send notifications. Open the system settings and enable notifications for Flow Fusion, then come back.';

  @override
  String get notificationPermissionOpenSettings => 'Open settings';

  @override
  String get notificationPermissionCancel => 'Not now';

  @override
  String get settingsSectionDiagnostics => 'Diagnostics';

  @override
  String get settingsLogs => 'Application logs';

  @override
  String get settingsLogsDescription =>
      'If something goes wrong, open the logs folder and send the file to the developer.';

  @override
  String get settingsLogsOpenFolder => 'Open logs folder';

  @override
  String get settingsCopyDiagnostics => 'Copy info';

  @override
  String get settingsDiagnosticsCopied => 'Diagnostics copied to clipboard';

  @override
  String get settingsLogsUnavailable => 'Logs are unavailable';

  @override
  String updateAvailable(String version) {
    return 'A new version $version is available';
  }

  @override
  String get updateActionUpdate => 'Update';

  @override
  String get updateActionLater => 'Later';

  @override
  String get updateDownloading => 'Downloading update…';

  @override
  String get updateReady => 'Update ready to install';

  @override
  String get updateActionRestart => 'Restart & install';

  @override
  String get updateInstalling => 'Installing…';

  @override
  String get updateFailed => 'Update failed';

  @override
  String get updateActionRetry => 'Retry';

  @override
  String get updateWhatsNew => 'What\'s new';

  @override
  String updateWhatsNewTitle(String version) {
    return 'What\'s new in $version';
  }

  @override
  String get updateActionClose => 'Close';

  @override
  String get releaseNotesEmpty => 'No release notes for this version.';

  @override
  String get releaseNotesFailed => 'Couldn\'t load release notes.';

  @override
  String get releaseNotesFeatures => 'New';

  @override
  String get releaseNotesFixes => 'Fixes';

  @override
  String get releaseNotesSecurity => 'Security';

  @override
  String get releaseNotesBreaking => 'Breaking changes';

  @override
  String get releaseNotesOther => 'Other';

  @override
  String get settingsSectionUpdates => 'Updates';

  @override
  String get settingsCheckUpdates => 'Check for updates';

  @override
  String get settingsCheckUpdatesDescription =>
      'Check GitHub for a newer version.';

  @override
  String get updateChecking => 'Checking…';

  @override
  String get updateUpToDate => 'You have the latest version';

  @override
  String get updateCheckFailed => 'Couldn\'t check for updates';

  @override
  String get timerWork => 'Work';

  @override
  String get timerChill => 'Chill';

  @override
  String get timerScreenTitle => 'Timer';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerSkip => 'Skip';

  @override
  String get timerNextPhase => 'Next phase';

  @override
  String get timerQueueTitle => 'Route';

  @override
  String get timerEmptyTitle => 'No active timer';

  @override
  String get timerEmptyDescription =>
      'Start a session from the sessions list. Active timer will stay available in the sidebar.';

  @override
  String get timerFinishedTitle => 'Timer finished';

  @override
  String timerFinishedBody(String timerTitle) {
    return '\"$timerTitle\" is complete.';
  }

  @override
  String timerFinishedNextBody(String timerTitle, String nextTimerTitle) {
    return '\"$timerTitle\" is complete. Up next: \"$nextTimerTitle\".';
  }

  @override
  String get sessionFinishedTitle => 'Session finished';

  @override
  String sessionFinishedBody(String sessionTitle) {
    return '\"$sessionTitle\" is complete.';
  }

  @override
  String timerPlannedDuration(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min',
      one: '1 min',
    );
    return '$_temp0';
  }

  @override
  String get timerTitleHint => 'Timer title';

  @override
  String get timerDescriptionHint => 'Description (optional)';

  @override
  String get timerMinutesShort => 'min';

  @override
  String timerDurationMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min',
      one: '$minutes min',
    );
    return '$_temp0';
  }

  @override
  String timerDurationHoursOnly(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String timerDurationHoursMinutes(int hours, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours',
      one: '1 hour',
    );
    return '$_temp0 $minutes min';
  }

  @override
  String get sessionEditorCreateTitle => 'New session';

  @override
  String get sessionEditorEditTitle => 'Edit session';

  @override
  String get sessionEditorCreateSubtitle =>
      'Add timers and details, then save.';

  @override
  String get sessionEditorEditSubtitle =>
      'Update the timers and details of this session.';

  @override
  String get sessionEditorIconLabel => 'Icon';

  @override
  String get sessionEditorTitleLabel => 'Title';

  @override
  String get sessionEditorTitleHint => 'e.g. Deep work';

  @override
  String get sessionEditorTitleRequired => 'Please enter a title';

  @override
  String get sessionEditorDescriptionLabel => 'Description';

  @override
  String get sessionEditorDescriptionHint => 'What is this session about?';

  @override
  String get sessionEditorTimersTitle => 'Timers';

  @override
  String get sessionEditorAddWork => 'Add work';

  @override
  String get sessionEditorAddChill => 'Add chill';

  @override
  String get sessionEditorNoTimers =>
      'No timers yet. Add a work or chill block to get started.';

  @override
  String get sessionEditorRemoveTimer => 'Remove timer';

  @override
  String get sessionEditorBlockedAppsTitle => 'Blocked apps';

  @override
  String get sessionEditorBlockedAppsSubtitle =>
      'Closed automatically during work phases.';

  @override
  String get sessionEditorAddBlockedApp => 'Add app';

  @override
  String get sessionEditorNoBlockedApps =>
      'No apps selected. Add one to close it during work phases.';

  @override
  String get sessionEditorRemoveBlockedApp => 'Remove app';

  @override
  String get sessionEditorCannotBlockSelf =>
      'You can\'t block Flow Fusion itself.';

  @override
  String get sessionEditorBlockedSitesTitle => 'Blocked websites';

  @override
  String get sessionEditorBlockedSitesSubtitle =>
      'Redirected to a dead end in every browser during work phases. Requires administrator rights.';

  @override
  String get sessionEditorBlockedSitesHint => 'e.g. youtube.com';

  @override
  String get sessionEditorAddBlockedSite => 'Add website';

  @override
  String get sessionEditorNoBlockedSites =>
      'No websites added. Enter a domain to block it during work phases.';

  @override
  String get sessionEditorRemoveBlockedSite => 'Remove website';

  @override
  String get blockedAppsPickerTitle => 'Choose an application';

  @override
  String get blockedAppsPickerEmpty => 'No applications found.';

  @override
  String get blockedAppsPickerCancel => 'Cancel';

  @override
  String get sessionEditorSave => 'Save';

  @override
  String get sessionEditorCancel => 'Cancel';

  @override
  String get sessionDelete => 'Delete Session';

  @override
  String get deleteSessionModalTitle => 'Delete Session';

  @override
  String get deleteSessionModalContent => 'Are you sure for delete session?';

  @override
  String get deleteModalCancel => 'Cancel';

  @override
  String get deleteModalConfirm => 'Delete';

  @override
  String get showWindow => 'Show Window';

  @override
  String get exitApp => 'Exit App';

  @override
  String get errorLoadFailed => 'Couldn\'t load data. Please try again.';

  @override
  String get errorRetry => 'Retry';

  @override
  String get errorSaveFailed => 'Couldn\'t save the session. Please try again.';

  @override
  String get errorDeleteFailed =>
      'Couldn\'t delete the session. Please try again.';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Flow Fusion';

  @override
  String get onboardingWelcomeSubtitle =>
      'Take a quick tour to learn how to set up focus sessions, block distractions, and stay in the flow.';

  @override
  String get onboardingStart => 'Start tour';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String onboardingStepCounter(int current, int total) {
    return 'Step $current of $total';
  }
}
