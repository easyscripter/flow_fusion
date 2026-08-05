import 'package:flow_fusion/model/entity/active_timer_state.dart';
import 'package:flutter/foundation.dart';
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
    if (_shouldIdle) {
      _tick();
    } else {
      _ticker.start();
    }
  }

  bool get _shouldIdle =>
      widget.state.isPaused || widget.state.awaitingManualAdvance;

  @override
  void didUpdateWidget(covariant TimerProgressTicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldIdle) {
      if (_ticker.isActive) {
        // Compute the final value before freezing so it stays exact at the
        // instant of the transition rather than stalling on a stale frame.
        _tick();
        _ticker.stop();
      }
    } else {
      if (!_ticker.isActive) {
        _ticker.start();
      }
    }
  }

  void _tick() {
    final currentTimer = widget.state.currentTimer;
    if (currentTimer == null) {
      _progress.value = widget.state.progress;
      return;
    }
    final next = computeSmoothProgress(
      isPaused: widget.state.isPaused,
      awaitingManualAdvance: widget.state.awaitingManualAdvance,
      endsAt: widget.state.endsAt,
      totalMs: currentTimer.plannedDuration.inMilliseconds,
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
