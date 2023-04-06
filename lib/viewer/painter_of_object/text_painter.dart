import 'dart:ui';
import 'package:flutter/material.dart' as mt;
typedef TPainter = mt.TextPainter;

class TextPaint extends mt.StatelessWidget {
  final Offset position;
  final Color color;
  final double fontSize;
  final String text;
  const TextPaint(this.position,this.text, this.color,this.fontSize,
      {super.key});
  @override
  mt.Widget build(mt.BuildContext context) {
    return mt.CustomPaint(
        painter: TextPainter(position,text, color, fontSize)
    );
  }
}

class TextPainter extends mt.CustomPainter {
  final Offset point;
  final Color color;
  final double fontSize;
  final String text;
  TextPainter(this.point,this.text, this.color, this.fontSize,
      );
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      // ..strokeWidth = fontSize
      ..strokeCap = StrokeCap.round
      ..filterQuality = FilterQuality.high;
    canvas.drawPoints(PointMode.points, [point], paint);
      mt.TextPainter(
        text: mt.TextSpan(
          text: text,
          style: mt.TextStyle(color: color, fontSize: fontSize),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout()
        ..paint(canvas, point);
  }
  @override
  bool shouldRepaint(mt.CustomPainter oldDelegate) {
    return true;
  }
}