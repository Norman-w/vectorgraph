import '../model/geometry/rect/RectEX.dart';
import '../model/geometry/points/point_ex.dart';
import '../utils/num_utils.dart';
import 'space_object.dart';

class PointObject extends PointEX with SpaceObject,APointObject{
  late Decimal radius;
  PointObject(super.x, super.y, {Decimal? radius}){
    this.radius = radius ?? Decimal.fromInt(1);
  }
  @override
  PointObject copyWith(){
    return PointObject(x, y, radius:radius);
  }

  @override
  PointEX get position => PointEX(x, y);

  @override
  RectEX get selfBounds => RectEX.fromCircle(center: PointEX.zero, radius: radius);

  @override
  RectEX get worldBounds => RectEX.fromCircle(center: PointEX(x, y), radius: radius);

  @override
  bool isPointOn(PointEX pointEX, Decimal deviation) {
    var distance = distanceTo(pointEX);
    var newIsInteractive = distance < radius/Decimal.two + deviation;
    return newIsInteractive;
  }
}
