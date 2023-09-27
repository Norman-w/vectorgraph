import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/objects/bounded_rect_object.dart';
import 'package:vectorgraph/utils/num_utils.dart';

void main() {
  //定义一个矩形
  BoundedRectObject rectObject =
  BoundedRectObject.fromLTWHRadius(
      //左上角的位置
      Decimal.fromInt(300), Decimal.fromInt(150),
      //宽度,高度
      Decimal.fromInt(100), Decimal.fromInt(50),
      //圆角的半径
      Decimal.fromInt(10)
  );
  //定义一个点
  //在左上角弧线上的
  var aPoint = PointEX(Decimal.fromDouble(302.9), Decimal.fromDouble(152.9));
  //左上角弧线外部的
  // var aPoint = PointEX(Decimal.fromInt(301), Decimal.fromInt(151));
  //左上角扇形内部的
  // var aPoint = PointEX(Decimal.fromInt(305), Decimal.fromInt(155));
  //矩形内部的
  // var aPoint = PointEX(Decimal.fromInt(330), Decimal.fromInt(180));
  //判断一下点是否在这个矩形内
  var isInInner = rectObject.isWorldPointIn(aPoint);
  //判断一下点是否在这个圆角矩形的边线上
  var isOnEdge = rectObject.isWorldPointOnEdgeLines(aPoint, Decimal.one);

  //输出结果
  print('是否在圆角矩形内:$isInInner');
  print('是否在圆角矩形的边线上:$isOnEdge');
}