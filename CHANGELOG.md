# Changelog

All notable changes to Flow Fusion will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] — 2026-08-21

### Added
- **Task Tracking in Focus Sessions** — attach tasks directly to your focus timer, track progress across sessions, and see exactly where your time goes.
- **Refreshed Onboarding Tour** — the first-launch walkthrough now includes a step introducing the Tasks feature.
- **Social Links in Sidebar** — quickly access community links and resources right from the sidebar.
- **Active Timer in System Tray** — your running timer now shows in the system tray for at-a-glance session status.
- **Anonymous Usage Analytics** — helps us understand how the app is used and where to focus development (all data is anonymous).

### Improved
- **Smoother Timer Visuals** — progress arcs are now smoother, connector lines are cleaner, and animations feel more refined.
- **Site Blocking** — fixed edge cases and extended support to macOS.

## [1.0.1] — 2026

### Fixed
- Fixed a crash when saving a session caused by duplicate timer positions.
- "What's new" in the update banner now opens correctly.
- Fixed onboarding showing a duplicated, overlapping window.
- Starter example sessions now appear reliably on first launch.
- The update banner no longer overflows on narrow windows.
- The app version is now recorded in the log file for easier diagnostics.

## [1.0.0] — 2026

### Added
- Initial release of Flow Fusion.
- Pomodoro-style focus timer with customizable sessions.
- Focus mode with site and app blocking.
- Session history and heatmap calendar.
- OTA update system via desktop_updater.
- Windows and macOS support.
