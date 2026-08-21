# Epic 03 — Live timer in the menu bar

**Priority:** P1 · **Status:** To do

## Context

Flow Fusion already has a system tray presence via the `tray_manager` package
(already a dependency — see `pubspec.yaml`), wired up in
[`lib/ui/app/tray_service.dart`](../../lib/ui/app/tray_service.dart) as a
`@lazySingleton` (`TrayService`). Today it only sets a static icon and a
static tooltip (`trayManager.setToolTip('Flow Fusion')`) — it never updates
after `init()`, and `setTitle()` (which puts live text next to the tray icon
on macOS) is never called.

`TrayService` currently has no dependency on the active timer's state — it
only knows about `WindowListener`/`TrayListener` for window show/hide and the
tray context menu. To show a live countdown you'll need to wire it to
whatever exposes the active timer's remaining time —
[`lib/controllers/active_timer_controller.dart`](../../lib/controllers/active_timer_controller.dart)
and/or
[`lib/model/entity/active_timer_state.dart`](../../lib/model/entity/active_timer_state.dart)
look like the right source; read both before deciding how to subscribe (this
project uses MobX observables/stores elsewhere — check
`active_timer_controller.dart`'s `@observable`/`@computed` usage and follow
the same pattern rather than introducing a different reactivity mechanism).

## Task

1. Make `TrayService` (or a new small controller it depends on) observe the
   active timer's remaining-time value and call
   `trayManager.setTitle('mm:ss')` on macOS whenever it changes (roughly once
   per second while a timer is running).
2. When no timer is active, clear the title (empty string) so the tray icon
   goes back to icon-only.
3. `tray_manager`'s `setTitle` is a macOS-only concept (it's the text next to
   the menu-bar icon) — guard the call so it's only invoked on macOS
   (`Platform.isMacOS`), matching the `Platform.isMacOS`/`Platform.isWindows`
   guard style already used elsewhere in this codebase (e.g.
   `app_blocker_service.dart`'s `_isSupported` getter).
4. On Windows, leave the existing tooltip behavior alone — don't attempt a
   Windows equivalent of the live title unless it's trivial with the same
   package; if `tray_manager` doesn't support it on Windows, that's fine,
   just make sure calling `setTitle` there doesn't throw.

## Acceptance criteria

- [x] On macOS, while a work or chill timer is running, the menu bar shows
      the remaining time as `mm:ss`, updating roughly every second.
- [x] When the timer completes or the session ends, the tray title clears
      back to no text (icon-only).
- [x] Starting a new timer after one ends resumes the live countdown
      correctly — no stale time left over from the previous timer.
- [ ] On Windows, nothing crashes or regresses — the existing tooltip
      ("Flow Fusion") still works. (now shows live remaining time in the
      tooltip too — not yet verified on an actual Windows machine)
- [x] No excessive rebuild/IPC churn: the title should update on the timer's
      natural tick cadence, not on every unrelated app state change.

## Out of scope

- A live Windows menu-bar text equivalent, if not trivially supported by
  `tray_manager` on that platform.
- Changing the tray context menu items or icon.
