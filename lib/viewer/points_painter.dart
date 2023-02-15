import 'dart:ui';

import 'package:flutter/material.dart';

class PointsPaint extends StatelessWidget {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final bool showPositionText;
  const PointsPaint(this.points, this.color, this.strokeWidth,
      {this.showPositionText = false, super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PointsPainter(points, color, strokeWidth,
          showPositionText: showPositionText)
    );
  }
}

class PointsPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final bool showPositionText;
  PointsPainter(this.points, this.color, this.strokeWidth,
      {this.showPositionText = false});
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
      if(showPositionText){
        TextPainter(
          text: TextSpan(
            text: '(${point.dx.toStringAsFixed(2)},${point.dy.toStringAsFixed(2)})',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          textDirection: TextDirection.ltr,
        )
          ..layout()
          ..paint(canvas, point);
      }
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}