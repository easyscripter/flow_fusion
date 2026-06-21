# Graph Report - .  (2026-06-21)

## Corpus Check
- 157 files · ~129,483 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1137 nodes · 1454 edges · 90 communities (83 shown, 7 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 16 edges (avg confidence: 0.83)
- Token cost: 0 input · 56,420 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Localization & Theme Strings|Localization & Theme Strings]]
- [[_COMMUNITY_App Localizations (EN)|App Localizations (EN)]]
- [[_COMMUNITY_App Localizations (RU)|App Localizations (RU)]]
- [[_COMMUNITY_Windows Runner (Win32)|Windows Runner (Win32)]]
- [[_COMMUNITY_macOS Plugin Registration|macOS Plugin Registration]]
- [[_COMMUNITY_Session Editor ViewModel|Session Editor ViewModel]]
- [[_COMMUNITY_Theme Color Extension|Theme Color Extension]]
- [[_COMMUNITY_App Sizes Constants|App Sizes Constants]]
- [[_COMMUNITY_Build & Dependency Config|Build & Dependency Config]]
- [[_COMMUNITY_package_info_plus Pod|package_info_plus Pod]]
- [[_COMMUNITY_package_info_plus Podspec|package_info_plus Podspec]]
- [[_COMMUNITY_screen_retriever Podspec|screen_retriever Podspec]]
- [[_COMMUNITY_window_manager Podspec|window_manager Podspec]]
- [[_COMMUNITY_Routes & Sidebar Nav|Routes & Sidebar Nav]]
- [[_COMMUNITY_App Root & Router|App Root & Router]]
- [[_COMMUNITY_Timer Type & Draft Model|Timer Type & Draft Model]]
- [[_COMMUNITY_Session Card Widget|Session Card Widget]]
- [[_COMMUNITY_Session DAOs|Session DAOs]]
- [[_COMMUNITY_App ViewModel|App ViewModel]]
- [[_COMMUNITY_Session Timer Entity|Session Timer Entity]]
- [[_COMMUNITY_App Dropdown & Stat Grid|App Dropdown & Stat Grid]]
- [[_COMMUNITY_Sidebar Brand Widgets|Sidebar Brand Widgets]]
- [[_COMMUNITY_Sessions View|Sessions View]]
- [[_COMMUNITY_Dependency Injection Config|Dependency Injection Config]]
- [[_COMMUNITY_App Badge & Nav Button|App Badge & Nav Button]]
- [[_COMMUNITY_Session Icon Picker|Session Icon Picker]]
- [[_COMMUNITY_Session Editor Header Actions|Session Editor Header Actions]]
- [[_COMMUNITY_Timer Minutes Field|Timer Minutes Field]]
- [[_COMMUNITY_Home View ViewModel|Home View ViewModel]]
- [[_COMMUNITY_Session Entity|Session Entity]]
- [[_COMMUNITY_Page Header & Setting Row|Page Header & Setting Row]]
- [[_COMMUNITY_DB Type Converters|DB Type Converters]]
- [[_COMMUNITY_App Database (sqflite)|App Database (sqflite)]]
- [[_COMMUNITY_Windows main.cpp Entry|Windows main.cpp Entry]]
- [[_COMMUNITY_Session Editor View|Session Editor View]]
- [[_COMMUNITY_Settings View|Settings View]]
- [[_COMMUNITY_Session Details Panel|Session Details Panel]]
- [[_COMMUNITY_App Button Widget|App Button Widget]]
- [[_COMMUNITY_Home View|Home View]]
- [[_COMMUNITY_Quick Action Card|Quick Action Card]]
- [[_COMMUNITY_Shared Preferences Wrapper|Shared Preferences Wrapper]]
- [[_COMMUNITY_App Entry (main.dart)|App Entry (main.dart)]]
- [[_COMMUNITY_Timer Card Widget|Timer Card Widget]]
- [[_COMMUNITY_Stateful Widget Bases|Stateful Widget Bases]]
- [[_COMMUNITY_Windows FlutterWindow|Windows FlutterWindow]]
- [[_COMMUNITY_Timer Title Field|Timer Title Field]]
- [[_COMMUNITY_Home Stats Row|Home Stats Row]]
- [[_COMMUNITY_Session Icons Resolver|Session Icons Resolver]]
- [[_COMMUNITY_Stat Card Widget|Stat Card Widget]]
- [[_COMMUNITY_Sessions View ViewModel|Sessions View ViewModel]]
- [[_COMMUNITY_Timer Description Field|Timer Description Field]]
- [[_COMMUNITY_Localization Context|Localization Context]]
- [[_COMMUNITY_iOS Framework Signing|iOS Framework Signing]]
- [[_COMMUNITY_Theme Context Extension|Theme Context Extension]]
- [[_COMMUNITY_MobX Store Bases|MobX Store Bases]]
- [[_COMMUNITY_App Panel Widget|App Panel Widget]]
- [[_COMMUNITY_Flutter LLDB Helper|Flutter LLDB Helper]]
- [[_COMMUNITY_AppLocalizations Delegate|AppLocalizations Delegate]]
- [[_COMMUNITY_Sessions Empty State|Sessions Empty State]]
- [[_COMMUNITY_Home Activity Heatmap|Home Activity Heatmap]]
- [[_COMMUNITY_App Theme Builder|App Theme Builder]]
- [[_COMMUNITY_DAO Singletons|DAO Singletons]]
- [[_COMMUNITY_App Branding Assets|App Branding Assets]]
- [[_COMMUNITY_Timer View|Timer View]]
- [[_COMMUNITY_Froom Database Annotations|Froom Database Annotations]]
- [[_COMMUNITY_Android Plugin Registrant|Android Plugin Registrant]]
- [[_COMMUNITY_Session Editor Empty Timers|Session Editor Empty Timers]]
- [[_COMMUNITY_Delete DAO Methods|Delete DAO Methods]]
- [[_COMMUNITY_Database Entities|Database Entities]]
- [[_COMMUNITY_Factory Methods|Factory Methods]]
- [[_COMMUNITY_Android MainActivity|Android MainActivity]]
- [[_COMMUNITY_iOS Plugin Registrant|iOS Plugin Registrant]]
- [[_COMMUNITY_Windows FlutterWindow Header|Windows FlutterWindow Header]]
- [[_COMMUNITY_Flutter Export Env (a)|Flutter Export Env (a)]]
- [[_COMMUNITY_Flutter Export Env (b)|Flutter Export Env (b)]]
- [[_COMMUNITY_iOS Launch Screen Assets|iOS Launch Screen Assets]]

