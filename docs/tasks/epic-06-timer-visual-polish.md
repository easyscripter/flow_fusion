# Epic 06 — Timer visual polish: smooth progress + real-time queue fill

**Priority:** P2 · **Status:** To do

## Context

Two visuals on the timer screen currently update in discrete ~1-second steps
instead of smoothly, because they're both driven directly by the same
once-per-second countdown tick rather than an interpolated value:

1. [`lib/ui/views/timer_view/widgets/timer_progress_circle.dart`](../../lib/ui/views/timer_view/widgets/timer_progress_circle.dart) —
   a `CustomPainter` arc driven by a `progress` prop (0.0–1.0). It currently
   jumps once per second instead of sweeping continuously, because
   `progress` itself only updates on the countdown's 1s tick.
2. [`lib/ui/views/timer_view/widgets/timer_queue_item.dart`](../../lib/ui/views/timer_view/widgets/timer_queue_item.dart) —
   the "station line" queue of upcoming timers. State transitions
   (`isDone`/`isCurrent`) already crossfade color via `AnimatedContainer`
   (280ms `easeOutCubic`), but the connector line between the current and
   next station is a flat color, not a live fill. It was decided this
   connector line should fill in real time, proportional to the *current*
   timer's elapsed-progress fraction (a "train moving along the line"
   effect) — not a fixed-duration cosmetic wipe on state change.

**These two should share one progress source**, not be solved twice: find (or
add) a single smoothly-interpolated 0.0–1.0 progress value for "how far
through the current timer are we, right now" and feed both widgets from it.
Check `active_timer_controller.dart` / `active_timer_state.dart` for where
progress is currently computed, and whether it's already `@observable` in a
way an `AnimationController`/`Tween` can drive off of, or whether you need to
add a ticker-driven interpolation layer between the raw per-second value and
these two widgets.

**Important — verify before animating:** confirm the underlying progress
fraction is arithmetically correct (matches actual remaining time) before
adding smoothing on top of it. If the raw value is wrong, animating it
smoothly just makes a wrong number look more convincing — fix the math first
if it's off, independent of the animation work.

## Task

1. Introduce (or reuse, if one already exists) a continuously-updating
   progress value — e.g. driven by an `AnimationController`/`Ticker` that
   interpolates between the discrete per-second updates — so both widgets can
   consume a smooth 0.0–1.0 stream instead of a stair-stepped one.
2. Update `TimerProgressCircle`'s `_CirclePainter` to repaint every frame off
   that smooth value instead of once per second.
3. Update `TimerQueueItem` so the connector line (`AnimatedContainer` for the
   line segment, `left`/`right` positioned in the current code) fills
   proportionally to that same smooth progress value while `isCurrent` is
   true, instead of only crossfading color on state change. The existing
   crossfade animation for dot color/size on state transitions
   (`isDone`/`isCurrent` changing) should stay as-is — this is additive, not
   a replacement of that behavior.

## Acceptance criteria

- [ ] The progress circle's arc sweeps continuously frame-to-frame while a
      timer runs, not once per second.
- [ ] At timer completion, the arc reads exactly full (or empty, whichever is
      the "done" state in this widget's convention) — no rounding gap left
      over from the interpolation.
- [ ] The queue's connector line between the current and next station fills
      proportionally to the current timer's live elapsed fraction, updating
      smoothly rather than jumping.
- [ ] Both widgets are driven from one shared progress source — verify there
      isn't a second, independently-computed progress value doing the same
      job.
- [ ] Existing state-transition animations (dot color/size crossfade when a
      timer becomes current/done) are unchanged.
- [ ] No new jank/dropped frames introduced — this should be cheap (a single
      interpolation feeding two widgets), not a per-widget animation loop
      each doing their own ticking.

## Out of scope

- Any other visual changes to the timer screen beyond these two widgets.
- Changing the underlying timer/countdown logic itself, beyond fixing the
  progress-fraction math if it's found to be wrong.
