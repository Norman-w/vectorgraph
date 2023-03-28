import 'package:flutter/material.dart';
class CirclePaint extends StatelessWidget {
  final Offset position;
  final double radius;
  final Color color;
  final double strokeWidth;
  final bool showPositionText;
  const CirclePaint(this.position, this.radius, this.color, this.strokeWidth,
      {this.showPositionText = false, super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CirclePainter(position, radius, color, strokeWidth,
          showPositionText: showPositionText)
    );
  }
}

class CirclePainter extends CustomPainter {
  final Offset position;
  final double radius;
  final Color color;
  final double strokeWidth;
  final bool showPositionText;
  CirclePainter(this.position, this.radius, this.color, this.strokeWidth,
      {this.showPositionText = false});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round
      ..filterQuality = FilterQuality.high;
    canvas.drawCircle(position, radius, paint);
    if(showPositionText){
      TextPainter(
        text: TextSpan(
          text: '(${position.dx.toStringAsFixed(2)},${position.dy.toStringAsFixed(2)})',
          style: TextStyle(color: color, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout()
        ..paint(canvas, position);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}