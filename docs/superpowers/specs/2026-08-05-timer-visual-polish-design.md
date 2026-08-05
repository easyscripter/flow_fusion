# Timer visual polish — smooth progress + real-time queue fill

**Source:** [docs/tasks/epic-06-timer-visual-polish.md](../../tasks/epic-06-timer-visual-polish.md)
**Status:** Approved for planning

## Problem

Two visuals on the timer screen update in discrete ~1s steps instead of
smoothly, because both are driven directly by the once-per-second countdown
tick:

1. [`TimerProgressCircle`](../../../lib/ui/views/timer_view/widgets/timer_progress_circle.dart)
   — the circular arc jumps once per second instead of sweeping continuously.
2. [`TimerQueueItem`](../../../lib/ui/views/timer_view/widgets/timer_queue_item.dart)
   — the connector line between the current and next station is a flat
   color; it should fill in real time proportional to the current timer's
   elapsed fraction (a "train moving along the line" effect).

Additionally, a genuine rendering bug was found during investigation: the
progress circle visually reads as "done" around 70-90% of the way through a
timer, well before the countdown actually reaches zero, even though the
displayed time text is correct at that moment.

## Root cause of the "looks done early" bug

This is **not** an arithmetic bug. `ActiveTimerState.progress`
(`lib/model/entity/active_timer_state.dart:49`) computes
`doneMs = totalMs - remaining.inMilliseconds`, correctly derived from
`remaining`, which itself tracks `endsAt.difference(now)` each tick. The
countdown text (`formattedRemaining`) is driven by the same `remaining` and
is confirmed correct by the user at the moment the ring looks "full" —
ruling out a state-layer bug.

The actual defect is in
[`_CirclePainter.paint`](../../../lib/ui/views/timer_view/widgets/timer_progress_circle.dart:74):

```dart
final progressPaint = Paint()
  ..shader = SweepGradient(
    startAngle: -math.pi / 2,
    endAngle: 3 * math.pi / 2,
    colors: [color.withValues(alpha: 0.3), color],
  ).createShader(rect)
  ...
canvas.drawArc(
  rect,
  -math.pi / 2,
  ((2 * math.pi) * progress.clamp(0, 1)).toDouble(),
  false,
  progressPaint,
);
```

The `SweepGradient` interpolates alpha (0.3 → 1.0) across the **entire
circle** (`-π/2` to `3π/2`, i.e. the full 2π span), but `drawArc` only
renders `sweepAngle = 2π · progress` of it. The visible tip's alpha is
therefore approximately `0.3 + 0.7 · progress` — already ~0.9 by 85%
progress. Combined with the ring being geometrically ~70-90% closed at that
point, the arc reads as solid/complete well before the timer actually
finishes.

**Fix:** remove the alpha-ramped `SweepGradient` and paint the swept arc with
a flat, solid `color`. This removes the misleading effect entirely, is
simpler, and is cheaper to repaint every frame (no shader reconstruction
needed).

## Design

### 1. `_CirclePainter` fix (bug fix, prerequisite to animating)

In `timer_progress_circle.dart`, replace the `SweepGradient`-shaded
`progressPaint` with a plain solid-color `Paint` (`..color = color`, no
shader). Track paint (`trackColor`) and geometry are unchanged.

### 2. Single shared smooth-progress source

New widget: `lib/ui/views/timer_view/widgets/timer_progress_ticker.dart`

```dart
class TimerProgressTicker extends StatefulWidget {
  const TimerProgressTicker({
    required this.controller,
    required this.builder,
    super.key,
  });

  final ActiveTimerController controller;
  final Widget Function(BuildContext, ValueListenable<double>) builder;
}
```

- `StatefulWidget` with `SingleTickerProviderStateMixin`, owns a
  `ValueNotifier<double>` and a `Ticker` that recomputes the notifier's value
  every frame.
