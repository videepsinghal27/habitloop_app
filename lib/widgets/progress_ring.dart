import 'package:flutter/material.dart';
import 'dart:math';

class DashboardProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0

  const DashboardProgressRing({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RingPainter(progress),
      child: SizedBox(
        height: 250,
        width: 250,
        child: Center(
          child: Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;

  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 20.0;
    final radius = (size.width - strokeWidth) / 2;

    final center = Offset(size.width / 2, size.height / 2);

    final backgroundPaint = Paint()
      ..strokeWidth = strokeWidth
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..strokeWidth = strokeWidth
      ..color = Colors.teal
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final double sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
