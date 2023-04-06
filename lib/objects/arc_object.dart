import 'dart:ui';

import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/model/geometry/rect/RectEX.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../model/geometry/lines/arc.dart';
import 'space_object.dart';

class ArcObject extends Arc with SpaceObject,ALineObject{
  ArcObject.fromSVG(PointEX startPoint, Decimal rx,Decimal ry,Decimal rotationDegrees, laf,sf,endPoint):super.fromSVG(startPoint, rx, ry, rotationDegrees, laf, sf, endPoint);
  ArcObject.fromCanvas(Rect rect,Decimal rotationRadian, Decimal startAngle, Decimal sweepAngle):super.fromCanvas(RectEX.fromLTWH(
      rect.left.toDecimal(), rect.top.toDecimal(), rect.width.toDecimal(), rect.height.toDecimal()),rotationRadian,startAngle, sweepAngle);
  @override
  ArcObject copyWith(){
    return ArcObject.fromSVG(startPoint, rx, ry, rotationDegrees, laf, sf, endPoint);
  }

  bool isPointOnLine(PointEX point, {Decimal? deviation}){
    var realDeviation = deviation ?? Decimal.one;
    //得到鼠标所在的世界坐标位置
    //计算世界坐标位置相对于中心点的偏移量,做出向量

    //在此之前先把他当做是没有任何旋转的来计算.
    //起始点到圆心的夹角
    var centerToStartPointVector = startPoint - position;
    var centerToEndPointVector = endPoint - position;

    var startAngle = radiansToDegrees(centerToStartPointVector.toVector2D().getAngle());
    var endAngle = radiansToDegrees(centerToEndPointVector.toVector2D().getAngle());


    //中心点到鼠标所在位置的向量和角度
    var centerToMouseVector = point - position;
    var centerToMouseAngle = radiansToDegrees(centerToMouseVector.toVector2D().getAngle());

    //如果没有在起点和终点所在的夹角范围中间,就肯定没有在线上
    if(centerToMouseAngle < startAngle || centerToMouseAngle > endAngle){
      return false;
    }
    // print('在呢在呢');
    return true;
    //计算该角度在椭圆上的点
    var pointOnEdgeByAngle = getOnEdgePointByAngle(centerToMouseAngle);
    //获取转换到的本地坐标点到 椭圆上该角度点的距离
    var distance = pointOnEdgeByAngle.toVector2D().distance(centerToMouseVector.toVector2D());
    //如果距离小于误差值,就认为在线上
    if(distance < realDeviation!){
      return true;
    }
    return false;
  }
  ///获取椭圆上某个角度的点坐标
  PointEX getOnEdgePointByAngle(Decimal a){
    var rad = degreesToRadians(a);
    var eccAngle = eccentricAngle(rx, ry, rad);
    var x = rx * decimalCos(eccAngle);
    var y = ry * decimalSin(eccAngle);
    return PointEX(x,y);
  }

  // @override
  // toString() =>
  //     super.toString();
  @override
  RectEX get selfBounds => bounds.shift(-position.x, -position.y);

  @override
  RectEX get worldBounds => bounds;

  @override
  bool isPointOn(PointEX pointEX, Decimal deviation) {
    return isPointOnLine(pointEX, deviation: deviation);
  }
}