import 'package:flow_fusion/enums/timer_type.dart';
import 'package:flow_fusion/model/entity/active_timer_state.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/model/entity/database/session_timer.dart';
import 'package:flow_fusion/ui/views/timer_view/widgets/timer_progress_ticker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates a minimal SessionTimer for testing
SessionTimer createTestTimer({
  int? id,
  required int sessionId,
  required int position,
  String title = 'Test Timer',
  required Duration plannedDuration,
}) {
  return SessionTimer(
    id: id,
    sessionId: sessionId,
    position: position,
    title: title,
    type: TimerType.work,
    plannedDuration: plannedDuration,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

/// Creates a minimal Session for testing
Session createTestSession({int? id}) {
  return Session(
    id: id ?? 1,
    title: 'Test Session',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

/// Creates a test ActiveTimerState with controlled values
ActiveTimerState createTestState({
  SessionTimer? currentTimer,
  bool isPaused = false,
  bool awaitingManualAdvance = false,
  DateTime? endsAt,
  double progress = 0.0,
}) {
  final state = ActiveTimerState();
  state.session = createTestSession();

  if (currentTimer != null) {
    state.timers = [currentTimer];
    state.currentIndex = 0;
  } else {
    state.timers = const [];
    state.currentIndex = -1;
  }

  state.isPaused = isPaused;
  state.awaitingManualAdvance = awaitingManualAdvance;
  state.endsAt = endsAt;

  return state;
}

void main() {
  group('computeSmoothProgress', () {
    test('returns fallbackProgress when isPaused is true', () {
      final now = DateTime(2025, 1, 1, 12, 0, 0);
      final endsAt = DateTime(2025, 1, 1, 12, 5, 0);

      final result = computeSmoothProgress(
        isPaused: true,
        awaitingManualAdvance: false,
        endsAt: endsAt,
        totalMs: 300000,
        fallbackProgress: 0.3,
        now: now,
      );

      expect(result, equals(0.3));
    });

    test('returns fallbackProgress when awaitingManualAdvance is true', () {
      final now = DateTime(2025, 1, 1, 12, 0, 0);
      final endsAt = DateTime(2025, 1, 1, 12, 5, 0);

      final result = computeSmoothProgress(
        isPaused: false,
        awaitingManualAdvance: true,
        endsAt: endsAt,
        totalMs: 300000,
        fallbackProgress: 0.5,
        now: now,
      );

      expect(result, equals(0.5));
    });

    test('returns fallbackProgress when endsAt is null', () {
      final now = DateTime(2025, 1, 1, 12, 0, 0);

      final result = computeSmoothProgress(
        isPaused: false,
        awaitingManualAdvance: false,
        endsAt: null,
        totalMs: 300000,
        fallbackProgress: 0.7,
        now: now,
      );

      expect(result, equals(0.7));
    });

    test('returns 1.0 when totalMs is 0', () {
      final now = DateTime(2025, 1, 1, 12, 0, 0);
      final endsAt = DateTime(2025, 1, 1, 12, 5, 0);

      final result = computeSmoothProgress(
        isPaused: false,
        awaitingManualAdvance: false,
        endsAt: endsAt,
        totalMs: 0,
        fallbackProgress: 0.5,
        now: now,
      );

      expect(result, equals(1.0));
    });

    test('returns 1.0 when totalMs is negative', () {
      final now = DateTime(2025, 1, 1, 12, 0, 0);
      final endsAt = DateTime(2025, 1, 1, 12, 5, 0);

      final result = computeSmoothProgress(
        isPaused: false,
        awaitingManualAdvance: false,
        endsAt: endsAt,
        totalMs: -1,
        fallbackProgress: 0.5,
        now: now,
      );

      expect(result, equals(1.0));
    });

    test('computes correct progress when running normally', () {
      final endsAt = DateTime(2025, 1, 1, 12, 5, 0);
      final now = DateTime(2025, 1, 1, 12, 2, 30); // 2.5 minutes elapsed
      final totalMs = 5 * 60 * 1000; // 5 minutes in milliseconds

      final result = computeSmoothProgress(
        isPaused: false,
        awaitingManualAdvance: false,
        endsAt: endsAt,
        totalMs: totalMs,
        fallbackProgress: 0.0,
        now: now,
      );

      expect(result, closeTo(0.5, 0.001)); // 2.5/5 = 0.5
    });

    test('clamps progress to 0.0 when before timer start', () {
      final endsAt = DateTime(2025, 1, 1, 12, 5, 0);
      final now = DateTime(2025, 1, 1, 11, 50, 0); // Way before end time
      final totalMs = 5 * 60 * 1000;

      final result = computeSmoothProgress(
        isPaused: false,
        awaitingManualAdvance: false,
        endsAt: endsAt,
        totalMs: totalMs,
        fallbackProgress: 0.0,
        now: now,
      );

      expect(result, equals(0.0));
    });

    test('clamps progress to 1.0 when after timer end', () {
      final endsAt = DateTime(2025, 1, 1, 12, 5, 0);
      final now = DateTime(2025, 1, 1, 12, 10, 0); // Way after end time
      final totalMs = 5 * 60 * 1000;

      final result = computeSmoothProgress(
        isPaused: false,
        awaitingManualAdvance: false,
        endsAt: endsAt,
        totalMs: totalMs,
        fallbackProgress: 0.0,
        now: now,
      );

      expect(result, equals(1.0));
    });

    test('computes 0.25 progress correctly', () {
      final endsAt = DateTime(2025, 1, 1, 12, 5, 0);
      final now = DateTime(2025, 1, 1, 12, 1, 15); // 1.25 minutes elapsed
      final totalMs = 5 * 60 * 1000;

      final result = computeSmoothProgress(
        isPaused: false,
        awaitingManualAdvance: false,
        endsAt: endsAt,
        totalMs: totalMs,
        fallbackProgress: 0.0,
        now: now,
      );

      expect(result, closeTo(0.25, 0.001));
    });

    test('computes 0.75 progress correctly', () {
      final endsAt = DateTime(2025, 1, 1, 12, 5, 0);
      final now = DateTime(2025, 1, 1, 12, 3, 45); // 3.75 minutes elapsed
      final totalMs = 5 * 60 * 1000;

      final result = computeSmoothProgress(
        isPaused: false,
        awaitingManualAdvance: false,
        endsAt: endsAt,
        totalMs: totalMs,
        fallbackProgress: 0.0,
        now: now,
      );

      expect(result, closeTo(0.75, 0.001));
    });
  });

  group('TimerProgressTicker', () {
    testWidgets('renders widget with builder callback', (WidgetTester tester) async {
      final timer = createTestTimer(
        sessionId: 1,
        position: 0,
        plannedDuration: const Duration(minutes: 5),
      );
      final state = createTestState(currentTimer: timer);

      var buildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerProgressTicker(
              state: state,
              builder: (context, progress) {
                buildCount++;
                return Text('Progress: ${progress.value}');
              },
            ),
          ),
        ),
      );

      expect(find.byType(TimerProgressTicker), findsOneWidget);
      expect(buildCount, greaterThan(0));
    });

    testWidgets('updates ValueListenable when timer is running',
        (WidgetTester tester) async {
      final baseTime = DateTime(2025, 1, 1, 12, 0, 0);
      final endsAt = DateTime(2025, 1, 1, 12, 5, 0);
      final timer = createTestTimer(
        sessionId: 1,
        position: 0,
        plannedDuration: const Duration(minutes: 5),
      );
      final state = createTestState(currentTimer: timer, endsAt: endsAt);
      state.remaining = const Duration(minutes: 5);

      var currentTime = baseTime;
      late ValueListenable<double> capturedListenable;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerProgressTicker(
              state: state,
              now: () => currentTime,
              builder: (context, progress) {
                capturedListenable = progress;
                return Text('Progress: ${progress.value.toStringAsFixed(2)}');
              },
            ),
          ),
        ),
      );

      // Initial render and first tick
      expect(find.byType(TimerProgressTicker), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 16));
      final initialProgress = capturedListenable.value;

      // Move time forward by 1 minute
      currentTime = currentTime.add(const Duration(minutes: 1));
      await tester.pump(const Duration(milliseconds: 16));

      // Check that progress changed to ~0.2
      final updatedProgress = capturedListenable.value;
      expect(updatedProgress, closeTo(0.2, 0.01));
      expect(updatedProgress, greaterThan(initialProgress));
    });

    testWidgets('freezes progress when isPaused is true', (WidgetTester tester) async {
      final baseTime = DateTime(2025, 1, 1, 12, 0, 0);
      final endsAt = DateTime(2025, 1, 1, 12, 5, 0);
      final timer = createTestTimer(
        sessionId: 1,
        position: 0,
        plannedDuration: const Duration(minutes: 5),
      );

      var currentTime = baseTime;
      final state = createTestState(
        currentTimer: timer,
        endsAt: endsAt,
        isPaused: false,
      );
      // Initialize remaining so state.progress is meaningful (not degenerate 0 or 1)
      state.remaining = const Duration(minutes: 4, seconds: 30); // 90% remaining = 10% progress

      late ValueListenable<double> capturedListenable;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerProgressTicker(
              state: state,
              now: () => currentTime,
              builder: (context, progress) {
                capturedListenable = progress;
                return Text('Progress: ${progress.value.toStringAsFixed(2)}');
              },
            ),
          ),
        ),
      );

      // Initial frame to get ticker running
      await tester.pump(const Duration(milliseconds: 16));

      // Advance time by 30 seconds while not paused
      currentTime = currentTime.add(const Duration(seconds: 30));
      await tester.pump(const Duration(milliseconds: 16));

      // Capture progress value after first advance (should be somewhere in mid-range)
      final progressBeforePause = capturedListenable.value;
      expect(progressBeforePause, isNot(equals(0.0))); // Not at start
      expect(progressBeforePause, isNot(equals(1.0))); // Not at end

      // Now pause the timer by mutating state directly
      // _tick() reads widget.state.isPaused live on each frame, so it will see this change
      state.isPaused = true;

      // Advance time further while paused
      currentTime = currentTime.add(const Duration(seconds: 30));
      await tester.pump(const Duration(milliseconds: 16));

      // Capture progress value after pause (ticker should have frozen the value)
      final progressAfterPause = capturedListenable.value;

      // When paused, progress should NOT have changed despite time advancing 30 more seconds
      expect(progressAfterPause, equals(progressBeforePause),
          reason: 'Progress should freeze when isPaused=true');

      // Advance time even more to be certain
      currentTime = currentTime.add(const Duration(seconds: 60));
      await tester.pump(const Duration(milliseconds: 16));

      // Should still be frozen
      expect(capturedListenable.value, equals(progressBeforePause),
          reason: 'Progress should remain frozen across multiple ticks');
    });

    testWidgets('disposes ticker and ValueNotifier properly',
        (WidgetTester tester) async {
      final timer = createTestTimer(
        sessionId: 1,
        position: 0,
        plannedDuration: const Duration(minutes: 5),
      );
      final state = createTestState(currentTimer: timer);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerProgressTicker(
              state: state,
              builder: (context, progress) {
                return Text('Progress: ${progress.value}');
              },
            ),
          ),
        ),
      );

      expect(find.byType(TimerProgressTicker), findsOneWidget);

      // Dispose the widget
      await tester.pumpWidget(const SizedBox());

      // No exceptions should occur on dispose
      expect(find.byType(TimerProgressTicker), findsNothing);
    });

    testWidgets('initial progress matches state.progress',
        (WidgetTester tester) async {
      final timer = createTestTimer(
        sessionId: 1,
        position: 0,
        plannedDuration: const Duration(minutes: 5),
      );
      final state = createTestState(
        currentTimer: timer,
      );
      // Set remaining to 42% of duration (2.1 minutes of 5 minutes)
      state.remaining = const Duration(minutes: 2, seconds: 54);

      late double capturedProgress;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerProgressTicker(
              state: state,
              builder: (context, progress) {
                capturedProgress = progress.value;
                return Text('Progress: ${progress.value.toStringAsFixed(2)}');
              },
            ),
          ),
        ),
      );

      // Just pump once to allow one frame
      await tester.pump(const Duration(milliseconds: 16));

      // The initial progress should match the state's progress value
      // Without endsAt set, computeSmoothProgress returns fallbackProgress (state.progress)
      expect(find.byType(TimerProgressTicker), findsOneWidget);
      expect(capturedProgress, closeTo(0.42, 0.01));
    });

    testWidgets('uses custom now function if provided', (WidgetTester tester) async {
      final customTime = DateTime(2025, 1, 1, 10, 0, 0);
      final timer = createTestTimer(
        sessionId: 1,
        position: 0,
        plannedDuration: const Duration(minutes: 5),
      );
      final state = createTestState(currentTimer: timer);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerProgressTicker(
              state: state,
              now: () => customTime,
              builder: (context, progress) {
                return Text('Time: $customTime');
              },
            ),
          ),
        ),
      );

      expect(find.byType(TimerProgressTicker), findsOneWidget);
      expect(find.textContaining('Time:'), findsOneWidget);
    });

    testWidgets('exposes ValueListenable for listenable patterns',
        (WidgetTester tester) async {
      final timer = createTestTimer(
        sessionId: 1,
        position: 0,
        plannedDuration: const Duration(minutes: 5),
      );
      final state = createTestState(currentTimer: timer);

      late ValueListenable<double> capturedProgress;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerProgressTicker(
              state: state,
              builder: (context, progress) {
                capturedProgress = progress;
                return ValueListenableBuilder<double>(
                  valueListenable: progress,
                  builder: (context, value, child) {
                    return Text('Progress: ${value.toStringAsFixed(2)}');
                  },
                );
              },
            ),
          ),
        ),
      );

      // Pump once for frame, don't use pumpAndSettle as ticker runs indefinitely
      await tester.pump(const Duration(milliseconds: 16));

      // Verify the listenable is functional
      expect(capturedProgress, isNotNull);
      expect(capturedProgress.value, isA<double>());
    });

    testWidgets('handles no currentTimer gracefully', (WidgetTester tester) async {
      final state = createTestState(currentTimer: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerProgressTicker(
              state: state,
              builder: (context, progress) {
                return Text('Value: ${progress.value.toString()}');
              },
            ),
          ),
        ),
      );

      // Pump once to allow rendering
      await tester.pump(const Duration(milliseconds: 16));

      expect(find.byType(TimerProgressTicker), findsOneWidget);
      // Should not throw and should render successfully - just verify widget exists
      // The text content will contain the progress value as a string
      expect(find.byType(Text), findsWidgets);
    });
  });
}
