import '../../../utils/num_utils.dart';
import '../points/point_ex.dart';
import '../vectors/vector2d.dart';
import 'line_segment.dart';
import 'straight_line.dart';

class Ray{
  PointEX start;
  PointEX anyPointOnLine;
  Ray(this.start, this.anyPointOnLine);
  Vector2D getVector(){
    return Vector2D(anyPointOnLine.x - start.x, anyPointOnLine.y - start.y);
  }
  double getAngle(){
    return getVector().getAngle();
  }
  void normalize(){
    var vector = getVector();
    vector.setLength(Decimal.one);
    anyPointOnLine = PointEX(start.x + vector.x, start.y + vector.y);
  }
  @override
  toString(){
    return "RaysLine(start: $start, anyPointOnLine: $anyPointOnLine)";
  }

  isCrossToStraightLine(StraightLine straightLine){
    var vector1 = straightLine.getVector();
    var vector2 = getVector();
    var vector3 = start - straightLine.point1;
    var cross1 = vector1.x * vector2.y - vector1.y * vector2.x;
    var cross2 = vector1.x * vector3.y - vector1.y * vector3.x;
    if(cross1 == 0){
      return false;
    }
    var r = cross2 / cross1;
    if(r < Decimal.zero){
      return false;
    }
    return true;
  }
  isCrossToRaysLine(Ray raysLine){
    var vector1 = raysLine.getVector();
    var vector2 = getVector();
    var vector3 = start - raysLine.start;
    var cross1 = vector1.x * vector2.y - vector1.y * vector2.x;
    var cross2 = vector1.x * vector3.y - vector1.y * vector3.x;
    if(cross1 == 0){
      return false;
    }
    var r = cross2 / cross1;
    if(r < Decimal.zero){
      return false;
    }
    return true;
  }
  isCrossToLineSegment(LineSegment lineSegment){
    var vector1 = lineSegment.getVector();
    var vector2 = getVector();
    var vector3 = start - lineSegment.start;
    var cross1 = vector1.x * vector2.y - vector1.y * vector2.x;
    var cross2 = vector1.x * vector3.y - vector1.y * vector3.x;
    if(cross1 == 0){
      return false;
    }
    var r = cross2 / cross1;
    if(r < Decimal.zero || r > Decimal.one){
      return false;
    }
    return true;
  }
}
