# Timer Visual Polish Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the timer screen's progress circle sweep continuously (instead of once/sec) and the current queue item's connector line fill in real time, both fed by one shared smooth-progress source, while fixing the pre-existing rendering bug that makes the circle look "done" around 70-90% elapsed.

**Architecture:** A new `TimerProgressTicker` widget owns a single per-frame `Ticker` + `ValueNotifier<double>`, computed via a pure `computeSmoothProgress()` function that mirrors `ActiveTimerState.progress`'s formula but samples wall-clock time every frame instead of once/sec. `TimerBody` threads that one `ValueListenable<double>` into `TimerProgressCircle` (via `ValueListenableBuilder`, solid-color arc, no gradient) and into the current `TimerQueueItem` only (connector fill). No changes to `ActiveTimerController`/`ActiveTimerState`/business logic.

**Tech Stack:** Flutter 3.8+, Dart, MobX (`mobx` — state only, untouched by this work).

## Global Constraints

- Dart SDK `>=3.8.0 <4.0.0` (from `pubspec.yaml`).
- Use `Color.withValues(alpha: ...)` / `.a`/`.r`/`.g`/`.b` component getters — this codebase does not use the deprecated `.withOpacity()`/`.red`/`.green`/`.blue`/`.alpha` Color API (see existing usage in `timer_progress_circle.dart` and `timer_queue_item.dart`).
- No changes to `ActiveTimerController`, `ActiveTimerState`, `SessionTicker`, or any persistence/business logic — the progress math there is confirmed correct (see spec).
- No other visual changes to the timer screen beyond `TimerProgressCircle` and `TimerQueueItem`.
- Existing state-transition animations (280ms `easeOutCubic` crossfade on dot color/size) must remain unchanged.
- Follow existing widget-class-per-file convention; no `Widget _buildX()` helper methods.
- Run `flutter analyze` clean.

**Spec:** [docs/superpowers/specs/2026-08-05-timer-visual-polish-design.md](../specs/2026-08-05-timer-visual-polish-design.md)

---

### Task 1: Fix `_CirclePainter` — remove the alpha-ramp gradient bug

**Files:**
- Modify: `lib/ui/views/timer_view/widgets/timer_progress_circle.dart:86-94`
- Test: `test/ui/views/timer_view/widgets/timer_progress_circle_test.dart`

**Interfaces:**
- Consumes: nothing new — `TimerProgressCircle` keeps its existing public constructor (`progress`, `color`, `timeLabel`, `timerLabel`, `size`).
- Produces: a visually-solid progress arc (no alpha ramp) that later tasks build on unchanged.

- [ ] **Step 1: Fix `_CirclePainter`**

In `lib/ui/views/timer_view/widgets/timer_progress_circle.dart`, replace the `progressPaint` definition (currently lines 86-94):

```dart
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [color.withValues(alpha: 0.3), color],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
```

with:

```dart
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
```

- [ ] **Step 3: Run analyzer**

Run: `flutter analyze lib/ui/views/timer_view/widgets/timer_progress_circle.dart`
Expected: No issues.

---

### Task 2: `TimerProgressTicker` — shared per-frame smooth progress source

**Files:**
- Create: `lib/ui/views/timer_view/widgets/timer_progress_ticker.dart`

**Interfaces:**
- Consumes: `ActiveTimerState` (`lib/model/entity/active_timer_state.dart`) — reads `.currentTimer`, `.isPaused`, `.awaitingManualAdvance`, `.endsAt`, `.progress`. No new fields added to `ActiveTimerState`.
- Produces:
  - `double computeSmoothProgress({required bool isPaused, required bool awaitingManualAdvance, required DateTime? endsAt, required int totalMs, required double fallbackProgress, required DateTime now})` — pure function, top-level, exported from this file.
  - `class TimerProgressTicker extends StatefulWidget` with constructor `TimerProgressTicker({required ActiveTimerState state, required Widget Function(BuildContext, ValueListenable<double>) builder, DateTime Function()? now, Key? key})`. Task 5 wraps `TimerBody` with this, passing `_controller.state`.

- [ ] **Step 1: Implement `computeSmoothProgress` and `TimerProgressTicker`**

Create `lib/ui/views/timer_view/widgets/timer_progress_ticker.dart`:

