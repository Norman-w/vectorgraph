import 'package:flutter/material.dart';
class RectPaint extends StatelessWidget {
  final List<Rect> rects;
  final Color color;
  const RectPaint(this.rects, this.color, {super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RectPainter(rects, color),
    );
  }
}
class RectPainter extends CustomPainter {
  final List<Rect> rects;
  final Color color;
  RectPainter(this.rects, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    for (final rect in rects) {
      canvas.drawRect(rect, paint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}