import 'package:vectorgraph/model/geometry/lines/line_segment.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/model/geometry/rect/RectEX.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../model/geometry/planes/polygon.dart';
import 'space_object.dart';

class PolygonObject extends Polygon with SpaceObject,APlaneObject{
  final PointEX _position;
  PolygonObject(this._position, List<PointEX> points){
    super.points = points;
  }

  // RectObject.fromCenter({required super.center, required super.width, required super.height}) : super.fromCenter();
  @override
  PolygonObject copyWith(){
      return PolygonObject(_position, points);
  }

  @override
  bool isWorldPointOnEdgeLines(PointEX pointEX, Decimal? deviation){
    //check each line
    return getLineSegments()
        .any(
            (element) =>
            element.isPointOnLine(
              //由于贝塞尔曲线使用的是0点+世界坐标偏移的方式,所以在检测时也要使用这种方式,(减去偏移)
                pointEX - _position
                , deviation: deviation)
    );
  }
  @override
  PointEX get position => _position;

  @override
  RectEX get selfBounds => bounds;

  @override
  RectEX get worldBounds => bounds.shift(_position.x, _position.y);

  @override
  bool isWorldPointIn(PointEX pointEX) {
    return !worldBounds.contains(pointEX)?false:isPointIn(pointEX - position);
  }
}
