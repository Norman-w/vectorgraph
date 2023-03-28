import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../model/geometry/lines/line_segment.dart';
import 'space_object.dart';
import '../model/geometry/rect/RectEX.dart';

class RectObject extends RectEX with SpaceObject,APlaneObject{
  ///矩形的所在位置.使用矩形的中心点坐标
  PointEX? _position;
  set position(PointEX newPosition){
    _position = newPosition;
  }
  RectObject.fromCenter({required super.center, required super.width, required super.height}) : super.fromCenter(){
    _position = center;
  }
  RectObject.fromLTWH(Decimal left, Decimal top, Decimal width, Decimal height) : super.fromLTWH(left, top, width, height){
    _position = PointEX(left + width/Decimal.two, top + height/Decimal.two);
  }
  RectObject.fromPoints(PointEX a, PointEX b) : super.fromPoints(a, b)
  {
    _position = PointEX((a.x + b.x)/Decimal.two, (a.y + b.y)/Decimal.two);
  }
  RectObject.fromLTRB(Decimal left, Decimal top, Decimal right, Decimal bottom) : super.fromLTRB(left, top, right, bottom)
  {
    _position = PointEX((left + right)/Decimal.two, (top + bottom)/Decimal.two);
  }

  List<LineSegment> _lines = [];
  List<LineSegment> get lines {
    if(_lines.isEmpty && !isEmpty){
      //init lines
      var p1 = PointEX(left, top);
      var p2 = PointEX(right, top);
      var p3 = PointEX(right, bottom);
      var p4 = PointEX(left, bottom);
      _lines = [
        LineSegment(p1,p2),
        LineSegment(p2,p3),
        LineSegment(p3,p4),
        LineSegment(p4,p1),
      ];
    }
    return _lines;
  }
  ///检测点是否在矩形的边缘上.
  @override
  bool isWorldPointOnEdgeLines(PointEX point, Decimal deviation){
    var list = lines;
    for(var l in list){
      if(l.isPointOnLine(point - position,deviation: deviation)) {
        return true;
      }
    }
    return false;
  }
  @override
  RectObject copyWith(){
    return RectObject.fromLTWH(left, top, width, height);
  }

  @override
  toString() => 'RectObject{left: $left, top: $top, width: $width, height: $height}';

  @override
  PointEX get position => _position ?? PointEX.zero;

  @override
  RectEX get selfBounds => this;

  @override
  RectEX get worldBounds => shift(position.x, position.y);

  @override
  bool isWorldPointIn(PointEX pointEX) {
    return worldBounds.contains(pointEX);
  }
}
