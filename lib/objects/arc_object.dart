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
    return false;
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