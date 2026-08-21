# Plan: Task time-tracking

**Branch**: feat/task-time-tracking
**Status**: Active
**Design spec**: [`docs/superpowers/specs/2026-08-06-task-time-tracking-design.md`](../docs/superpowers/specs/2026-08-06-task-time-tracking-design.md)
**Source epic**: [`docs/tasks/epic-04-task-time-tracking.md`](../docs/tasks/epic-04-task-time-tracking.md)

## Goal

Let the user tag a work session with an optional "task" and see cumulative
tracked time per task, without turning tasks into a todo list.

## Testing approach

No automated tests for this feature (project has zero existing tests and no
mutation-testing tooling for Dart). Each slice is verified manually by
running the app (`flutter run -d windows` or the active desktop target) and
walking through the acceptance criteria by hand. The standard
RED-GREEN-MUTATE-KILL MUTANTS-REFACTOR loop is replaced with:
**IMPLEMENT → RUN APP → MANUALLY VERIFY ACCEPTANCE CRITERIA → present diff →
wait for commit approval.**

## Acceptance Criteria (feature-level, from the design spec)

- [ ] A new "Tasks" screen exists in the sidebar; user can create, rename,
      and delete tasks there.
- [ ] The Tasks screen lists every task (including ones with no tracked time
      yet), sorted by tracked time descending.
- [ ] The timer screen (`TimerBody`) shows a dropdown to pick an existing
      task for the running session, or "No task"; selecting one persists
      immediately.
- [ ] A session never tagged with a task behaves exactly as before this
      feature (no forced dialog, no behavior change).
- [ ] Deleting a task un-tags (sets `taskId = NULL` on) any session that had
      it, without touching those sessions' own data.
- [ ] Pre-existing sessions (created before this migration) keep working,
      with `taskId == null`, no backfill required.
- [ ] Tasks have no status/priority/due-date field anywhere in the schema or
      UI.

## Slices

### Slice 1: User creates a task and sees it in a list

**Value**: User can start tagging their time-tracking with a category, by
creating one.
**Path**: Sidebar → new "Tasks" nav item → `TasksView` → `+ New task` button
→ `TaskEditDialog` (create mode) → `TasksViewModel.createTask(name)` →
`TaskDao.insertTask` → `tasks` table (new, migration 4→5) → list re-renders
showing the new task with `0:00` (no sessions reference it yet — this is a
correct state, not a stub).
**Required implementation skills**: none (no automated tests this feature;
skip `tdd`/`testing`/`mutation-testing`/`refactoring` loading per the
testing-approach decision above). Follow `flutter-scalable-app` conventions
already in use in this repo (widget-per-file, explicit types, `@injectable`
MobX stores) — not its default BLoC/auto_route/get_it+injectable stack,
since this codebase already uses MobX + go_router + get_it+injectable.
**Acceptance criteria**:
- [ ] `flutter pub run build_runner build --delete-conflicting-outputs` runs
      clean after adding `Task` entity, `TaskDao`, `migration4To5`, and
      registering `Task` in `AppDatabase.entities` (version bumped to 5).
- [ ] Sidebar shows a "Tasks" item (with its own onboarding showcase step,
      `navTasksKey`); clicking it navigates to `/tasks`.
- [ ] Tasks screen shows an empty state + `+ New task` button when no tasks
      exist.
- [ ] Tapping `+ New task`, typing a name, and confirming adds the task to
      the list immediately, showing `0:00`.
- [ ] Restarting the app (or hot-restart) still shows the created task —
      proves it's persisted, not just in-memory MobX state.
**Manual verification**: run the desktop app, open Tasks from sidebar,
create 2-3 tasks with different names, confirm they appear in the list each
showing `0:00`, hot-restart and confirm they're still there.
**Done when**: all acceptance criteria above are checked off and the user
approves the commit.

### Slice 2: User picks a task on the timer screen and it's persisted on the session

**Value**: User can tag an in-progress work session with a task.
**Path**: `sessions_view` → start a session → `TimerView`/`TimerBody` → new
`SessionTaskSelector` dropdown (below the pause/skip/stop button row) shows
`No task` + all existing tasks → selecting one calls
`ActiveTimerController.setTask(int? taskId)` → `SessionDao.updateSession`
(persists `taskId` on the `sessions` row, migration 5→6 adds the nullable
`taskId` column + FK with `onDelete: setNull`) → in-memory `state.session`
updates so the dropdown reflects the choice.
**Required implementation skills**: none (see testing-approach decision).
**Acceptance criteria**:
- [ ] Migration 5→6 adds `sessions.taskId` (nullable) + FK to `tasks(id)`;
      a database already at v5 upgrades cleanly.
