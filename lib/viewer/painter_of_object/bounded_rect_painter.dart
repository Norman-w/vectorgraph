import 'package:flutter/material.dart';

class BoundedRectPainter extends CustomPainter {
  final Rect rect;
  final double? leftTopRadiusX;
  final double? leftTopRadiusY;
  final double? rightTopRadiusX;
  final double? rightTopRadiusY;
  final double? rightBottomRadiusX;
  final double? rightBottomRadiusY;
  final double? leftBottomRadiusX;
  final double? leftBottomRadiusY;
  final Color color;
  BoundedRectPainter(
      this.rect,
      this.leftTopRadiusX,
      this.leftTopRadiusY,
      this.rightTopRadiusX,
      this.rightTopRadiusY,
      this.rightBottomRadiusX,
      this.rightBottomRadiusY,
      this.leftBottomRadiusX,
      this.leftBottomRadiusY,
      this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    // canvas.drawRect(rect, paint);

    //从上面一条线开始绘制, 顺时针绘制
    var path = Path();

    //先绘制直线.x起点是矩形的左上角减去左上角的圆角x半径,y就是矩形的左上角的y坐标
    var topStartPoint = Offset(rect.left + (leftTopRadiusX ?? 0), rect.top);
    var topEndPoint = Offset(rect.right - (rightTopRadiusX ?? 0), rect.top);

    // var rightStartPoint = Offset(rect.right, rect.top + (rightTopRadiusY ?? 0));
    var rightEndPoint = Offset(rect.right, rect.bottom - (rightBottomRadiusY ?? 0));

    // var bottomStartPoint = Offset(rect.right - (rightBottomRadiusX ?? 0), rect.bottom);
    var bottomEndPoint = Offset(rect.left + (leftBottomRadiusX ?? 0), rect.bottom);

    // var leftStartPoint = Offset(rect.left, rect.bottom - (leftBottomRadiusY ?? 0));
    var leftEndPoint = Offset(rect.left, rect.top + (leftTopRadiusY ?? 0));


    path.moveTo(topStartPoint.dx, topStartPoint.dy);
    path.lineTo(topEndPoint.dx, topEndPoint.dy);
    path.arcTo(
        Rect.fromLTWH(
            rect.right - (rightTopRadiusX ?? 0) * 2,
            rect.top,
            (rightTopRadiusX ?? 0) * 2,
            (rightTopRadiusY ?? 0) * 2),
        270 * 0.0174533, 90 * 0.0174533,
        false);
    path.lineTo(rightEndPoint.dx, rightEndPoint.dy);
    path.arcTo(
        Rect.fromLTWH(
            rect.right - (rightBottomRadiusX ?? 0) * 2,
            rect.bottom - (rightBottomRadiusY ?? 0) * 2,
            (rightBottomRadiusX ?? 0) * 2,
            (rightBottomRadiusY ?? 0) * 2),
        0, 90 * 0.0174533,
        false);
    path.lineTo(bottomEndPoint.dx, bottomEndPoint.dy);
    path.arcTo(
        Rect.fromLTWH(
            rect.left,
            rect.bottom - (leftBottomRadiusY ?? 0) * 2,
            (leftBottomRadiusX ?? 0) * 2,
            (leftBottomRadiusY ?? 0) * 2),
        90 * 0.0174533, 90 * 0.0174533,
        false);
    path.lineTo(leftEndPoint.dx, leftEndPoint.dy);
    path.arcTo(
        Rect.fromLTWH(
            rect.left,
            rect.top,
            (leftTopRadiusX ?? 0) * 2,
            (leftTopRadiusY ?? 0) * 2),
        180 * 0.0174533, 90 * 0.0174533,
        false);
    canvas.drawPath(path, paint);

  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}