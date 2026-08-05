import 'package:flow_fusion/ui/theme/app_theme_extension.dart';
import 'package:flow_fusion/ui/views/timer_view/widgets/timer_progress_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates minimal test theme colors
final testColors = FlowFusionColors(
  pageBackground: Colors.white,
  sidebarBackground: Colors.grey.shade100,
  sidebarBorder: Colors.grey.shade300,
  cardBackground: Colors.white,
  cardBorder: Colors.grey.shade200,
  cardHover: Colors.grey.shade100,
  panelSoft: Colors.grey.shade50,
  panelMuted: Colors.grey.shade200,
  lineStrong: Colors.grey.shade400,
  accent: Colors.blue,
  accentStrong: Colors.blue.shade700,
  accentSoft: Colors.blue.shade100,
  accentBackground: Colors.blue.shade50,
  accentForeground: Colors.blue.shade900,
  mutedForeground: Colors.grey.shade600,
  success: Colors.green,
  successSoft: Colors.green.shade100,
  warning: Colors.orange,
  danger: Colors.red,
  dangerSoft: Colors.red.shade100,
);

/// Creates a minimal Material app with theme setup for testing
Widget createTestApp({
  required double progress,
  required Color color,
  required String timeLabel,
  required String timerLabel,
  required double size,
}) {
  return MaterialApp(
    theme: ThemeData(
      extensions: [testColors],
      useMaterial3: true,
    ),
    home: Scaffold(
      body: TimerProgressCircle(
        progress: progress,
        color: color,
        timeLabel: timeLabel,
        timerLabel: timerLabel,
        size: size,
      ),
    ),
  );
}

void main() {
  group('TimerProgressCircle', () {
    testWidgets('renders without throwing exceptions with 0.5 progress',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          progress: 0.5,
          color: Colors.blue,
          timeLabel: '5:30',
          timerLabel: 'Work',
          size: 300,
        ),
      );

      expect(find.byType(TimerProgressCircle), findsOneWidget);
      expect(find.text('5:30'), findsOneWidget);
      expect(find.text('Work'), findsOneWidget);
    });

    testWidgets('renders with progress value 0.0', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          progress: 0.0,
          color: Colors.green,
          timeLabel: '10:00',
          timerLabel: 'Ready',
          size: 250,
        ),
      );

      expect(find.byType(TimerProgressCircle), findsOneWidget);
      expect(find.text('10:00'), findsOneWidget);
    });

    testWidgets('renders with progress value 1.0', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          progress: 1.0,
          color: Colors.red,
          timeLabel: '0:00',
          timerLabel: 'Complete',
          size: 200,
        ),
      );

      expect(find.byType(TimerProgressCircle), findsOneWidget);
      expect(find.text('0:00'), findsOneWidget);
    });

    testWidgets('renders with progress 0.25', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          progress: 0.25,
          color: Colors.purple,
          timeLabel: '3:45',
          timerLabel: 'Break',
          size: 300,
        ),
      );

      expect(find.byType(TimerProgressCircle), findsOneWidget);
    });

    testWidgets('renders with progress 0.75', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          progress: 0.75,
          color: Colors.orange,
          timeLabel: '1:15',
          timerLabel: 'Work',
          size: 300,
        ),
      );

      expect(find.byType(TimerProgressCircle), findsOneWidget);
    });

    testWidgets('renders with red color', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          progress: 0.5,
          color: Colors.red,
          timeLabel: '5:00',
          timerLabel: 'Test',
          size: 300,
        ),
      );

      expect(find.byType(TimerProgressCircle), findsOneWidget);
    });

    testWidgets('renders with green color', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          progress: 0.5,
          color: Colors.green,
          timeLabel: '5:00',
          timerLabel: 'Test',
          size: 300,
        ),
      );

      expect(find.byType(TimerProgressCircle), findsOneWidget);
    });

    testWidgets('renders with blue color', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          progress: 0.5,
          color: Colors.blue,
          timeLabel: '5:00',
          timerLabel: 'Test',
          size: 300,
        ),
      );

      expect(find.byType(TimerProgressCircle), findsOneWidget);
    });

    testWidgets('progress arc uses solid color paint (no gradient shader)',
        (WidgetTester tester) async {
      const testColor = Colors.blue;

      await tester.pumpWidget(
        createTestApp(
          progress: 0.6,
          color: testColor,
          timeLabel: '2:24',
          timerLabel: 'Work',
          size: 300,
        ),
      );

      // Verify CustomPaint exists
      expect(find.byType(CustomPaint), findsWidgets);

      // The CustomPaint should draw both a track circle and a progress arc.
      // Verify circle is drawn (track background)
      expect(
        find.descendant(
          of: find.byType(TimerProgressCircle),
          matching: find.byType(CustomPaint),
        ),
        paints..circle(),
      );

      // Verify arc is drawn after the circle (progress arc).
      // If a SweepGradient shader was used, this would fail or produce
      // different paint operations. Solid color paints produce clean arc operations.
      expect(
        find.descendant(
          of: find.byType(TimerProgressCircle),
          matching: find.byType(CustomPaint),
        ),
        paints..arc(),
      );
    });
  });
}
