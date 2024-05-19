import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TimerProgressBar extends StatelessWidget {
  final double? value;

  const TimerProgressBar({super.key, this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: TimerProgressBarPainter(value: value),
      ),
    );
  }
}

class TimerProgressBarPainter extends CustomPainter {
  final double? value;
  final double radius;
  final double width;
  final Color foregroundColorZero;
  final Color foregroundColorValue;
  final Color backgroundColor;

  const TimerProgressBarPainter({
    this.value,
    this.radius = 100,
    this.width = 10,
    this.foregroundColorZero = const Color.fromARGB(255, 88, 0, 0),
    this.foregroundColorValue = Colors.red,
    this.backgroundColor = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        radius,
        Paint()
          ..color = backgroundColor
          ..strokeWidth = 20
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
      canvas.drawArc(
        Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero)),
        -pi / 2,
        2 * pi * (value ?? 0.0),
        false,
        Paint()
          ..strokeWidth = 20
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
      value != oldDelegate.value;
}
