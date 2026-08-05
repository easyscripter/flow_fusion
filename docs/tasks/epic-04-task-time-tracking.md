# Epic 04 — Task time-tracking

**Priority:** P1 · **Status:** To do

## Context

The user wants to create "tasks" (e.g. "Client report", "Refactor auth"),
optionally attach one to a work timer session, and later see how much total
time was tracked against each task.

This was originally floated as a general todo-list feature but was
deliberately scoped down during a grilling session — **do not build a general
todo app.** The agreed shape is much narrower:

- A task is a **plain tag for time aggregation only** — it has no status
  (no done/archived/priority), no due date, no sub-items. It exists purely so
  time can be summed by task later.
- **Exactly one task per session** — no switching tasks mid-timer, no
  sub-interval tracking within a single session. If the user wants to track
  a different task, they start a new session.
- Picking a task is **optional** — sessions must continue to work exactly as
  they do today when no task is chosen.

The project uses `drift` for its local SQLite database — see
[`lib/model/datasources/database/app_database.dart`](../../lib/model/datasources/database/app_database.dart)
and the existing `Session` entity in
[`lib/model/entity/database/session.dart`](../../lib/model/entity/database/session.dart)
for the schema/migration conventions already in use (naming, migration
numbering, converters — see
[`lib/model/datasources/database/converter/blocked_app_list_converter.dart`](../../lib/model/datasources/database/converter/blocked_app_list_converter.dart)
for the converter pattern if you need one).

For the picker UX, mirror the existing app-blocklist picker flow —
[`lib/ui/views/session_editor_view/widgets/blocked_apps_picker.dart`](../../lib/ui/views/session_editor_view/widgets/blocked_apps_picker.dart)
and
[`lib/ui/views/session_editor_view/widgets/blocked_apps_picker_dialog.dart`](../../lib/ui/views/session_editor_view/widgets/blocked_apps_picker_dialog.dart) —
same interaction shape (open a dialog/picker, select or create, confirm),
just for tasks instead of apps.

## Task

1. **Schema:** add a `Task` table (id, name — that's it, no status/timestamps
   beyond whatever drift needs) and a nullable FK from `Session` to `Task`.
   Write the drift migration following this project's existing migration
   conventions (check `app_database.dart` for the current schema version and
   how past migrations were added).
2. **Picker:** when starting a work timer, let the user optionally pick an
   existing task or create a new one inline, following the
   `blocked_apps_picker` UX pattern. Persist the chosen task's id on the
   `Session` row. No task selected → session behaves exactly as it does
   today.
3. **Report view:** a new screen/section that lists every task with the sum
   of `Session.duration` (or whatever the actual elapsed-time field is
   called — check `session.dart`) across all sessions tagged with that task,
   sorted by most time first. Where this view lives in the navigation
   (settings, a new tab, etc.) is your call — check the existing
   `lib/ui/views/` structure and place it consistently with how other
   secondary views are organized.

## Acceptance criteria

- [ ] Starting a work session shows an optional task picker; selecting a
      task persists its id on that session.
- [ ] A brand-new task can be created inline from the picker without leaving
      the session-start flow.
- [ ] Starting a session without picking a task works exactly as it did
      before this feature existed — task is optional, never required, no
      new dialog forced on the user who ignores it.
- [ ] A report screen lists every task that has at least one tagged session,
      showing cumulative tracked time, sorted by most time first.
- [ ] Tasks have no status field and no completion UI — verify nothing in
      the implementation added one.
- [ ] Existing sessions created before this migration (with no task) don't
      break — the migration must not require backfilling a task onto old
      rows.

## Out of scope

- Any todo-list semantics: due dates, priorities, done/archived states,
  sub-tasks, reminders.
- Switching tasks mid-session or splitting one session's time across
  multiple tasks.
- Editing/renaming/deleting tasks — a minimal create-and-pick flow is enough
  for this release unless it's trivial to add given the picker's existing
  edit affordances (check if `blocked_apps_picker` already supports
  edit/delete for its items and mirror only if so).