```dart
import 'package:flow_fusion/model/entity/active_timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Same formula as [ActiveTimerState.progress], sampled against [now]
/// instead of the once-per-second [ActiveTimerState.remaining] tick, so it
/// can be recomputed every animation frame. This is the single definition
/// of "how far through the current timer are we" — nothing else should
/// compute this independently.
double computeSmoothProgress({
  required bool isPaused,
  required bool awaitingManualAdvance,
  required DateTime? endsAt,
  required int totalMs,
  required double fallbackProgress,
  required DateTime now,
}) {
  if (isPaused || awaitingManualAdvance || endsAt == null) {
    return fallbackProgress;
  }
  if (totalMs <= 0) return 1.0;

  final remainingMs = endsAt.difference(now).inMilliseconds;
  final doneMs = totalMs - remainingMs;
  return (doneMs / totalMs).clamp(0.0, 1.0);
}

/// Owns a single [Ticker] that recomputes a shared smooth progress value
/// every frame and exposes it to [builder] via a [ValueListenable]. Feed
/// the same listenable into every widget on screen that needs a live
/// progress fraction — do not create a second, independently-ticking
/// source.
class TimerProgressTicker extends StatefulWidget {
  const TimerProgressTicker({
    required this.state,
    required this.builder,
    DateTime Function()? now,
    super.key,
  }) : _now = now ?? DateTime.now;

  final ActiveTimerState state;
  final Widget Function(BuildContext context, ValueListenable<double> smoothProgress)
  builder;
  final DateTime Function() _now;

  @override
  State<TimerProgressTicker> createState() => _TimerProgressTickerState();
}

class _TimerProgressTickerState extends State<TimerProgressTicker>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<double> _progress = ValueNotifier<double>(
    widget.state.progress,
  );
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) => _tick());
    _ticker.start();
  }

  void _tick() {
    final currentTimer = widget.state.currentTimer;
    final next = computeSmoothProgress(
      isPaused: widget.state.isPaused,
      awaitingManualAdvance: widget.state.awaitingManualAdvance,
      endsAt: widget.state.endsAt,
      totalMs: currentTimer?.plannedDuration.inMilliseconds ?? 0,
      fallbackProgress: widget.state.progress,
      now: widget._now(),
    );
    if (next != _progress.value) {
      _progress.value = next;
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _progress);
}
```

- [ ] **Step 2: Run analyzer**

Run: `flutter analyze lib/ui/views/timer_view/widgets/timer_progress_ticker.dart`
Expected: No issues.

---

### Task 3: `TimerQueueItem` — live connector fill for the current station

**Files:**
- Modify: `lib/ui/views/timer_view/widgets/timer_queue_item.dart`

**Interfaces:**
- Consumes: `ValueListenable<double>` (from `package:flutter/foundation.dart`, re-exported via `material.dart`) — same type `TimerProgressTicker` (Task 2) exposes, but this task's test uses a plain `ValueNotifier<double>` directly, no dependency on Task 2's widget.
- Produces: `TimerQueueItem` gains a new optional constructor parameter `ValueListenable<double>? liveProgress` (defaults to `null`, fully backward compatible with existing call site until Task 4 wires it up).

- [ ] **Step 1: Add `liveProgress` and the live fill to `TimerQueueItem`**

In `lib/ui/views/timer_view/widgets/timer_queue_item.dart`, update the constructor (currently lines 10-17):

```dart
  const TimerQueueItem({
    super.key,
    required this.timer,
    required this.index,
    required this.total,
    required this.isCurrent,
    required this.isDone,
    this.liveProgress,
  });

  final SessionTimer timer;
  final int index;
  final int total;
  final bool isCurrent;
  final bool isDone;
  final ValueListenable<double>? liveProgress;
```

Replace the right-connector block (currently lines 63-73):

```dart
                  if (rightVisible)
                    Positioned(
                      right: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutCubic,
                        width: 52,
                        height: 3,
                        color: stationColor.withValues(alpha: 0.7),
                      ),
                    ),
```

with:

```dart
                  if (rightVisible)
                    Positioned(
                      right: 0,
                      child: (isCurrent && liveProgress != null)
                          ? _LiveConnectorFill(
                              width: 52,
                              height: 3,
                              trackColor: colors.lineStrong,
                              fillColor: stationColor,
                              progress: liveProgress!,
                            )
                          : AnimatedContainer(
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeOutCubic,
                              width: 52,
                              height: 3,
                              color: stationColor.withValues(alpha: 0.7),
                            ),
                    ),
```

Add a new private widget at the bottom of the file (after the closing brace of `TimerQueueItem`):

```dart
class _LiveConnectorFill extends StatelessWidget {
  const _LiveConnectorFill({
    required this.width,
    required this.height,
    required this.trackColor,
    required this.fillColor,
    required this.progress,
  });

  final double width;
  final double height;
  final Color trackColor;
  final Color fillColor;
  final ValueListenable<double> progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Container(width: width, height: height, color: trackColor),
          ValueListenableBuilder<double>(
            valueListenable: progress,
            builder: (context, value, _) {
              return Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: value.clamp(0.0, 1.0),
                  child: Container(height: height, color: fillColor),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Run analyzer**

Run: `flutter analyze lib/ui/views/timer_view/widgets/timer_queue_item.dart`
Expected: No issues.

---

### Task 4: Thread `smoothProgress` through `TimerBody`

**Files:**
- Modify: `lib/ui/views/timer_view/widgets/timer_body.dart`

**Interfaces:**
- Consumes: `ValueListenable<double>` (Task 2's `TimerProgressTicker` produces one; this task's test constructs a plain `ValueNotifier<double>` directly). `TimerQueueItem.liveProgress` and `TimerProgressCircle`'s existing `progress` field (Tasks 1 & 3).
- Produces: `TimerBody` gains a new required constructor parameter `ValueListenable<double> smoothProgress`. Task 5 supplies it from `TimerProgressTicker`'s builder.

- [ ] **Step 1: Run test to verify it fails**

Run: `flutter test test/ui/views/timer_view/widgets/timer_body_test.dart`
Expected: FAIL — `smoothProgress` is not a defined named parameter of `TimerBody`.

- [ ] **Step 2: Thread `smoothProgress` through `TimerBody`**

In `lib/ui/views/timer_view/widgets/timer_body.dart`, update the constructor (currently lines 16-21):

```dart
  const TimerBody({
    super.key,
    required this.state,
    required this.controller,
    required this.routeScrollController,
    required this.smoothProgress,
  });

  final ActiveTimerState state;
  final ActiveTimerController controller;
  final ScrollController routeScrollController;
  final ValueListenable<double> smoothProgress;
