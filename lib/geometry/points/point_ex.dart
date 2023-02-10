import 'dart:math';
import 'dart:ui';

class PointEX {
  PointEX(this.x,this.y);
  late double x;
  late double y;
  bool equals(other){
    return other.x == x && other.y == y;
  }
  @override
  String toString() {
    // return "点(x:$x , y:$y)";
    //to fix string with 2 decimal places
    return "点(x:${x.toStringAsFixed(2)} , y:${y.toStringAsFixed(2)})";
  }

  PointEX operator +(PointEX other){
    return PointEX(x + other.x, y + other.y);
  }
  PointEX operator -(PointEX other){
    return PointEX(x - other.x, y - other.y);
  }
  PointEX operator *(double value){
    return PointEX(x * value, y * value);
  }
  PointEX operator /(double value){
    return PointEX(x / value, y / value);
  }
  double CrossProduct(PointEX other){
    return x * other.y - y * other.x;
  }
  double distanceTo(PointEX other){
    return sqrt(pow(x - other.x, 2) + pow(y - other.y, 2));
  }

  toOffset(){
    return Offset(x, y);
  }
}
// 计算叉乘 |P0P1| × |P0P2|
double pointMultiply(PointEX p1, PointEX p2, PointEX p0)
{
  return ( (p1.x - p0.x) * (p2.y - p0.y) - (p2.x - p0.x) * (p1.y - p0.y) );
}