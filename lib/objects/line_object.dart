import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../model/geometry/lines/line_segment.dart';
import 'space_object.dart';
import '../model/geometry/rect/RectEX.dart';

class LineObject extends LineSegment with SpaceObject,ALineObject{
  ///线段所在的世界坐标位置
  final PointEX _position;
  var _selfBounds = RectEX.zero;
  ///构造函数,给定线段所在的世界坐标位置,并且给定线段连接到的终端是哪里
  LineObject(this._position, PointEX end) : super(PointEX.zero, PointEX.zero){
    super.start = _position;
    super.end = end;
    _selfBounds = RectEX.fromPoints(_position, end).shift(_position.x, _position.y);
  }
  @override
  LineObject copyWith(){
    return LineObject(start,end);
  }

  @override
  toString() => 'LineObject{position: $start, end: $end}';

  @override
  PointEX get position => _position;

  @override
  //线直接使用的是世界坐标所以错误
  RectEX get selfBounds => _selfBounds;

  @override
  RectEX get worldBounds => getBoundingBox();

  @override
  bool isPointOn(PointEX pointEX,Decimal deviation) {
    return isPointOnLine(pointEX, deviation:deviation);
  }
}
