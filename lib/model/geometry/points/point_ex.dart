import 'dart:math';
import 'dart:ui';

import 'package:decimal/decimal.dart';
import 'package:vectorgraph/utils/num_utils.dart';

class PointEX {
  PointEX(this.x,this.y);
  late Decimal x;
  late Decimal y;
  bool equals(other){
    return other.x == x && other.y == y;
  }

  PointEX operator -() {
    return PointEX(-x, -y);
  }

  static final zero = PointEX(Decimal.zero, Decimal.zero);

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
  PointEX operator *(Decimal value){
    return PointEX(x * value, y * value);
  }
  PointEX operator /(Decimal value){
    var rx = x/value;
    var px = Decimal.parse(rx.toDecimal(scaleOnInfinitePrecision:60).toString());

    var ry = y/value;
    var py = Decimal.parse(ry.toDecimal(scaleOnInfinitePrecision:60).toString());

    return PointEX(px,py);
  }
  Decimal CrossProduct(PointEX other){
    return x * other.y - y * other.x;
  }
  Decimal distanceTo(PointEX other){
    return decimalSqrt(decimalPow(x - other.x, 2) + decimalPow(y - other.y, 2));
  }

  toOffset(){
    return Offset(x.toDouble(), y.toDouble());
  }
  static PointEX fromOffset(Offset value){
    return PointEX(value.dx.toDecimal(), value.dy.toDecimal());
  }
}
// 计算叉乘 |P0P1| × |P0P2|
Decimal pointMultiply(PointEX p1, PointEX p2, PointEX p0)
{
  return ( (p1.x - p0.x) * (p2.y - p0.y) - (p2.x - p0.x) * (p1.y - p0.y) );
}

extension OffsetExternFunctions on Offset{
  PointEX toPointEX(){
    return PointEX(dx.toDecimal(), dy.toDecimal());
  }
}