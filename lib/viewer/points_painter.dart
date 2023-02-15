import 'dart:ui';

import 'package:flutter/material.dart';

class PointsPaint extends StatelessWidget {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  const PointsPaint(this.points, this.color, this.strokeWidth, {super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PointsPainter(points, color, strokeWidth),
    );
  }
}

class PointsPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  PointsPainter(this.points, this.color, this.strokeWidth);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round
    // ..strokeJoin = StrokeJoin.miter
    //   ..isAntiAlias = true
      ..filterQuality = FilterQuality.high;
    for (final point in points) {
      canvas.drawPoints(PointMode.points, [point], paint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}