- Per-frame calculation mirrors `ActiveTimerState.progress`'s formula, but
  samples wall-clock time continuously instead of once per second:
  - If paused, `awaitingManualAdvance`, or `endsAt == null`: freeze at the
    discrete `controller.progress` value.
  - Otherwise: `totalMs = currentTimer.plannedDuration.inMilliseconds`;
    `remainingMs = endsAt.difference(DateTime.now()).inMilliseconds`;
    `progress = ((totalMs - remainingMs) / totalMs).clamp(0.0, 1.0)`.
- This is the same formula as `ActiveTimerState.progress`, just sampled
  every frame instead of every second — there is exactly one definition of
  "how far through the current timer," continuously evaluated. No second,
  independently-computed progress value is introduced.
- Ticks only while mounted; disposes its `Ticker` in `dispose()`.
- Reading `controller`/`controller.state` directly each frame (rather than
  reacting to MobX) means no explicit reset logic is needed when the
  timer/phase changes — the next frame simply reads the new `currentTimer`,
  `endsAt`, etc.

In `timer_view.dart`, wrap the existing `TimerBody` construction:

```dart
TimerProgressTicker(
  controller: _controller,
  builder: (context, smoothProgress) => TimerBody(
    state: state,
    controller: _controller,
    routeScrollController: _routeScrollController,
    smoothProgress: smoothProgress,
  ),
)
```

### 3. Threading the value through `TimerBody`

`TimerBody` gains a new required `ValueListenable<double> smoothProgress`
parameter.

- `TimerProgressCircle` construction is wrapped in
  `ValueListenableBuilder<double>` — only the `CustomPaint` subtree rebuilds
  every frame, not the surrounding badges/description/buttons.
- In the queue-items loop, `smoothProgress` is passed to `TimerQueueItem`
  only for the current item: `liveProgress: isCurrent ? smoothProgress : null`.

This keeps per-frame rebuild scope to exactly the two widgets that need it.

### 4. `TimerQueueItem` connector fill

New optional parameter: `ValueListenable<double>? liveProgress`.

When `isCurrent && liveProgress != null`, the **right** connector (line
toward the next station — the only one the epic asks to change) is rendered
as a `ValueListenableBuilder<double>` wrapping a small `Stack`:

- Background: a static bar in `colors.lineStrong` (matching the existing
  "not yet reached" look), full width.
- Foreground: `Align(alignment: Alignment.centerLeft)` +
  `FractionallySizedBox(widthFactor: progress.clamp(0.0, 1.0))` wrapping a
  bar in `stationColor`, growing left → right as the current timer elapses.

The left connector, the dot's crossfade animation
(`isDone`/`isCurrent` → color/size via `AnimatedContainer`, 280ms
`easeOutCubic`), and all non-current items are unchanged — this is additive
only.

## Files touched

- `lib/ui/views/timer_view/widgets/timer_progress_ticker.dart` — new
- `lib/ui/views/timer_view/timer_view.dart` — wrap `TimerBody`
- `lib/ui/views/timer_view/widgets/timer_body.dart` — thread `smoothProgress`
  through to both widgets
- `lib/ui/views/timer_view/widgets/timer_progress_circle.dart` — solid-color
  arc fix
- `lib/ui/views/timer_view/widgets/timer_queue_item.dart` — connector fill

No changes to `ActiveTimerController`, `ActiveTimerState`, `SessionTicker`,
or any persistence/business logic — the progress math there is already
correct; only a UI-layer per-frame sampling layer is added on top of it.

## Testing

- Manual: run the app, start a session, watch the circle sweep continuously
  and the queue connector fill in real time; confirm the arc reads exactly
  full at 0:00 with no leftover gap; confirm it no longer reads as "done"
  early.
- Manual: pause/resume mid-timer — smooth progress should freeze on pause
  and resume smoothly, matching the discrete `state.progress` at all times
  it's not actively running.
- Manual: verify no dropped frames/jank on the timer screen (DevTools
  performance overlay) — only two small subtrees repaint per frame.
- Existing dot crossfade animations on state transitions should look
  unchanged.

## Out of scope

- Any other visual changes to the timer screen beyond these two widgets
  (per epic).
- Changing underlying timer/countdown logic — confirmed correct, not
  touched.
