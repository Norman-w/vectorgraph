import 'dart:ui';

import 'package:flutter/material.dart';
class SectorPainter extends CustomPainter {
  final Rect rect;
  final double startAngle;
  final double sweepAngle;
  final Offset startPoint;
  final Offset endPoint;
  final bool useCenter;
  final Color color;
  final double rotateZ;
  ///是否显示弧线所在椭圆的圆心
  final bool showSectorOwnEllipseCenter;
  ///是否显示弧线所在椭圆的外切矩形
  final bool showSectorOwnEllipseBoundRect;
  SectorPainter(
      this.rotateZ,
      this.rect,
      this.startAngle,
      this.sweepAngle,
      this.startPoint,
      this.endPoint,
      this.useCenter,
      this.color,
      this.showSectorOwnEllipseCenter,
      this.showSectorOwnEllipseBoundRect,
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

    if(!showSectorOwnEllipseCenter){
      canvas.drawPoints(PointMode.points, [rect.center], paint);
    }

    //region 让canvas绕任意一点旋转.
    //保存之前环境
    canvas.save();
    //坐标圆点设置到形状中心
    canvas.translate(rect.center.dx, rect.center.dy)  ;
    //旋转
    canvas.rotate(rotateZ)  ;
    //坐标圆点重置到 0,0
    canvas.translate(-rect.center.dx, -rect.center.dy) ;

    //填充
    paint.style = PaintingStyle.fill;
    // //旋转之后的弧线(最终正确展示的)
    // canvas.drawArc(rect, startAngle, sweepAngle, false,paint);
    // //绘制起始点到开始点的连线
    // canvas.drawLine(rect.center, startPoint, paint);
    // //绘制起始点到结束点的连线
    // canvas.drawLine(rect.center, endPoint, paint);
    //定义path
    Path path = Path();
    //绘制起始点到开始点的连线
    path.moveTo(rect.center.dx, rect.center.dy);
    path.lineTo(startPoint.dx, startPoint.dy);
    //用弧线连接到结束点
    path.arcTo(rect, startAngle, sweepAngle, false);
    //绘制起始点到结束点的连线
    path.lineTo(rect.center.dx, rect.center.dy);
    //绘制path
    canvas.drawPath(path, paint);

    //外切矩形
    if(showSectorOwnEllipseBoundRect){
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
