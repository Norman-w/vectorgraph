import '../../../utils/num_utils.dart';
import '../points/point_ex.dart';
import '../rect/RectEX.dart';
import 'ray.dart';
import 'straight_line.dart';
import '../vectors/vector2d.dart';


var ESP = 1e-5;


class LineSegment{
  PointEX start;
  PointEX end;
  LineSegment(this.start, this.end);
  Vector2D getVector(){
    return Vector2D(end.x - start.x, end.y - start.y);
  }
  static LineSegment zero = LineSegment(PointEX.zero, PointEX.zero);
  Decimal getAngle(){
    return getVector().getAngle();
  }
  RectEX getBoundingBox(){
    return RectEX.fromLTRB(decimalMin(start.x, end.x), decimalMin(start.y, end.y), decimalMax(start.x, end.x), decimalMax(start.y, end.y));
  }
  bool isInBoundingBox(PointEX point,{Decimal? deviation}){
    var RectEX = getBoundingBox();
    RectEX = RectEX.inflate(deviation?? Decimal.two);
    return RectEX.contains(point);
  }
  Decimal getStartPointToDistance(PointEX point){
    var vector1 = getVector();
    var vector2 = point - start;
    var cross = vector1.x * vector2.y - vector1.y * vector2.x;
    return cross.abs() / vector1.distance(Vector2D(Decimal.zero, Decimal.zero));
  }
  Decimal getEndPointToDistance(PointEX point){
    var vector1 = getVector();
    var vector2 = point - end;
    var cross = vector1.x * vector2.y - vector1.y * vector2.x;
    return cross.abs() / vector1.distance(Vector2D(Decimal.zero, Decimal.zero));
  }

  get length{
    return getVector().distance(Vector2D(Decimal.zero, Decimal.zero));
  }
  bool isCrossToStraightLine(StraightLine straightLine){
    var vector1 = straightLine.getVector();
    var vector2 = getVector();
    var vector3 = start - straightLine.point1;
    var cross1 = vector1.x * vector2.y - vector1.y * vector2.x;
    var cross2 = vector1.x * vector3.y - vector1.y * vector3.x;
    if(cross1 == Decimal.zero){
      return false;
    }
    var r = cross2 / cross1;
    if(r < Decimal.zero || r > Decimal.one){
      return false;
    }
    return true;
  }
  bool isCrossToRaysLine(Ray raysLine){
    var vector1 = raysLine.getVector();
    var vector2 = getVector();
    var vector3 = start - raysLine.start;
    var cross1 = vector1.x * vector2.y - vector1.y * vector2.x;
    var cross2 = vector1.x * vector3.y - vector1.y * vector3.x;
    if(cross1 == Decimal.zero){
      return false;
    }
    var r = cross2 / cross1;
    if(r < Decimal.zero){
      return false;
    }
    return true;
  }
  bool isCrossToLineSegment(LineSegment lineSegment){
    var vector1 = lineSegment.getVector();
    var vector2 = getVector();
    var vector3 = start - lineSegment.start;
    var cross1 = vector1.x * vector2.y - vector1.y * vector2.x;
    var cross2 = vector1.x * vector3.y - vector1.y * vector3.x;
    if(cross1 == Decimal.zero){
      return false;
    }
    var r = cross2 / cross1;
    if(r < Decimal.zero || r > Decimal.one){
      return false;
    }
    vector1 = getVector();
    vector2 = lineSegment.getVector();
    vector3 = lineSegment.start - start;
    cross1 = vector1.x * vector2.y - vector1.y * vector2.x;
    cross2 = vector1.x * vector3.y - vector1.y * vector3.x;
    if(cross1 == Decimal.zero){
      return false;
    }
    r = cross2 / cross1;
    if(r < Decimal.zero || r > Decimal.one){
      return false;
    }
    return true;
  }
  @override
  String toString() {
    //to fixed Decimal with 2 decimal places
    return 'LineSegment{start: $start, end: $end}';
  }
}


extension LineSegmentMethods on LineSegment{
  /// 判断点是否在线段上
  bool isPointOnLine(PointEX point, {Decimal? deviation})
  {
    Vector2D vector1 = getVector();
    PointEX vector2 = point - start;
    Decimal cross = vector1.x * vector2.y - vector1.y * vector2.x;
    // print('叉乘：$cross');
    var cd = cross.abs() / vector1.distance(Vector2D.zero);
    var de = deviation ?? Decimal.one;
    var isOnStraightLine = cd  < de;
    //region 检测到点在直线上以后还应该检测点是否在线段上
    if(isOnStraightLine){
      var dot = vector1.x * vector2.x + vector1.y * vector2.y;
      if(dot < Decimal.zero){
        return false;
      }
      var squaredLength = vector1.x * vector1.x + vector1.y * vector1.y;
      if(dot > squaredLength){
        return false;
      }
      return true;
    }
    //endregion
    return false;
  }
  // // 判断线段相交 老方法 管用不管用忘记了.
  // bool intersect(LineSegment L1, LineSegment L2)
  // {
  //   return( (decimalMax(L1.start.x, L1.end.x) >= decimalMin(L2.start.x, L2.end.x)) &&
  //       (decimalMax(L2.start.x, L2.end.x) >= decimalMin(L1.start.x, L1.end.x)) &&
  //       (decimalMax(L1.start.y, L1.end.y) >= decimalMin(L2.start.y, L2.end.y)) &&
  //       (decimalMax(L2.start.y, L2.end.y) >= decimalMin(L1.start.y, L1.end.y)) &&
  //       (pointMultiply(L2.start, L1.end, L1.start) * pointMultiply(L1.end, L2.end, L1.start) >= Decimal.zero) &&
  //       (pointMultiply(L1.start, L2.end, L2.start) * pointMultiply(L2.end, L1.end, L2.start) >= Decimal.zero)
  //   );
  // }
}
