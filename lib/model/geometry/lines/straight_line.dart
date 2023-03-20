import '../../../utils/num_utils.dart';
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
    vector.setLength(Decimal.one);
    point2 = PointEX(point1.x + vector.x, point1.y + vector.y);
  }
}

//这两个方法也是只能判断出来是否在直线上.但是直线又不具备start和end的概念,所以这两个方法也不适用
// extension StraightLineFunctions on StraightLine{
//   // 使用向量运算判断点是否在直线上
//   bool isPointOnStraightLineByVector(PointEX point, Decimal deviation) {
//     Vector2D vector1 = getVector();
//     var point2 = point - start;
//     Vector2D vector2 = point2.toVector2D();
//     Decimal cross = vector1.cross(vector2);
//     Decimal cd = cross.abs() / vector1.length;
//     return cd < (deviation ?? Decimal.ten);
//   }
//
//   // 使用代数方法判断点是否在直线上
//   bool isPointOnStraightLineByAlgebra(PointEX point, Decimal deviation) {
//     Decimal a = end.y - start.y;
//     Decimal b = start.x - end.x;
//     Decimal c = end.x * start.y - start.x * end.y;
//     Decimal cd = (a * point.x + b * point.y + c).abs() / decimalSqrt(a * a + b * b);
//     return cd < deviation;
//   }
// }