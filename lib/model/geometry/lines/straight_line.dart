import '../points/point_ex.dart';
import '../vectors/vector2d.dart';

class StraightLine{
  PointEX point1;
  PointEX point2;
  StraightLine(this.point1, this.point2);
  Vector2D getVector()
  {
    return Vector2D(point2.x - point1.x, point2.y - point1.y);
  }
  double getAngle(){
    return getVector().getAngle();
  }
  void normalize(){
    var vector = getVector();
    vector.setLength(1);
    point2 = PointEX(point1.x + vector.x, point1.y + vector.y);
  }
}