## God Nodes (most connected - your core abstractions)
1. `flow_fusion pubspec Manifest` - 12 edges
2. `_` - 11 edges
3. `Create()` - 10 edges
4. `MessageHandler()` - 10 edges
5. `WndProc()` - 9 edges
6. `Foundation` - 8 edges
7. `AppLocalizations` - 7 edges
8. `HWND` - 7 edges
9. `WindowClassRegistrar` - 7 edges
10. `Destroy()` - 7 edges

## Surprising Connections (you probably didn't know these)
- `FlowFusion iOS App Icon (1024x1024)` --semantically_similar_to--> `FlowFusion App Logo`  [INFERRED] [semantically similar]
  ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png → assets/images/app_logo.png
- `Pomodoro Timer with Focus Mode` --conceptually_related_to--> `flow_fusion pubspec Manifest`  [INFERRED]
  README.md → pubspec.yaml
- `flutter_lints Ruleset` --references--> `flow_fusion pubspec Manifest`  [INFERRED]
  analysis_options.yaml → pubspec.yaml
- `l10n Localization Configuration` --shares_data_with--> `flow_fusion pubspec Manifest`  [INFERRED]
  l10n.yaml → pubspec.yaml
- `Build Runner Code Generation` --conceptually_related_to--> `Freezed Immutable Models`  [INFERRED]
  README.md → pubspec.yaml

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Windows Flutter Build Pipeline** — windows_cmakelists, flutter_cmakelists, runner_cmakelists, flutter_flutter_assemble [EXTRACTED 0.85]
- **Code Generation Stack** — readme_build_runner, pubspec_freezed, pubspec_mobx, pubspec_injectable_getit [INFERRED 0.75]

## Communities (90 total, 7 thin omitted)

### Community 0 - "Localization & Theme Strings"
Cohesion: 0.02
Nodes (88): app_localizations_en.dart, app_localizations_ru.dart, badgeNeutralSurfaces, badgePomodoro, badgeRoundedCorners, badgeSubtleBorders, badgeTheme, brandSubtitle (+80 more)

