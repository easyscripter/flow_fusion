import 'dart:math';

import 'package:flutter/material.dart';

class TimerProgressBar extends StatelessWidget {
  final double? value;

  late final Color foregroundColorZero;
  late final Color foregroundColorValue;
  late final Color backgroundColor;

  TimerProgressBar.work({super.key, this.value}) {
    foregroundColorZero = Colors.amber.shade700;
    foregroundColorValue = Colors.amber;
    backgroundColor = Colors.grey.withOpacity(0.2);
  }

  TimerProgressBar.chill({super.key, this.value}) {
    foregroundColorZero = Colors.green.shade700;
    foregroundColorValue = Colors.green;
    backgroundColor = Colors.grey.withOpacity(0.2);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: TimerProgressBarPainter(
          value: value,
          radius: 100,
          arcWidth: 12,
          circleWidth: 16,
          backgroundColor: backgroundColor,
          foregroundColorZero: foregroundColorZero,
          foregroundColorValue: foregroundColorValue,
        ),
      ),
    );
  }
}

class TimerProgressBarPainter extends CustomPainter {
  final double? value;
  final double radius;
  final double arcWidth;
  final double circleWidth;
  final Color foregroundColorZero;
  final Color foregroundColorValue;
  final Color backgroundColor;

  const TimerProgressBarPainter({
    this.value,
    required this.radius,
    required this.arcWidth,
    required this.circleWidth,
    required this.foregroundColorZero,
    required this.foregroundColorValue,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        radius,
        Paint()
          ..color = backgroundColor
          ..strokeWidth = circleWidth
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke);

    if (value != null) {
      SweepGradient sweepGradient = SweepGradient(
        center: const Alignment(0, 0),
        colors: [
          foregroundColorZero,
          foregroundColorValue,
          foregroundColorZero
        ],
        stops: [0.0, value!, 1.0],
        transform: const GradientRotation(-pi / 2),
      );

      double gap = 0.06;

      canvas.drawArc(
        Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero)),
        -pi / 2 + gap,
        2 * (pi - gap) * (value!),
        false,
        Paint()
          ..strokeWidth = arcWidth
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..shader = sweepGradient.createShader(
            Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero)),
          ),
      );
    }
  }

  @override
  bool shouldRepaint(TimerProgressBarPainter oldDelegate) =>
      value != oldDelegate.value ||
      radius != oldDelegate.radius ||
      arcWidth != oldDelegate.arcWidth ||
      circleWidth != oldDelegate.circleWidth ||
      foregroundColorZero != oldDelegate.foregroundColorZero ||
      foregroundColorValue != oldDelegate.foregroundColorValue ||
      backgroundColor != oldDelegate.backgroundColor;
}
