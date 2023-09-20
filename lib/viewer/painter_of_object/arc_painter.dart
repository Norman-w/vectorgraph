import 'dart:ui';

import 'package:flutter/material.dart';
class ArcPainter extends CustomPainter {
  final Rect rect;
  final double startAngle;
  final double sweepAngle;
  final bool useCenter;
  final Color color;
  final double rotateZ;
  ///是否显示弧线所在椭圆的圆心
  final bool showArcOwnEllipseCenter;
  ///是否显示弧线所在椭圆的外切矩形
  final bool showArcOwnEllipseBoundRect;
  ArcPainter(
      this.rotateZ,
      this.rect,
      this.startAngle,
      this.sweepAngle,
      this.useCenter,
      this.color,
      this.showArcOwnEllipseCenter,
      this.showArcOwnEllipseBoundRect,
      );
  @override
  void paint(Canvas canvas, Size size) {
    //绘制圆弧本体的画笔
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    //绘制圆弧的外切矩形的画笔
    final secondaryPaint = Paint()
    ..color = Colors.grey
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

    if(showArcOwnEllipseCenter){
      canvas.drawPoints(PointMode.points, [rect.center], paint);
    }

    //region 把圆弧的360个角度上的每一个点都绘制出来
    var points =
    //endregion


    //region 让canvas绕任意一点旋转.
    //保存之前环境
    canvas.save();
    //坐标圆点设置到形状中心
    canvas.translate(rect.center.dx, rect.center.dy)  ;
    //旋转
    canvas.rotate(rotateZ)  ;
    //坐标圆点重置到 0,0
    canvas.translate(-rect.center.dx, -rect.center.dy) ;
    //旋转之后的弧线(最终正确展示的)
    canvas.drawArc(rect, startAngle, sweepAngle, false,paint);
    //外切矩形
    if(showArcOwnEllipseBoundRect){
      canvas.drawRect(rect, secondaryPaint);
    }
    //重置之前环境
    canvas.restore();
    //endregion
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
