import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/model/geometry/rect/RectEX.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../model/geometry/planes/circle.dart';
import 'space_object.dart';

class CircleObject extends Circle with SpaceObject,APlaneObject{
  final PointEX _position;
  CircleObject(this._position, Decimal radius) {
    super.radius = radius;
  }
  @override
  CircleObject copyWith(){
    return CircleObject(_position, radius);
  }

  @override
  bool isWorldPointOnEdgeLines(PointEX pointEX, Decimal deviation){
    var distance = _position.distanceTo(pointEX);
    var newIsInteractive = (distance - radius).abs() < deviation;
    return newIsInteractive;
  }
  @override
  PointEX get position => _position;

  @override
  RectEX get selfBounds => bounds;

  @override
  RectEX get worldBounds => bounds.shift(_position.x, _position.y);

  @override
  bool isWorldPointIn(PointEX pointEX) {
    return !worldBounds.contains(pointEX)?false:isPointIn(pointEX, Decimal.one);
  }

  bool isPointIn(PointEX pointEX, Decimal deviation){
    var distance = _position.distanceTo(pointEX);
    var newIsInteractive = distance < radius;
    return newIsInteractive;
  }
}