```

Replace the `TimerProgressCircle(...)` construction (currently lines 64-70):

```dart
                          TimerProgressCircle(
                            progress: state.progress,
                            color: typeColor,
                            timeLabel: state.formattedRemaining,
                            timerLabel: timer.title,
                            size: compact ? 250 : 320,
                          ),
```

with:

```dart
                          ValueListenableBuilder<double>(
                            valueListenable: smoothProgress,
                            builder: (context, progress, _) {
                              return TimerProgressCircle(
                                progress: progress,
                                color: typeColor,
                                timeLabel: state.formattedRemaining,
                                timerLabel: timer.title,
                                size: compact ? 250 : 320,
                              );
                            },
                          ),
```

Update the `TimerQueueItem` construction inside the queue loop (currently lines 195-201):

```dart
                                    TimerQueueItem(
                                      timer: state.timers[index],
                                      index: index,
                                      total: state.timers.length,
                                      isCurrent: index == state.currentIndex,
                                      isDone: index < state.currentIndex,
                                      liveProgress: index == state.currentIndex
                                          ? smoothProgress
                                          : null,
                                    ),
```

- [ ] **Step 3: Run analyzer**

Run: `flutter analyze lib/ui/views/timer_view/widgets/timer_body.dart`
Expected: No issues.

---

### Task 5: Wire `TimerProgressTicker` into `TimerView`

**Files:**
- Modify: `lib/ui/views/timer_view/timer_view.dart`

**Interfaces:**
- Consumes: `TimerProgressTicker` (Task 2), `TimerBody`'s new `smoothProgress` parameter (Task 4).
- Produces: the fully wired timer screen — no further consumers.

This is pure plumbing connecting already-tested pieces (Tasks 1-4) to the real `ActiveTimerController` obtained via `GetIt`. Automated widget testing of `TimerView` itself would require registering all of `ActiveTimerController`'s DAOs/services in `GetIt` (not currently scaffolded anywhere in this codebase), which is out of scope here — this task is verified manually against the epic's acceptance criteria instead.

- [ ] **Step 1: Wrap `TimerBody` with `TimerProgressTicker`**

In `lib/ui/views/timer_view/timer_view.dart`, add the import:

```dart
import 'package:flow_fusion/ui/views/timer_view/widgets/timer_progress_ticker.dart';
```

Replace the `build` method's body (currently lines 93-105):

```dart
  @override
  Widget build(BuildContext context) {
    final state = _controller.state;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: !state.hasActiveSession
          ? const TimerEmptyState()
          : TimerBody(
              state: state,
              controller: _controller,
              routeScrollController: _routeScrollController,
            ),
    );
  }
```

with:

```dart
  @override
  Widget build(BuildContext context) {
    final state = _controller.state;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: !state.hasActiveSession
          ? const TimerEmptyState()
          : TimerProgressTicker(
              state: state,
              builder: (context, smoothProgress) => TimerBody(
                state: state,
                controller: _controller,
                routeScrollController: _routeScrollController,
                smoothProgress: smoothProgress,
              ),
            ),
    );
  }
```

- [ ] **Step 2: Run the full test suite and analyzer**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 3: Manual verification against the epic's acceptance criteria**

Run: `flutter run -d macos` (or the platform you develop on), then in the running app:

1. Start a session with at least two timers (one short, e.g. 20-30s, makes the checks below fast).
2. Watch the progress circle: confirm the arc sweeps continuously, frame-to-frame, not once per second.
3. Let the first timer run to completion: confirm the arc reads exactly full (closed loop) right as the countdown hits `0:00` — no visible gap left over, and critically, confirm it does **not** look full/done earlier (around 70-90% elapsed) — this is the bug fixed in Task 1.
4. While the first timer runs, watch the queue's connector line between the current and next station: confirm it fills left-to-right smoothly, proportional to elapsed time, not just crossfading color on completion.
5. Confirm the dot's color/size crossfade animation when a timer transitions from current → done still plays exactly as before (280ms ease-out).
6. Pause the session mid-timer: confirm both the circle and the connector fill freeze in place (no jump, no continued animation while paused). Resume: confirm they continue smoothly from where they froze.
7. Open Flutter DevTools' performance overlay (or `flutter run --profile` + the performance view) while a timer runs: confirm no new dropped frames/jank versus before this change.
