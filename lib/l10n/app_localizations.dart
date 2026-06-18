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

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'v{version}'**
  String versionLabel(String version);

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A calm focus timer for work sessions and breaks: open scenarios, track phases, and keep your rhythm.'**
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
  /// **'Open scenarios, review phases, and move to the next cycle without any noise.'**
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

  /// No description provided for @sessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsTitle;

  /// No description provided for @sessionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build a library of scenarios for deep focus, short sprints, and steady breaks.'**
  String get sessionsSubtitle;

  /// No description provided for @sessionsNew.
  ///
  /// In en, this message translates to:
  /// **'New session'**
  String get sessionsNew;

  /// No description provided for @sessionsNewCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new focus scenario to the library.'**
  String get sessionsNewCardSubtitle;

  /// No description provided for @sessionsOpenCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open the phase layout, check the rhythm, and prepare to launch.'**
  String get sessionsOpenCardSubtitle;

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

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

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

  /// No description provided for @phaseAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Phase'**
  String get phaseAdd;

  /// No description provided for @phaseStartTimer.
  ///
  /// In en, this message translates to:
  /// **'Start Timer'**
  String get phaseStartTimer;

  /// No description provided for @phaseDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes,plural, =1{{minutes} min} other{{minutes} min}}'**
  String phaseDurationMinutes(int minutes);

  /// No description provided for @phaseWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get phaseWork;

  /// No description provided for @phaseChill.
  ///
  /// In en, this message translates to:
  /// **'Chill'**
  String get phaseChill;
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
