import 'dart:math';

import '../points/point_ex.dart';
import 'polygon.dart';


/// 使用边创建正多少边的形状
class EquilateralPolygon extends Polygon {
  final double size; // 组件大小
  final int count; // 几边形
  EquilateralPolygon(
      {
        this.size = 80,
        this.count = 3,}) : super([]){
    //region 函数定义
    start(double x, double y)
    {
      points.add(PointEX(x,y));
    }
    lineTo(double x, double y)
    {
      points.add(PointEX(x,y));
    }
    //endregion

    double r = size / 2;
    // 将圆等分,开始第一个点
    start(r * cos(pi / count)+r, r * sin(pi / count)+r);

    //创建边
    // start(r * cos(pi / count), r * sin(pi / count));
    for (int i = 2; i <= count * 2; i++) {
      if (i.isOdd) {
        lineTo(r * cos(pi / count * i)+r, r * sin(pi / count * i)+r);
      }
    }
  }
}