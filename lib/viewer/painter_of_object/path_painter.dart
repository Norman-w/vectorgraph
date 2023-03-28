import 'package:flutter/material.dart';
class PathPaint extends StatelessWidget {
  final Path path;
  final Color color;
  final double strokeWidth;
  const PathPaint(this.path, this.color, this.strokeWidth, {super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PathPainter(path, color, strokeWidth),
    );
  }
}

class PathPainter extends CustomPainter {
  final Path path;
  final Color color;
  final double strokeWidth;
  PathPainter(this.path, this.color, this.strokeWidth);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}