import 'package:flutter/material.dart';
class RectanglesPaint extends StatelessWidget {
  final List<Rect> rects;
  final Color color;
  const RectanglesPaint(this.rects, this.color, {super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RectanglesPainter(rects, color),
    );
  }
}
class RectanglesPainter extends CustomPainter {
  final List<Rect> rects;
  final Color color;
  RectanglesPainter(this.rects, this.color);
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

class RectPainter extends CustomPainter {
  final Rect rect;
  final Color color;
  RectPainter(this.rect, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(rect, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class RectPaint extends StatelessWidget {
  final Rect rect;
  final Color color;
  const RectPaint(this.rect, this.color, {super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RectPainter(rect, color),
    );
  }
}