### Community 1 - "App Localizations (EN)"
Cohesion: 0.03
Nodes (75): app_localizations.dart, badgeNeutralSurfaces, badgePomodoro, badgeRoundedCorners, badgeSubtleBorders, badgeTheme, brandSubtitle, homeActivityLess (+67 more)

### Community 2 - "App Localizations (RU)"
Cohesion: 0.03
Nodes (75): badgeNeutralSurfaces, badgePomodoro, badgeRoundedCorners, badgeSubtleBorders, badgeTheme, brandSubtitle, homeActivityLess, homeActivityMore (+67 more)

### Community 3 - "Windows Runner (Win32)"
Cohesion: 0.09
Nodes (34): RegisterPlugins(), PluginRegistry, Point, RECT, OnCreate(), Create(), Destroy(), EnableFullDpiSupportIfAvailable() (+26 more)

### Community 4 - "macOS Plugin Registration"
Cohesion: 0.07
Nodes (25): Any, Cocoa, Flutter, RegisterGeneratedPlugins(), FlutterAppDelegate, FlutterMacOS, FlutterPluginRegistry, Bool (+17 more)

### Community 5 - "Session Editor ViewModel"
Cohesion: 0.08
Nodes (30): @action, bool get, ObservableList, addTimer, _buildDraft, canSave, description, _editingId (+22 more)

### Community 6 - "Theme Color Extension"
Cohesion: 0.07
Nodes (29): Color, Color get, Gradient get, accent, accentBackground, accentForeground, accentSoft, accentStrong (+21 more)

### Community 7 - "App Sizes Constants"
Cohesion: 0.07
Nodes (26): AppSizes, borderRadiusLarge, borderRadiusMedium, borderRadiusSmall, borderRadiusXL, cardMaxHeight, cardMaxWidth, cardMinHeight (+18 more)

### Community 8 - "Build & Dependency Config"
Cohesion: 0.12
Nodes (22): Dart Analyzer Configuration, flutter_lints Ruleset, Flutter-level CMake Build, flutter_assemble Build Target, flutter_wrapper_app Library, l10n Localization Configuration, flow_fusion pubspec Manifest, Freezed Immutable Models (+14 more)

### Community 9 - "package_info_plus Pod"
Cohesion: 0.09
Nodes (15): Foundation, NSObject, NSObject, NSObject, NSObject, NSObject, NSObject, NSObject (+7 more)

### Community 10 - "package_info_plus Podspec"
Cohesion: 0.09
Nodes (21): authors, Flutter Community, dependencies, FlutterMacOS, description, homepage, license, file (+13 more)

### Community 11 - "screen_retriever Podspec"
Cohesion: 0.10
Nodes (20): authors, Your Company, dependencies, FlutterMacOS, description, homepage, license, file (+12 more)

### Community 12 - "window_manager Podspec"
Cohesion: 0.10
Nodes (20): authors, LiJianying, dependencies, FlutterMacOS, description, homepage, license, file (+12 more)

### Community 13 - "Routes & Sidebar Nav"
Cohesion: 0.11
Nodes (17): path, Routes, sessionEditPathFor, package:flow_fusion/ui/widgets/sidebar_brand.dart, package:flow_fusion/ui/widgets/sidebar_nav_button.dart, package:flow_fusion/ui/widgets/sidebar_section_label.dart, build, icon (+9 more)

### Community 14 - "App Root & Router"
Cohesion: 0.12
Nodes (16): _appViewModel, build, createState, initState, router, AppViewModel, package:flow_fusion/ui/app/app_view_model.dart, package:flow_fusion/ui/app/router.dart (+8 more)

### Community 15 - "Timer Type & Draft Model"
Cohesion: 0.12
Nodes (15): id, TimerType, description, localId, plannedDuration, setDescription, setPlannedDuration, setTitle (+7 more)

### Community 16 - "Session Card Widget"
Cohesion: 0.12
Nodes (15): package:flow_fusion/model/entity/database/session.dart, package:flow_fusion/ui/constants/app_sizes.dart, package:flow_fusion/ui/widgets/session_card.dart, Session, BrandLogo, build, size, build (+7 more)

### Community 17 - "Session DAOs"
Cohesion: 0.17
Nodes (15): @Insert, @Query, @update, clear, findAllSession, findSessionById, insertSession, updateSession (+7 more)

### Community 18 - "App ViewModel"
Cohesion: 0.12
Nodes (15): @lazySingleton, AppViewModel, _defaultThemeMode, init, locale, _packageInfo, packageVersion, prefs (+7 more)

