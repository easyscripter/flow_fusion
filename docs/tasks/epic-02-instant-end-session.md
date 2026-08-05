# Epic 02 — Instant "end session" button

**Priority:** P1 · **Status:** Done

> **Implementation note:** shipped with a confirmation dialog before
> `endSessionNow()` runs (requested after initial implementation, superseding
> the "no confirmation dialog" ask below) — reuses the existing
> `showDialog`/`AlertDialog` pattern from `sessions_view.dart`'s delete-session
> confirmation. `ActiveTimerController.endSessionNow()` reuses `elapsedIn()` +
> `_markTimerSkipped()` for real elapsed duration, then delegates to
> `_clearState(markSessionCompleted: true)` — the same teardown path natural
> completion uses. Buttons on the timer screen were also restyled to compact
> icon-only controls with hover tooltips (`AppIconButton`) as part of this
> pass.

## Context

Flow Fusion runs work/chill timer sessions
([`lib/controllers/active_timer_controller.dart`](../../lib/controllers/active_timer_controller.dart)).
Currently there's presumably a way to let a session run to completion or
skip to the next queued timer, but no fast way to end the whole session
right now. The controller already has a well-defined teardown path — look at
how it calls `_appBlocker.stopBlocking()` and `_siteBlocker.stopBlocking()`
around line 484 and in whatever method currently handles natural
session-completion — that's the path this button must reuse.

**Why this matters:** if a new "instant end" shortcut is added as a
parallel/separate code path instead of reusing the existing teardown, it's
easy to forget to call `stopBlocking()` on both blockers, which would leave
apps/sites locked even though the UI shows the session as ended — a worse bug
than not having the button at all.

## Task

Add a button/control on the active-timer screen
([`lib/ui/views/timer_view/`](../../lib/ui/views/timer_view/)) that ends the
current session immediately, no confirmation dialog.

Implementation must call into `ActiveTimerController` through the **same**
method (or a thin wrapper around the same internal path) that normal
session-completion already uses — the one that calls
`_appBlocker.stopBlocking()` / `_siteBlocker.stopBlocking()` — not a new
independent teardown. Read `active_timer_controller.dart` in full before
implementing to find that exact method; don't guess its name.

The session should be persisted with its **actual elapsed duration** at the
moment the button was pressed, not the originally planned duration — check
how the existing completion path records duration and match that.

## Acceptance criteria

- [x] A button is visible on the timer screen while a session is active, and
      pressing it ends the session in a single click — no "are you sure?"
      dialog. *(superseded — a confirm dialog was added per follow-up
      request; see implementation note above)*
- [x] After pressing it, previously blocked apps and sites are unblocked
      immediately (verify `AppBlockerService`/`SiteBlockerService` are no
      longer polling/enforcing).
- [x] The ended session is recorded in the database with its real elapsed
      time, not the planned/target duration.
- [x] Ending a session this way and then starting a new one works cleanly —
      no leftover timer/blocking state from the instantly-ended session leaks
      into the next one.

## Out of scope

- ~~Any "are you sure?" confirmation UX, undo, or grace period — the explicit
  ask is instant, no-confirmation ending.~~ *(reversed by follow-up request —
  a confirmation dialog was added; undo/grace period remain out of scope)*
- Menubar/tray equivalent of this button (that's a separate Windows/macOS
  tray-menu concern, not part of this task unless it already exists there).