- [ ] `Session.copyWith` supports an explicit `clearTaskId` flag (mirroring
      `SessionTimer.copyWith`'s `clearActualDurationMs` pattern) so "not
      provided" and "explicitly cleared" are distinguishable.
- [ ] Starting a session and never touching the new dropdown leaves
      `taskId == null` — nothing about existing session-start behavior
      changes.
- [ ] Selecting a task in the dropdown while a session is running persists
      immediately (verified by killing/reopening the app mid-session, or by
      checking the dropdown still shows the selection after navigating away
      from and back to the timer screen).
- [ ] Selecting `No task` after a task was chosen clears it (`taskId` back
      to `NULL`).
- [ ] If zero tasks exist yet, the dropdown only offers `No task` — no crash,
      no inline "create" affordance here (that's Slice 1's screen only).
**Manual verification**: create a task on the Tasks screen (from Slice 1),
start a session, open the timer screen, pick that task from the dropdown,
pause/resume/skip to confirm the selection survives those actions, then end
the session. Start a second session and confirm leaving the dropdown
untouched doesn't force any dialog.
**Done when**: all acceptance criteria above are checked off and the user
approves the commit.

### Slice 3: Tasks screen shows real aggregated tracked time

**Value**: User can see how much time they've actually spent per task.
**Path**: User completes (or lets run) a work timer on a session tagged with
a task in Slice 2 → `active_timer_controller`'s existing `_logCompletedRun`
writes a `focus_log` row for that session → user opens the Tasks screen →
`TasksViewModel` loads `List<Task>`, `List<Session>`, and `List<FocusLog>`
(new `FocusLogDao.findAllRuns()` query), aggregates `workMs` per task in
Dart (via the `session.id -> session.taskId` map), and renders each task's
`formatFocusDuration(totalDuration)` next to its name, list sorted by
duration descending.
**Required implementation skills**: none (see testing-approach decision).
**Acceptance criteria**:
- [ ] `FocusLogDao` gets a `findAllRuns()` query (`SELECT * FROM focus_log`)
      alongside the existing `findRunsBetween`.
- [ ] `TasksViewModel` computes, for each task, the sum of `workMs` across
      every `focus_log` row whose `sessionId` maps to a session with that
      `taskId`, converted via the existing `formatFocusDuration` helper.
- [ ] Tasks screen list order updates to duration-descending (ties broken by
      task id) once real time exists — task with the most tracked time is
      first.
- [ ] A task with zero tagged focus-log time still shows `0:00` and appears
      in the list (not filtered out).
- [ ] Sessions with `taskId == null` don't contribute to any task's total
      (untagged time is simply not shown per-task — matches "picking a task
      is optional").
**Manual verification**: with the task selected in Slice 2, let a work timer
run to completion (or use a short planned duration for a quick manual test),
confirm a `focus_log` row would be produced (existing behavior — verified
indirectly via the Home view's total-focus stat still working), then open
the Tasks screen and confirm that task now shows non-zero time and sorts
above tasks with less/no time.
**Done when**: all acceptance criteria above are checked off and the user
approves the commit.

### Slice 4: User renames a task

**Value**: User can fix a typo or relabel a task without losing its tracked
time.
**Path**: Tasks screen → edit (pencil) icon on a task row → `TaskEditDialog`
(edit mode, pre-filled with current name) → `TasksViewModel.renameTask(task,
newName)` → `TaskDao.updateTask`.
**Required implementation skills**: none (see testing-approach decision).
**Acceptance criteria**:
- [ ] Each task row has a pencil icon button.
- [ ] Tapping it opens the same dialog widget used for creation, pre-filled
      with the current name.
- [ ] Confirming with a new name updates the row in place, without changing
      its tracked-time total or its sort position relative to unaffected
      tasks (beyond whatever the rename itself causes if names were used as
      a tiebreaker — they aren't, per Slice 3's id tiebreaker).
- [ ] Restarting the app shows the renamed task, proving persistence.
**Manual verification**: rename one of the tasks created earlier, confirm
the displayed name changes immediately and its duration total is unchanged,
hot-restart and confirm the new name persisted.
**Done when**: all acceptance criteria above are checked off and the user
approves the commit.

### Slice 5: User deletes a task, un-tagging its sessions

**Value**: User can remove a task they no longer need, without corrupting
past session data.
**Path**: Tasks screen → delete (trash) icon on a task row → confirmation
`AlertDialog` (mirroring `_confirmEndSession` in `timer_body.dart`) →
`TasksViewModel.deleteTask(task)` → `TaskDao.deleteTask` → SQLite FK
(`onDelete: setNull` from Slice 2) automatically nulls `taskId` on any
session that referenced it.
**Required implementation skills**: none (see testing-approach decision).
**Acceptance criteria**:
- [ ] Each task row has a trash icon button.
- [ ] Tapping it shows a confirm/cancel dialog; canceling leaves everything
      unchanged.
- [ ] Confirming removes the task from the Tasks screen list immediately.
- [ ] A session that was tagged with the deleted task still opens/works
      normally afterward, and its task dropdown on the timer screen now
      shows "No task" (proving the FK `setNull` fired, not a dangling
      reference).
- [ ] That session's own data (title, blocked apps/sites, focus_log rows)
      is untouched by the task deletion.
**Manual verification**: delete one of the tasks that has a tagged session
from Slice 2/3, confirm it disappears from the Tasks list, then revisit that
session's timer screen (or start it again) and confirm the dropdown shows
"No task" and the session otherwise behaves normally.
**Done when**: all acceptance criteria above are checked off and the user
approves the commit.

## Pre-PR Quality Gate

Before each slice's commit:
1. `dart analyze` (or the project's usual lint command) passes with no new
   warnings.
2. `flutter pub run build_runner build --delete-conflicting-outputs` runs
   clean (generated `.g.dart` files committed alongside source changes).
3. Manual verification steps for that slice completed as described above.
4. No stray status/priority/due-date fields introduced on `Task` — quick
   self-check against the "Out of scope" list before presenting the diff.

---
*Delete this file when the plan is complete. If `plans/` is empty, delete
the directory.*
