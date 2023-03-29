import 'package:flutter/material.dart';
class ArcPainter extends CustomPainter {
  // final Offset position;
  final Rect rect;
  final double startAngle;
  final double sweepAngle;
  final bool useCenter;
  final Color color;
  ArcPainter(
      // this.position,
      this.rect, this.startAngle, this.sweepAngle, this.useCenter, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
//
// class MyArcPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.green
//       ..style = PaintingStyle.fill;
//
//     Path path = Path()
//       ..moveTo(300, 100)
//       ..relativeArcToPoint(Offset(100, 50), radius: Radius.elliptical(100, 60), largeArc: false, clockwise: true);
//
//     canvas.drawPath(path, paint);
//
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
//
// class MyArcWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: MyArcPainter(),
//     );
//   }
// }

///待测试的代码

// import 'package:flutter/material.dart';
// import 'dart:math' as math;
//
// class MyArcPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.green
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;
//
//     Rect oval = Rect.fromCenter(center: Offset(300, 100), width: 200, height: 120);
//     canvas.drawArc(oval, math.pi / 2, math.pi, false, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
//
// class MyArcWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: MyArcPainter(),
//     );
//   }
// }
