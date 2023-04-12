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

  //转换从x轴0起点顺时针旋转到x轴零起点(360度的值)转换成0~2π. 正常的值是从0到pi然后到-pi再到-0.为了计算区间,使用此函数
  Decimal _to2PiValue(Decimal value){
    // if(value>Decimal.zero){
    //   return value;
    // }
    // return decimalPi + (decimalPi - value.abs());
    //简单写法
    return value>Decimal.zero?value: (decimalPi+decimalPi+value);
  }

  bool isPointOnLine(PointEX point, {Decimal? deviation}){
    // point = PointEX(Decimal.fromInt(0),Decimal.fromInt(100));
    var realDeviation = deviation ?? Decimal.one;
    //得到鼠标所在的世界坐标位置
    //计算世界坐标位置相对于中心点的偏移量,做出向量


    //在此之前先把他当做是没有任何旋转的来计算.
    //起始点到圆心的夹角
    var centerToStartPointVector = startPoint - position;
    var centerToEndPointVector = endPoint - position;

    var startAngle =
    _to2PiValue(
        centerToStartPointVector.toVector2D().getAngle()
    )
    ;
    var endAngle =
    _to2PiValue(
        centerToEndPointVector.toVector2D().getAngle()
    )
    ;

    //中心点到鼠标所在位置的向量和角度
    var centerToMouseVector = point - position;
    //旋转一个圆弧旋转的角度
    var centerToMouseAngle =
    _to2PiValue(
        centerToMouseVector.toVector2D().getAngle()
    )
    ;

    print(" angle : start:$startAngle  end: $endAngle 0点到鼠标:$centerToMouseAngle");

    //如果没有在起点和终点所在的夹角范围中间,就肯定没有在线上
    if(centerToMouseAngle < startAngle || centerToMouseAngle > endAngle){
      return false;
    }
    return true;
    //计算该角度在椭圆上的点
    var pointOnEdgeByAngle = getOnEdgePointByAngle(radiansToDegrees(centerToMouseAngle));
    //获取转换到的本地坐标点到 椭圆上该角度点的距离
    var distance = pointOnEdgeByAngle.toVector2D().distance(centerToMouseVector.toVector2D());
    //如果距离小于误差值,就认为在线上
    if(distance < realDeviation){
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