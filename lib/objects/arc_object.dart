import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/model/geometry/rect/RectEX.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../model/geometry/lines/arc.dart';
import 'space_object.dart';

class ArcObject extends Arc with SpaceObject, ALineObject {
  ArcObject.fromSVG(
      ///圆弧的起点
      PointEX startPoint,
      ///椭圆的x轴半径
      Decimal rx,
      ///椭圆的y轴半径
      Decimal ry,
      ///椭圆的旋转角度
      Decimal rotationDegrees,
      ///是否是大圆弧 large-arc-flag
      laf,
      ///是否是顺时针方向 sweep-flag
      sf,
      ///圆弧的终点
      endPoint)
      : super.fromSVG(startPoint, rx, ry, rotationDegrees, laf, sf, endPoint);

  ArcObject.fromCanvas(
      ///圆弧所在椭圆的外切矩形
      RectEX rect,
      ///圆弧所在椭圆的旋转角度,以弧度为单位,比如旋转45度,就是pi/4
      Decimal rotationRadian,
      ///圆弧的起始角度
      Decimal startAngle,
      ///圆弧的角度
      Decimal sweepAngle
      )
      : super.fromCanvas(
            RectEX.fromLTWH(rect.left, rect.top,
                rect.width, rect.height),
            rotationRadian,
            startAngle,
            sweepAngle);

  @override
  ArcObject copyWith() {
    return ArcObject.fromSVG(
        startPoint, rx, ry, rotationDegrees, laf, sf, endPoint);
  }

  //弧线所在的椭圆的360度上的每一个点 世界坐标的
  List<PointEX> get pointsOnEdge {
    var points = <PointEX>[];
    for (var i = 0; i < 360; i++) {
      var fromZeroPoint = getOnEdgePointByAngle(Decimal.fromInt(i));
      //旋转后的点
      var rotatedPoint = fromZeroPoint.rotate(rotationRadians);
      var movedPoint = rotatedPoint + position;
      points.add(movedPoint);
    }
    return points;
  }

  //弧线所在的椭圆的360度上的每一个点 世界坐标的
  List<PointEX> get pointsOnEdgeNoRotation {
    var points = <PointEX>[];
    for (var i = 0; i < 360; i++) {
      var fromZeroPoint = getOnEdgePointByAngle(Decimal.fromInt(i));
      //旋转后的点
      var rotatedPoint = fromZeroPoint; //.rotate(rotationRadians);
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
