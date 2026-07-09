import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @brandSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Focus workspace'**
  String get brandSubtitle;

  /// No description provided for @navOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// No description provided for @navSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get navSessions;

  /// No description provided for @navTimer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get navTimer;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @sidebarSectionApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get sidebarSectionApp;

  /// No description provided for @sidebarSectionActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get sidebarSectionActive;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'v{version}'**
  String versionLabel(String version);

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your personal activity and focus'**
  String get homeSubtitle;

  /// No description provided for @badgePomodoro.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro'**
  String get badgePomodoro;

  /// No description provided for @homeOpenSessions.
  ///
  /// In en, this message translates to:
  /// **'Open sessions'**
  String get homeOpenSessions;

  /// No description provided for @homeThemeSettings.
  ///
  /// In en, this message translates to:
  /// **'Theme settings'**
  String get homeThemeSettings;

  /// No description provided for @homeCardSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus sessions'**
  String get homeCardSessionsTitle;

  /// No description provided for @homeCardSessionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open scenarios, review timers, and move to the next cycle without any noise.'**
  String get homeCardSessionsSubtitle;

  /// No description provided for @homeCardThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme & behavior'**
  String get homeCardThemeTitle;

  /// No description provided for @homeCardThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch between light and dark themes while keeping the same strict, calm visual language.'**
  String get homeCardThemeSubtitle;

  /// No description provided for @homeStatTotalSessions.
  ///
  /// In en, this message translates to:
  /// **'Total sessions'**
  String get homeStatTotalSessions;

  /// No description provided for @homeStatTotalFocus.
  ///
  /// In en, this message translates to:
  /// **'Total focus time'**
  String get homeStatTotalFocus;

  /// No description provided for @homeStatTodayFocus.
  ///
  /// In en, this message translates to:
  /// **'Today\'s focus'**
  String get homeStatTodayFocus;

  /// No description provided for @homeStatAvgSession.
  ///
  /// In en, this message translates to:
  /// **'Avg session'**
  String get homeStatAvgSession;

  /// No description provided for @homeStatTotalSessionsCaption.
  ///
  /// In en, this message translates to:
  /// **'Completed focus blocks'**
  String get homeStatTotalSessionsCaption;

  /// No description provided for @homeStatTotalFocusCaption.
  ///
  /// In en, this message translates to:
  /// **'Across all sessions'**
  String get homeStatTotalFocusCaption;

  /// No description provided for @homeStatTodayFocusCaption.
  ///
  /// In en, this message translates to:
  /// **'Keep your streak going'**
  String get homeStatTodayFocusCaption;

  /// No description provided for @homeStatAvgSessionCaption.
  ///
  /// In en, this message translates to:
  /// **'Per focus block'**
  String get homeStatAvgSessionCaption;

  /// No description provided for @homeActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus Map'**
  String get homeActivityTitle;

  /// No description provided for @homeActivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Focus minutes over the last year.'**
  String get homeActivitySubtitle;

  /// No description provided for @homeActivityLess.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get homeActivityLess;

  /// No description provided for @homeActivityMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get homeActivityMore;

  /// No description provided for @sessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsTitle;

  /// No description provided for @sessionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your sessions'**
  String get sessionsSubtitle;

  /// No description provided for @sessionsNew.
  ///
  /// In en, this message translates to:
  /// **'New session'**
  String get sessionsNew;

  /// No description provided for @sessionsStart.
  ///
  /// In en, this message translates to:
  /// **'Start session'**
  String get sessionsStart;

  /// No description provided for @sessionsOpenTimer.
  ///
  /// In en, this message translates to:
  /// **'Open timer'**
  String get sessionsOpenTimer;

  /// No description provided for @sessionsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit session'**
  String get sessionsEdit;

  /// No description provided for @sessionsOpenCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open the timer layout, check the rhythm, and prepare to launch.'**
  String get sessionsOpenCardSubtitle;

  /// No description provided for @sessionsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get sessionsEmptyTitle;

  /// No description provided for @sessionsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Create your first session'**
  String get sessionsEmptyDescription;

  /// No description provided for @sessionsCreateNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Creating a new session is not wired up yet.'**
  String get sessionsCreateNotConnected;

  /// No description provided for @sessionsOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening session: {name}'**
  String sessionsOpening(String name);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Application settings'**
  String get settingsSubtitle;

  /// No description provided for @badgeTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get badgeTheme;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'The system theme is active by default. The light theme keeps the same strict component style without bright accents.'**
  String get settingsThemeDescription;

  /// No description provided for @badgeNeutralSurfaces.
  ///
  /// In en, this message translates to:
  /// **'Neutral surfaces'**
  String get badgeNeutralSurfaces;

  /// No description provided for @badgeSubtleBorders.
  ///
  /// In en, this message translates to:
  /// **'Subtle borders'**
  String get badgeSubtleBorders;

  /// No description provided for @badgeRoundedCorners.
  ///
  /// In en, this message translates to:
  /// **'Rounded corners'**
  String get badgeRoundedCorners;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @settingsSectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsSectionLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @settingsLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get settingsLanguageDescription;

  /// No description provided for @settingsSectionTimer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get settingsSectionTimer;

  /// No description provided for @settingsManualPhaseSwitch.
  ///
  /// In en, this message translates to:
  /// **'Manual phase switching'**
  String get settingsManualPhaseSwitch;

  /// No description provided for @settingsManualPhaseSwitchDescription.
  ///
  /// In en, this message translates to:
  /// **'When on, phases don\'t switch automatically — you tap \"Next phase\" to move on. When off, timers run in automatic mode.'**
  String get settingsManualPhaseSwitchDescription;

  /// No description provided for @settingsSectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsSectionNotifications;

  /// No description provided for @settingsNotificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Timer notifications'**
  String get settingsNotificationsEnabled;

  /// No description provided for @settingsNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Show a notification when a timer or session finishes. If notifications don\'t appear, enable them for Flow Fusion in your system settings.'**
  String get settingsNotificationsDescription;

  /// No description provided for @notificationTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationTestTitle;

  /// No description provided for @notificationTestBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be notified when a timer finishes.'**
  String get notificationTestBody;

  /// No description provided for @notificationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off'**
  String get notificationPermissionTitle;

  /// No description provided for @notificationPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Flow Fusion isn\'t allowed to send notifications. Open the system settings and enable notifications for Flow Fusion, then come back.'**
  String get notificationPermissionMessage;

  /// No description provided for @notificationPermissionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get notificationPermissionOpenSettings;

  /// No description provided for @notificationPermissionCancel.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notificationPermissionCancel;

  /// No description provided for @settingsSectionDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get settingsSectionDiagnostics;

  /// No description provided for @settingsLogs.
  ///
  /// In en, this message translates to:
  /// **'Application logs'**
  String get settingsLogs;

  /// No description provided for @settingsLogsDescription.
  ///
  /// In en, this message translates to:
  /// **'If something goes wrong, open the logs folder and send the file to the developer.'**
  String get settingsLogsDescription;

  /// No description provided for @settingsLogsOpenFolder.
  ///
  /// In en, this message translates to:
  /// **'Open logs folder'**
  String get settingsLogsOpenFolder;

  /// No description provided for @settingsCopyDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Copy info'**
  String get settingsCopyDiagnostics;

  /// No description provided for @settingsDiagnosticsCopied.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics copied to clipboard'**
  String get settingsDiagnosticsCopied;

  /// No description provided for @settingsLogsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Logs are unavailable'**
  String get settingsLogsUnavailable;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'A new version {version} is available'**
  String updateAvailable(String version);

  /// No description provided for @updateActionUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateActionUpdate;

  /// No description provided for @updateActionLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateActionLater;

  /// No description provided for @updateDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading update…'**
  String get updateDownloading;

  /// No description provided for @updateReady.
  ///
  /// In en, this message translates to:
  /// **'Update ready to install'**
  String get updateReady;

  /// No description provided for @updateActionRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart & install'**
  String get updateActionRestart;

  /// No description provided for @updateInstalling.
  ///
  /// In en, this message translates to:
  /// **'Installing…'**
  String get updateInstalling;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get updateFailed;

  /// No description provided for @updateActionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get updateActionRetry;

  /// No description provided for @updateWhatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get updateWhatsNew;

  /// No description provided for @updateWhatsNewTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s new in {version}'**
  String updateWhatsNewTitle(String version);

  /// No description provided for @updateActionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get updateActionClose;

  /// No description provided for @releaseNotesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No release notes for this version.'**
  String get releaseNotesEmpty;

  /// No description provided for @releaseNotesFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load release notes.'**
  String get releaseNotesFailed;

  /// No description provided for @releaseNotesFeatures.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get releaseNotesFeatures;

  /// No description provided for @releaseNotesFixes.
  ///
  /// In en, this message translates to:
  /// **'Fixes'**
  String get releaseNotesFixes;

  /// No description provided for @releaseNotesSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get releaseNotesSecurity;

  /// No description provided for @releaseNotesBreaking.
  ///
  /// In en, this message translates to:
  /// **'Breaking changes'**
  String get releaseNotesBreaking;

  /// No description provided for @releaseNotesOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get releaseNotesOther;

  /// No description provided for @settingsSectionUpdates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get settingsSectionUpdates;

  /// No description provided for @settingsCheckUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get settingsCheckUpdates;

  /// No description provided for @settingsCheckUpdatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Check GitHub for a newer version.'**
  String get settingsCheckUpdatesDescription;

  /// No description provided for @updateChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get updateChecking;

  /// No description provided for @updateUpToDate.
  ///
  /// In en, this message translates to:
  /// **'You have the latest version'**
  String get updateUpToDate;

  /// No description provided for @updateCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t check for updates'**
  String get updateCheckFailed;

  /// No description provided for @timerWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get timerWork;

  /// No description provided for @timerChill.
  ///
  /// In en, this message translates to:
  /// **'Chill'**
  String get timerChill;

  /// No description provided for @timerScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timerScreenTitle;

  /// No description provided for @timerPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get timerPause;

  /// No description provided for @timerResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get timerResume;

  /// No description provided for @timerSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get timerSkip;

  /// No description provided for @timerNextPhase.
  ///
  /// In en, this message translates to:
  /// **'Next phase'**
  String get timerNextPhase;

  /// No description provided for @timerQueueTitle.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get timerQueueTitle;

  /// No description provided for @timerEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No active timer'**
  String get timerEmptyTitle;

  /// No description provided for @timerEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Start a session from the sessions list. Active timer will stay available in the sidebar.'**
  String get timerEmptyDescription;

  /// No description provided for @timerFinishedTitle.
  ///
  /// In en, this message translates to:
  /// **'Timer finished'**
  String get timerFinishedTitle;

  /// No description provided for @timerFinishedBody.
  ///
  /// In en, this message translates to:
  /// **'\"{timerTitle}\" is complete.'**
  String timerFinishedBody(String timerTitle);

  /// No description provided for @timerFinishedNextBody.
  ///
  /// In en, this message translates to:
  /// **'\"{timerTitle}\" is complete. Up next: \"{nextTimerTitle}\".'**
  String timerFinishedNextBody(String timerTitle, String nextTimerTitle);

  /// No description provided for @sessionFinishedTitle.
  ///
  /// In en, this message translates to:
  /// **'Session finished'**
  String get sessionFinishedTitle;

  /// No description provided for @sessionFinishedBody.
  ///
  /// In en, this message translates to:
  /// **'\"{sessionTitle}\" is complete.'**
  String sessionFinishedBody(String sessionTitle);

  /// No description provided for @timerPlannedDuration.
  ///
  /// In en, this message translates to:
  /// **'{minutes,plural, =1{1 min} other{{minutes} min}}'**
  String timerPlannedDuration(int minutes);

  /// No description provided for @timerTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Timer title'**
  String get timerTitleHint;

  /// No description provided for @timerDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get timerDescriptionHint;

  /// No description provided for @timerMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get timerMinutesShort;

  /// No description provided for @timerDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes,plural, =1{{minutes} min} other{{minutes} min}}'**
  String timerDurationMinutes(int minutes);

  /// No description provided for @timerDurationHoursOnly.
  ///
  /// In en, this message translates to:
  /// **'{hours,plural, =1{1 hour} other{{hours} hours}}'**
  String timerDurationHoursOnly(int hours);

  /// No description provided for @timerDurationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours,plural, =1{1 hour} other{{hours} hours}} {minutes} min'**
  String timerDurationHoursMinutes(int hours, int minutes);

  /// No description provided for @sessionEditorCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New session'**
  String get sessionEditorCreateTitle;

  /// No description provided for @sessionEditorEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit session'**
  String get sessionEditorEditTitle;

  /// No description provided for @sessionEditorCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add timers and details, then save.'**
  String get sessionEditorCreateSubtitle;

  /// No description provided for @sessionEditorEditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update the timers and details of this session.'**
  String get sessionEditorEditSubtitle;

  /// No description provided for @sessionEditorIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get sessionEditorIconLabel;

  /// No description provided for @sessionEditorTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get sessionEditorTitleLabel;

  /// No description provided for @sessionEditorTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Deep work'**
  String get sessionEditorTitleHint;

  /// No description provided for @sessionEditorTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get sessionEditorTitleRequired;

  /// No description provided for @sessionEditorDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get sessionEditorDescriptionLabel;

  /// No description provided for @sessionEditorDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What is this session about?'**
  String get sessionEditorDescriptionHint;

  /// No description provided for @sessionEditorTimersTitle.
  ///
  /// In en, this message translates to:
  /// **'Timers'**
  String get sessionEditorTimersTitle;

  /// No description provided for @sessionEditorAddWork.
  ///
  /// In en, this message translates to:
  /// **'Add work'**
  String get sessionEditorAddWork;

  /// No description provided for @sessionEditorAddChill.
  ///
  /// In en, this message translates to:
  /// **'Add chill'**
  String get sessionEditorAddChill;

  /// No description provided for @sessionEditorNoTimers.
  ///
  /// In en, this message translates to:
  /// **'No timers yet. Add a work or chill block to get started.'**
  String get sessionEditorNoTimers;

  /// No description provided for @sessionEditorRemoveTimer.
  ///
  /// In en, this message translates to:
  /// **'Remove timer'**
  String get sessionEditorRemoveTimer;

  /// No description provided for @sessionEditorBlockedAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'Blocked apps'**
  String get sessionEditorBlockedAppsTitle;

  /// No description provided for @sessionEditorBlockedAppsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Closed automatically during work phases.'**
  String get sessionEditorBlockedAppsSubtitle;

  /// No description provided for @sessionEditorAddBlockedApp.
  ///
  /// In en, this message translates to:
  /// **'Add app'**
  String get sessionEditorAddBlockedApp;

  /// No description provided for @sessionEditorNoBlockedApps.
  ///
  /// In en, this message translates to:
  /// **'No apps selected. Add one to close it during work phases.'**
  String get sessionEditorNoBlockedApps;

  /// No description provided for @sessionEditorRemoveBlockedApp.
  ///
  /// In en, this message translates to:
  /// **'Remove app'**
  String get sessionEditorRemoveBlockedApp;

  /// No description provided for @sessionEditorCannotBlockSelf.
  ///
  /// In en, this message translates to:
  /// **'You can\'t block Flow Fusion itself.'**
  String get sessionEditorCannotBlockSelf;

  /// No description provided for @sessionEditorBlockedSitesTitle.
  ///
  /// In en, this message translates to:
  /// **'Blocked websites'**
  String get sessionEditorBlockedSitesTitle;

  /// No description provided for @sessionEditorBlockedSitesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Redirected to a dead end in every browser during work phases. Requires administrator rights.'**
  String get sessionEditorBlockedSitesSubtitle;

  /// No description provided for @sessionEditorBlockedSitesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. youtube.com'**
  String get sessionEditorBlockedSitesHint;

  /// No description provided for @sessionEditorAddBlockedSite.
  ///
  /// In en, this message translates to:
  /// **'Add website'**
  String get sessionEditorAddBlockedSite;

  /// No description provided for @sessionEditorNoBlockedSites.
  ///
  /// In en, this message translates to:
  /// **'No websites added. Enter a domain to block it during work phases.'**
  String get sessionEditorNoBlockedSites;

  /// No description provided for @sessionEditorRemoveBlockedSite.
  ///
  /// In en, this message translates to:
  /// **'Remove website'**
  String get sessionEditorRemoveBlockedSite;

  /// No description provided for @blockedAppsPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an application'**
  String get blockedAppsPickerTitle;

  /// No description provided for @blockedAppsPickerEmpty.
  ///
  /// In en, this message translates to:
  /// **'No applications found.'**
  String get blockedAppsPickerEmpty;

  /// No description provided for @blockedAppsPickerCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get blockedAppsPickerCancel;

  /// No description provided for @sessionEditorSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get sessionEditorSave;

  /// No description provided for @sessionEditorCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get sessionEditorCancel;

  /// No description provided for @sessionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Session'**
  String get sessionDelete;

  /// No description provided for @deleteSessionModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Session'**
  String get deleteSessionModalTitle;

  /// No description provided for @deleteSessionModalContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure for delete session?'**
  String get deleteSessionModalContent;

  /// No description provided for @deleteModalCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get deleteModalCancel;

  /// No description provided for @deleteModalConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteModalConfirm;

  /// No description provided for @showWindow.
  ///
  /// In en, this message translates to:
  /// **'Show Window'**
  String get showWindow;

  /// No description provided for @exitApp.
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get exitApp;

  /// No description provided for @errorLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load data. Please try again.'**
  String get errorLoadFailed;

  /// No description provided for @errorRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get errorRetry;

  /// No description provided for @errorSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the session. Please try again.'**
  String get errorSaveFailed;

  /// No description provided for @errorDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the session. Please try again.'**
  String get errorDeleteFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
