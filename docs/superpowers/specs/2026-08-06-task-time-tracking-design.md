# Design: Task time-tracking (epic-04)

**Date:** 2026-08-06
**Source requirement:** [`docs/tasks/epic-04-task-time-tracking.md`](../../tasks/epic-04-task-time-tracking.md)
**Status:** Approved — ready for implementation planning

## Context correction

The epic doc references `drift`, but this project's local database uses
**froom** (a Room-style ORM), see
[`lib/model/datasources/database/app_database.dart`](../../../lib/model/datasources/database/app_database.dart).
All schema/migration work below follows froom conventions actually used in
the codebase (`@Entity`, `@dao`, manual `Migration` objects with raw SQL),
not drift.

The epic also refers to "`Session.duration`" — there is no such field.
Tracked time actually lives in the `focus_log` table
([`lib/model/entity/database/focus_log.dart`](../../../lib/model/entity/database/focus_log.dart)),
one row per completed work run, keyed by `sessionId` with a `workMs` column.
This is populated in
[`lib/controllers/active_timer_controller.dart`](../../../lib/controllers/active_timer_controller.dart)
(`_logCompletedRun`). Task-time aggregation is built on `focus_log`, not on
a nonexistent `Session.duration`.

## Decisions made during brainstorming (deviate from epic where noted)

- **Task picker location:** on the active timer screen (`TimerBody`), not in
  `session_editor_view`. This deviates from the epic's suggestion of
  mirroring `blocked_apps_picker`'s location (session-level form) — the
  stakeholder explicitly chose the timer screen instead.
- **Task creation:** happens only on the new dedicated "Tasks" screen, not
  inline from the timer-screen dropdown. This deviates from the epic's
  acceptance criterion "a brand-new task can be created inline from the
  picker without leaving the session-start flow" — superseded by explicit
  stakeholder direction.
- **Task CRUD:** full create, rename, delete is in scope. This deviates from
  the epic's "Out of scope: editing/renaming/deleting tasks" — superseded by
  explicit stakeholder direction.
- **Tasks screen contents:** lists *all* tasks, including ones with zero
  tracked time (shown as `0:00`), not just tasks with ≥1 tagged session as
  the epic's acceptance criteria literally state. Necessary because the same
  screen is also the only place to create/manage tasks — a newly created
  task must be visible immediately.

## 1. Schema (froom)

New `Task` entity:

```dart
@Entity(tableName: 'tasks')
class Task {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  String name;

  Task({this.id, required this.name});

  factory Task.create({required String name}) => Task(name: name);

  Task copyWith({String? name}) => Task(id: id, name: name ?? this.name);
}
```

`Session` gets a new nullable field:

```dart
@ForeignKey(
  childColumns: ['taskId'],
  parentColumns: ['id'],
  entity: Task,
  onDelete: ForeignKeyAction.setNull,
)
```
added to `Session`'s `@Entity(...)` foreign keys, plus:

```dart
final int? taskId;
```

`copyWith` on `Session` needs a `clearTaskId` bool flag (mirroring the
`clearActualDurationMs` pattern already used on `SessionTimer.copyWith`) so
callers can explicitly null out the task, distinguishing "not provided" from
"explicitly cleared".

Migration (`migration4To5`, bumping `AppDatabase` version 4 → 5):

```dart
final migration4To5 = Migration(4, 5, (database) async {
  await database.execute(
    'CREATE TABLE IF NOT EXISTS `tasks` ('
    '`id` INTEGER PRIMARY KEY AUTOINCREMENT, '
    '`name` TEXT NOT NULL)',
  );
  await database.execute(
    'ALTER TABLE sessions ADD COLUMN taskId INTEGER REFERENCES tasks(id)',
  );
});
```

Existing `sessions` rows get `taskId = NULL` automatically via `ALTER TABLE
ADD COLUMN` with no default — no backfill needed, satisfying the epic's
acceptance criterion on this point.

`AppDatabase`:
- `@Database(version: 5, entities: [Session, SessionTimer, FocusLog, Task])`
- add `TaskDao get taskDao;`
- register `migration4To5` alongside the existing migrations.

New `TaskDao`:

```dart
@singleton
@dao
abstract class TaskDao {
  @Query('SELECT * FROM tasks ORDER BY id ASC')
  Future<List<Task>> findAllTasks();

  @Insert(onConflict: OnConflictStrategy.abort)
  Future<int> insertTask(Task task);

  @update
  Future<void> updateTask(Task task);

  @delete
  Future<void> deleteTask(Task task);

  @factoryMethod
  static TaskDao create(AppDatabase appDatabase) => appDatabase.taskDao;
}
```

## 2. Time aggregation: in Dart, not SQL

Considered a SQL aggregation (`SELECT ... SUM(workMs) ... GROUP BY taskId`
via a `sessions` ⋈ `focus_log` join) but the froom DAOs in this codebase
(`session_dao.dart`, `focus_log_dao.dart`) only demonstrate `@Query` methods
returning entity lists or single scalars (e.g. `COUNT(*)` → `int?`) — there's
no existing precedent for a multi-column non-entity `@Query` result (froom's
equivalent of a `@DatabaseView`/DTO projection). Rather than rely on an
unverified ORM capability, aggregation happens in Dart:

