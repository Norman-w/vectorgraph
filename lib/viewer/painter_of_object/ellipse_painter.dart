import 'package:flutter/material.dart';
class EllipsePainter extends CustomPainter {
  final Offset position;
  final double radiusX;
  final double radiusY;
  final Color color;
  final double strokeWidth;
  final bool showPositionText;
  //椭圆的内切圆
  Rect _rect = Rect.zero;
  EllipsePainter(this.position, this.radiusX, this.radiusY, this.color, this.strokeWidth,
      {this.showPositionText = false}){
    _rect = Rect.fromCenter(center: position, width: radiusX * 2, height: radiusY * 2);
  }
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round
      ..filterQuality = FilterQuality.high;
    //flutter的canvas绘制椭圆使用drawOval,参数是要内切的矩形和笔刷.
    canvas.drawOval(_rect, paint);
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