### Community 19 - "Session Timer Entity"
Cohesion: 0.12
Nodes (14): create, createdAt, description, icon, id, plannedDuration, position, sessionId (+6 more)

### Community 20 - "App Dropdown & Stat Grid"
Cohesion: 0.12
Nodes (14): List, T, AppDropdown, build, hint, items, onChanged, value (+6 more)

### Community 21 - "Sidebar Brand Widgets"
Cohesion: 0.13
Nodes (13): package:flow_fusion/ui/theme/theme_context.dart, package:flow_fusion/ui/widgets/brand_logo.dart, package:window_manager/window_manager.dart, PreferredSizeWidget, Size get, build, SidebarBrand, build (+5 more)

### Community 22 - "Sessions View"
Cohesion: 0.14
Nodes (14): package:flow_fusion/enums/routes.dart, package:flow_fusion/ui/views/sessions_view/sessions_view_view_model.dart, package:flow_fusion/ui/widgets/sessions_empty_state.dart, package:flow_fusion/ui/widgets/sessions_grid.dart, Routes.sessionEditPathFor, Routes.sessionNew, build, _createNewSession (+6 more)

### Community 23 - "Dependency Injection Config"
Cohesion: 0.16
Nodes (13): @InjectableInit, @module, di.config.dart, configureDependencies, DatabaseModule, db, packageInfo, PackageVersionModule (+5 more)

### Community 24 - "App Badge & Nav Button"
Cohesion: 0.14
Nodes (12): IconData, AppBadge, build, icon, label, build, icon, label (+4 more)

### Community 25 - "Session Icon Picker"
Cohesion: 0.14
Nodes (12): package:flow_fusion/ui/constants/session_icons.dart, package:flow_fusion/ui/widgets/session_icon_option.dart, ValueChanged, build, name, onTap, selected, SessionIconOption (+4 more)

### Community 26 - "Session Editor Header Actions"
Cohesion: 0.15
Nodes (12): package:flow_fusion/ui/views/session_editor_view/session_editor_view_model.dart, package:flow_fusion/ui/widgets/session_editor_empty_timers.dart, package:flow_fusion/ui/widgets/timer_card.dart, package:go_router/go_router.dart, SessionEditorViewModel, build, _save, SessionEditorHeaderActions (+4 more)

### Community 27 - "Timer Minutes Field"
Cohesion: 0.14
Nodes (13): package:flutter/services.dart, static const int, build, _controller, createState, dispose, draft, editing (+5 more)

### Community 28 - "Home View ViewModel"
Cohesion: 0.15
Nodes (12): dart:math, Duration get, focusByDay, _generateFocusByDay, init, isLoading, _sessionDao, todayFocus (+4 more)

### Community 29 - "Session Entity"
Cohesion: 0.15
Nodes (11): copyWith, create, createdAt, description, icon, id, status, title (+3 more)

### Community 30 - "Page Header & Setting Row"
Cohesion: 0.15
Nodes (11): Widget, AppPageHeader, build, subtitle, title, trailing, build, control (+3 more)

### Community 31 - "DB Type Converters"
Cohesion: 0.18
Nodes (10): DateTimeConverter, decode, encode, decode, DurationConverter, encode, DateTime, Duration (+2 more)

### Community 32 - "App Database (sqflite)"
Cohesion: 0.17
Nodes (11): dart:async, sessionDao, sessionTimerDao, package:flow_fusion/enums/session_status.dart, package:flow_fusion/enums/timer_status.dart, package:flow_fusion/model/datasources/database/converter/date_time_converter.dart, package:flow_fusion/model/datasources/database/converter/duration_converter.dart, package:flow_fusion/model/datasources/database/dao/session_timer_dao.dart (+3 more)

### Community 33 - "Windows main.cpp Entry"
Cohesion: 0.23
Nodes (9): _In_, _In_opt_, wWinMain(), CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16(), vector, string (+1 more)

### Community 34 - "Session Editor View"
Cohesion: 0.18
Nodes (11): int?, package:flow_fusion/ui/widgets/session_details_panel.dart, package:flow_fusion/ui/widgets/session_editor_header_actions.dart, package:flow_fusion/ui/widgets/session_timers_section.dart, build, createState, initState, SessionEditorView (+3 more)

