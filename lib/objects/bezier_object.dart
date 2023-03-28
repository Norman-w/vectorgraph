import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/model/geometry/rect/RectEX.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../model/geometry/lines/bezier.dart';
import '../model/geometry/lines/line_segment.dart';
import 'space_object.dart';

class BezierObject extends Bezier with SpaceObject,ALineObject{
  BezierObject(super.position, super.end);

  // RectObject.fromCenter({required super.center, required super.width, required super.height}) : super.fromCenter();
  @override
  BezierObject copyWith(){
    return BezierObject(position, end);
  }

  bool isPointOnLine(PointEX point, {Decimal? deviation}){
    //check each line
    return toLineSegments()
        .any(
            (element) =>
                element.isPointOnLine(
                  //由于贝塞尔曲线使用的是0点+世界坐标偏移的方式,所以在检测时也要使用这种方式,(减去偏移)
                    point - position, deviation: deviation)
    );
  }

  @override
  toString() => 'BezierObject{start: $position, end: $end}';

  @override
  RectEX get selfBounds => bounds.shift(-position.x, -position.y);

  @override
  RectEX get worldBounds => bounds;

  @override
  bool isPointOn(PointEX pointEX, Decimal deviation) {
    return isPointOnLine(pointEX, deviation: deviation);
  }
}