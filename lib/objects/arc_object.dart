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
    return value>Decimal.zero?value: decimalPi+decimalPi+value;
  }

  bool isPointOnLine(PointEX point, {Decimal? deviation}){
    // point = PointEX(Decimal.fromInt(0),Decimal.fromInt(100));
    var realDeviation = deviation ?? Decimal.one;
    //得到鼠标所在的世界坐标位置
    //计算世界坐标位置相对于中心点的偏移量,做出向量


    //在此之前先把他当做是没有任何旋转的来计算.


    //圆弧起始点到椭圆中心点的夹角
    var centerToStartPointVector = startPoint - position;

    //圆弧结束点到椭圆中心点的夹角
    var centerToEndPointVector = endPoint - position;

    //椭圆中心点到圆弧起始点的向量
    var startAngle =
    _to2PiValue(
        centerToStartPointVector.toVector2D().getAngle()
    );
    //椭圆中心点到圆弧结束点的向量
    var endAngle =
    _to2PiValue(
        centerToEndPointVector.toVector2D().getAngle()
    )
    ;

    //椭圆中心点到鼠标所在位置的向量和角度
    var centerToMouseVector = point - position;
    //旋转一个圆弧旋转的角度
    var centerToMouseAngle =
    _to2PiValue(
        centerToMouseVector.toVector2D().getAngle()
    );

    // print("椭圆圆弧起始:$startAngle  椭圆圆弧结束: $endAngle 椭圆中心点到鼠标角度:$centerToMouseAngle");

    //如果没有在起点和终点所在的夹角范围中间,就肯定没有在线上
    // if(centerToMouseAngle < startAngle || centerToMouseAngle > endAngle){
    //   return false;
    // }
    var isInRange  = false;
    {
      if(startAngle>endAngle)
        {
          isInRange =  (centerToMouseAngle > startAngle || centerToMouseAngle < endAngle);
        }
      else {
        isInRange =  (centerToMouseAngle > startAngle && centerToMouseAngle < endAngle);
      }
    }
    if(!isInRange)
      {
        return false;
      }

    //计算圆弧上的点的时候,使用没有旋转的圆弧进行边缘点计算. 也就是想象有一个正常放置的没旋转的椭圆参与计算

    //圆弧整体正转45度,"判断用的角"就应该是  鼠标所在角度-圆弧整体正转角度(45)
    var fakeNonRotatingCenterToMouseAngle = (centerToMouseAngle - rotationRadians).mod(decimalPi2);

    // print("判断用角的角度:$fakeNonRotatingCenterToMouseAngle");

    //计算该判断用角度在椭圆上的点
    var fakeNonRotatingPointOnEdgeByAngle = getOnEdgePointByAngle(radiansToDegrees(fakeNonRotatingCenterToMouseAngle));
    //将使用判断用角获得到的判断用边上的点,旋转至椭圆整体旋转后的这个判断用点的所在位置.
    //获取转换到的本地坐标点到 椭圆上该角度点的距离
    var realPointOnEdgByRealAngle = fakeNonRotatingPointOnEdgeByAngle.rotate(rotationRadians);
    var distance = realPointOnEdgByRealAngle.toVector2D().distance(centerToMouseVector.toVector2D());
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

  //弧线所在的椭圆的360度上的每一个点 世界坐标的
  List<PointEX> get pointsOnEdge{
    var points = <PointEX>[];
    for(var i = 0;i<360;i++) {
      var fromZeroPoint = getOnEdgePointByAngle(Decimal.fromInt(i));
      //旋转后的点
      var rotatedPoint = fromZeroPoint.rotate(rotationRadians);
      var movedPoint = rotatedPoint + position;
      points.add(movedPoint);
    }
    return points;
  }

  //弧线所在的椭圆的360度上的每一个点 世界坐标的
  List<PointEX> get pointsOnEdgeNoRotation{
    var points = <PointEX>[];
    for(var i = 0;i<360;i++) {
      var fromZeroPoint = getOnEdgePointByAngle(Decimal.fromInt(i));
      //旋转后的点
      var rotatedPoint = fromZeroPoint;//.rotate(rotationRadians);
      var movedPoint = rotatedPoint + position;
      points.add(movedPoint);
    }
    return points;
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