### Community 35 - "Settings View"
Cohesion: 0.18
Nodes (11): package:flow_fusion/ui/widgets/app_dropdown.dart, package:flow_fusion/ui/widgets/setting_row.dart, _appViewModel, build, _buildLanguageTile, _buildSettingsSection, _buildThemeTile, createState (+3 more)

### Community 36 - "Session Details Panel"
Cohesion: 0.18
Nodes (11): package:flow_fusion/ui/widgets/app_panel.dart, package:flow_fusion/ui/widgets/session_icon_picker.dart, build, createState, _descriptionController, dispose, initState, SessionDetailsPanel (+3 more)

### Community 37 - "App Button Widget"
Cohesion: 0.18
Nodes (11): StatelessWidget, AppButton, AppButtonVariant, build, child, _GradientButton, icon, label (+3 more)

### Community 38 - "Home View"
Cohesion: 0.20
Nodes (10): build, createState, HomeView, _HomeViewState, initState, HomeViewViewModel, _viewModel, package:flow_fusion/ui/widgets/app_page_header.dart (+2 more)

### Community 39 - "Quick Action Card"
Cohesion: 0.18
Nodes (10): Icon?, build, icon, maxHeight, maxWidth, minHeight, minWidth, onTap (+2 more)

### Community 40 - "Shared Preferences Wrapper"
Cohesion: 0.18
Nodes (10): int get, buckets, _bucketsKey, language, _languageKey, themeMode, _themeModeKey, package:shared_preferences/shared_preferences.dart (+2 more)

### Community 41 - "App Entry (main.dart)"
Cohesion: 0.20
Nodes (9): configureDependencies, ensureInitialized, main, windowOptions, package:flow_fusion/di/di.dart, package:flow_fusion/ui/app/app.dart, package:flutter/material.dart, package:flutter_test/flutter_test.dart (+1 more)

### Community 42 - "Timer Card Widget"
Cohesion: 0.18
Nodes (10): package:flow_fusion/ui/widgets/timer_description_field.dart, package:flow_fusion/ui/widgets/timer_minutes_field.dart, package:flow_fusion/ui/widgets/timer_title_field.dart, package:flow_fusion/ui/widgets/timer_type_icon.dart, build, draft, editing, index (+2 more)

### Community 43 - "Stateful Widget Bases"
Cohesion: 0.27
Nodes (10): App, _AppState, State, StatefulWidget, TimerDescriptionField, _TimerDescriptionFieldState, TimerMinutesField, _TimerMinutesFieldState (+2 more)

### Community 44 - "Windows FlutterWindow"
Cohesion: 0.22
Nodes (8): DartProject, MessageHandler(), HWND, LPARAM, LRESULT, FlutterWindow(), UINT, WPARAM

### Community 45 - "Timer Title Field"
Cohesion: 0.20
Nodes (9): TimerDraft, TextEditingController, build, _controller, createState, dispose, draft, editing (+1 more)

### Community 46 - "Home Stats Row"
Cohesion: 0.20
Nodes (9): package:flow_fusion/ui/views/home_view/home_view_view_model.dart, package:flow_fusion/ui/widgets/stat_card.dart, package:flow_fusion/ui/widgets/stat_card_grid.dart, build, formatFocusDuration, HomeStatsRow, hours, minutes (+1 more)

### Community 47 - "Session Icons Resolver"
Cohesion: 0.25
Nodes (9): _, _byName, fallback, names, resolve, SessionIcons, static const Map, static const String (+1 more)

### Community 48 - "Stat Card Widget"
Cohesion: 0.22
Nodes (8): double?, build, caption, icon, label, minHeight, StatCard, value

### Community 49 - "Sessions View ViewModel"
Cohesion: 0.22
Nodes (8): package:flow_fusion/model/datasources/database/dao/session_dao.dart, SessionDao, init, isLoading, _sessionDao, sessions, SessionsViewViewModel, update

### Community 50 - "Timer Description Field"
Cohesion: 0.22
Nodes (8): package:flow_fusion/ui/views/session_editor_view/models/timer_draft.dart, build, _controller, createState, dispose, draft, editing, initState

### Community 51 - "Localization Context"
Cohesion: 0.25
Nodes (7): AppLocalizations get, BuildContext, l10n, LocalizationContext, package:flow_fusion/l10n/app_localizations.dart, package:flutter/widgets.dart, ThemeContext

