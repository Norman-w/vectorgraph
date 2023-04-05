import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
class ArcPainterDemo extends CustomPainter {
  // final Offset position;
  final Rect rect;
  final double startAngle;
  final double sweepAngle;
  final bool useCenter;
  final Color color;
  final double rotateZ;
  ArcPainterDemo(
      this.rotateZ,
      // this.position,
      this.rect, this.startAngle, this.sweepAngle, this.useCenter, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    //没旋转之前的矩形
    canvas.drawRect(rect, paint..color=Colors.red);
    //没旋转之前的弧线
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint..color=Colors.blueAccent);
    //region 让canvas绕任意一点旋转.
    //保存之前环境
    canvas.save();
    //坐标圆点设置到形状中心
    canvas.translate(rect.center.dx, rect.center.dy)  ;
    //旋转
    canvas.rotate(rotateZ)  ;
    //坐标圆点重置到 0,0
    canvas.translate(-rect.center.dx, -rect.center.dy) ;
    //旋转之后的矩形
    canvas.drawRect(rect,paint..color = Colors.green);
    //旋转之后的弧线(最终正确展示的)
    canvas.drawArc(rect, startAngle, sweepAngle, false,
        paint
          ..color=Colors.amber
          ..strokeWidth=5
        ..strokeJoin=StrokeJoin.round
    );
    //重置之前环境
    canvas.restore();
    //endregion
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