`TasksViewModel` (MobX store, `@injectable`, same shape as
`HomeViewViewModel`) loads `List<Task>` (`TaskDao`), `List<Session>`
(`SessionDao`), and `List<FocusLog>` (`FocusLogDao` — needs a new
`findAllRuns()` query since the existing `findRunsBetween` requires a date
range), then aggregates: group focus logs by `session.taskId` via a
`sessionId -> taskId` map built from the sessions list, sum `workMs` per
`taskId`, sort descending. This is a personal-productivity dataset (small
row counts) — in-memory aggregation is not a performance concern.

Result type (view-layer only, not a DB entity):

```dart
// lib/ui/views/tasks_view/models/task_with_duration.dart
class TaskWithDuration {
  final Task task;
  final Duration totalDuration;
  TaskWithDuration({required this.task, required this.totalDuration});
}
```

## 3. Task selection — on the timer screen

New widget `SessionTaskSelector` (own file, `StatefulWidget`, per project
convention of one widget class per file) inserted into
[`lib/ui/views/timer_view/widgets/timer_body.dart`](../../../lib/ui/views/timer_view/widgets/timer_body.dart)
below the pause/skip/stop button row and above the "Timer queue" heading.

- Loads `List<Task>` on init via `GetIt.I.get<TaskDao>()`.
- Renders a dropdown: a `No task` sentinel entry plus every existing `Task`,
  selected value bound to `state.session!.taskId`.
- On change, calls `ActiveTimerController.setTask(int? taskId)` (new
  method): persists via `SessionDao.updateSession(session.copyWith(taskId:
  ..., clearTaskId: taskId == null))` and updates the in-memory
  `state.session` so the UI reflects the change immediately.
- No inline task creation here — if no tasks exist yet, the dropdown only
  offers `No task`; the user creates tasks on the Tasks screen.
- Selecting/changing the task works at any point while the session is
  active (not locked after time starts accruing) — this is safe because
  aggregation is per-session (via `Session.taskId`), not per `focus_log`
  row, so there's no "splitting time across tasks" concern regardless of
  when the task was assigned.
- A session started without ever touching this dropdown behaves exactly as
  before (`taskId` stays `NULL`), satisfying the "optional, never forced"
  acceptance criterion.

## 4. "Tasks" screen — list + create + rename + delete

New sidebar nav entry and route:
- [`lib/enums/routes.dart`](../../../lib/enums/routes.dart): add
  `tasks('/tasks')`.
- [`lib/ui/app/router.dart`](../../../lib/ui/app/router.dart): add a
  `GoRoute` for `Routes.tasks.path` → `TasksView`, alongside the existing
  top-level routes (`settings`, `timer`) in the single
  `StatefulShellBranch`.
- [`lib/ui/widgets/sidebar_widget.dart`](../../../lib/ui/widgets/sidebar_widget.dart):
  add a `_NavItem` for tasks. Every existing item participates in the
  onboarding showcase tour (`Showcase.withWidget` wraps each), so this
  requires a matching `navTasksKey` on `OnboardingController`, a new
  showcase step (title/description l10n strings), and bumping
  `onboardingTotalSteps` — skipping this would leave the nav item
  inconsistent with its siblings.

`TasksView` (new view folder `lib/ui/views/tasks_view/`, following the
`sessions_view` structure: `tasks_view.dart` + `tasks_view_view_model.dart` +
`widgets/`):

- Header with a `+ New task` button.
- List of all tasks (`ListView.builder`), each row showing the task name and
  `formatFocusDuration(totalDuration)` (reusing the existing formatter from
  [`lib/utils/duration_formatter.dart`](../../../lib/utils/duration_formatter.dart)
  — same "4h 20m"-style format already used on the home view's stat cards),
  sorted by duration descending, ties broken by task id. Tasks with no
  tracked time show `0:00` (formatter's zero case) and still appear.
- Each row has two trailing icon buttons (mirroring `AppIconButton` usage in
  `timer_body.dart`): edit (pencil) and delete (trash).
  - **Create/Edit** share one dialog widget (`TaskEditDialog`, own file): a
    single text field, pre-filled with the current name when editing, empty
    when creating. Submitting calls `TasksViewModel.createTask(name)` or
    `TasksViewModel.renameTask(task, name)`.
  - **Delete** shows a confirmation `AlertDialog` (mirroring
    `_confirmEndSession` in `timer_body.dart`), then calls
    `TasksViewModel.deleteTask(task)`.
  - Deleting a task relies on the `onDelete: ForeignKeyAction.setNull` FK
    (§1): any session tagged with the deleted task has its `taskId` set to
    `NULL` by SQLite automatically — no orphaned references, no manual
    cleanup code needed, and those sessions keep working exactly as
    "no task selected" sessions do.

Empty state (no tasks yet) shows a simple placeholder message + the `+ New
task` button, no separate empty-state widget needed given how little content
there is (contrast with `sessions_empty_state.dart`, which is justified by a
richer sessions-list UI).

## 5. Testing

- **Migration test:** a pre-existing v4 database (sessions with no `taskId`
  column) upgrades to v5 without error, and old session rows read back with
  `taskId == null`.
- **`TasksViewModel` aggregation:** unit test with a fixed set of tasks,
  sessions (some with `taskId`, some without), and focus logs — assert
  correct per-task sums and zero-time tasks included, sorted descending.
- **`ActiveTimerController.setTask`:** persists the id (and `null` on clear)
  and updates in-memory state.
- **`TaskDao` CRUD:** insert/update/delete round-trip, and that deleting a
  task nulls out `taskId` on referencing sessions (FK behavior).

## Out of scope (unchanged from epic)

- Due dates, priorities, done/archived states, sub-tasks, reminders on
  tasks.
- Switching tasks mid-session or splitting one session's time across
  multiple tasks.