### Community 52 - "iOS Framework Signing"
Cohesion: 0.43
Nodes (6): code_sign_if_enabled(), install_bcsymbolmap(), install_dsym(), install_framework(), strip_invalid_archs(), Pods-Runner-frameworks.sh script

### Community 53 - "Theme Context Extension"
Cohesion: 0.33
Nodes (6): @immutable, FlowFusionColors get, package:flow_fusion/ui/theme/app_theme_extension.dart, FlowFusionColors, fusionColors, ThemeExtension

### Community 54 - "MobX Store Bases"
Cohesion: 0.33
Nodes (6): _AppViewModelBase, _HomeViewViewModelBase, _TimerDraftBase, _SessionEditorViewModelBase, _SessionsViewViewModelBase, Store

### Community 55 - "App Panel Widget"
Cohesion: 0.33
Nodes (5): EdgeInsetsGeometry?, AppPanel, build, child, padding

### Community 56 - "Flutter LLDB Helper"
Cohesion: 0.33
Nodes (5): handle_new_rx_page(), __lldb_init_module(), Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages., SBDebugger, SBFrame

### Community 57 - "AppLocalizations Delegate"
Cohesion: 0.40
Nodes (6): AppLocalizations, _AppLocalizationsDelegate, AppLocalizationsEn, of, AppLocalizationsRu, LocalizationsDelegate

### Community 58 - "Sessions Empty State"
Cohesion: 0.33
Nodes (5): package:flow_fusion/ui/widgets/app_button.dart, VoidCallback?, build, onCreate, SessionsEmptyState

### Community 59 - "Home Activity Heatmap"
Cohesion: 0.33
Nodes (5): package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart, package:flutter_mobx/flutter_mobx.dart, build, HomeActivityPanel, viewModel

### Community 60 - "App Theme Builder"
Cohesion: 0.33
Nodes (5): static ThemeData get, AppTheme, _buildTheme, dark, light

### Community 61 - "DAO Singletons"
Cohesion: 0.50
Nodes (5): @dao, @singleton, SessionDao, SessionTimerDao, Prefs

### Community 62 - "App Branding Assets"
Cohesion: 0.50
Nodes (5): FlowFusion App Logo, Stylized 'F' Flow Monogram, Focus / Productivity Branding, Stopwatch / Timer Motif, FlowFusion iOS App Icon (1024x1024)

### Community 63 - "Timer View"
Cohesion: 0.50
Nodes (4): build, createState, TimerView, _TimerViewState

### Community 64 - "Froom Database Annotations"
Cohesion: 0.50
Nodes (4): @Database, @TypeConverters, AppDatabase, FroomDatabase

### Community 66 - "Session Editor Empty Timers"
Cohesion: 0.50
Nodes (3): package:flow_fusion/ui/l10n/l10n_context.dart, build, SessionEditorEmptyTimers

### Community 67 - "Delete DAO Methods"
Cohesion: 0.67
Nodes (3): @delete, deleteSession, deleteTimer

### Community 68 - "Database Entities"
Cohesion: 0.67
Nodes (3): @Entity, Session, SessionTimer

### Community 69 - "Factory Methods"
Cohesion: 0.67
Nodes (3): @factoryMethod, create, create

## Knowledge Gaps
- **631 isolated node(s):** `SBFrame`, `SBDebugger`, `flutter_export_environment.sh script`, `UIApplication`, `Any` (+626 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `l10n Localization Configuration` connect `Build & Dependency Config` to `Localization & Theme Strings`?**
  _High betweenness centrality (0.031) - this node is a cross-community bridge._
- **Why does `_` connect `Session Icons Resolver` to `App Entry (main.dart)`?**
  _High betweenness centrality (0.016) - this node is a cross-community bridge._
- **What connects `SBFrame`, `SBDebugger`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.` to the rest of the system?**
  _632 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Localization & Theme Strings` be split into smaller, more focused modules?**
  _Cohesion score 0.02247191011235955 - nodes in this community are weakly interconnected._
- **Should `App Localizations (EN)` be split into smaller, more focused modules?**
  _Cohesion score 0.02631578947368421 - nodes in this community are weakly interconnected._
- **Should `App Localizations (RU)` be split into smaller, more focused modules?**
  _Cohesion score 0.02631578947368421 - nodes in this community are weakly interconnected._
- **Should `Windows Runner (Win32)` be split into smaller, more focused modules?**
  _Cohesion score 0.08658536585365853 - nodes in this community are weakly interconnected._