import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/model/geometry/rect/RectEX.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../model/geometry/lines/arc.dart';
import 'space_object.dart';

class ArcObject extends Arc with SpaceObject,ALineObject{
  ArcObject(
  super._position,
  super._rx,
  super._ry,
  super._xr,
  super._laf,
  super._sf,
  super._endPoint,
      ) ;
  @override
  ArcObject copyWith(){
    return ArcObject(
      position, rx, ry, xr, laf, sf, endPoint,
    );
  }

  bool isPointOnLine(PointEX point, {Decimal? deviation}){
    return false;
  }

  @override
  toString() => 'ArcObject: $position, $rx, $ry, $xr, $laf, $sf, $endPoint';

  @override
  RectEX get selfBounds => bounds.shift(-position.x, -position.y);

  @override
  RectEX get worldBounds => bounds;

  @override
  bool isPointOn(PointEX pointEX, Decimal deviation) {
    return isPointOnLine(pointEX, deviation: deviation);
  }
}