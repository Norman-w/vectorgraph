import 'package:vectorgraph/utils/num_utils.dart';
import '../points/point_ex.dart';
import '../rect/RectEX.dart';
/// 椭圆
class Ellipse{
  Decimal _rx;
  Decimal _ry;
  ///半径 半径
  Decimal get radiusX => _rx;
  Decimal get radiusY => _ry;
  set radiusX(Decimal radiusX){
    bounds = RectEX.fromCenter(center: PointEX.zero, width: radiusX*Decimal.two, height: _ry*Decimal.two);
    _rx = radiusX;
  }
  set radiusY(Decimal radiusY){
    bounds = RectEX.fromCenter(center: PointEX.zero, width: _rx*Decimal.two, height: radiusY*Decimal.two);
    _ry = radiusY;
  }
  ///外围(自身坐标)
  RectEX bounds;
  Ellipse():bounds = RectEX.zero, _rx = Decimal.two, _ry = Decimal.one;

  ///获取椭圆上某个角度的点坐标
  PointEX getOnEdgePointByAngle(Decimal a){
    var rad = degreesToRadians(a);
    var eccAngle = eccentricAngle(_rx, _ry, rad);
    var x = _rx * decimalCos(eccAngle);
    var y = _ry * decimalSin(eccAngle);
    return PointEX(x,y);
  }

  var decimal180 = Decimal.fromInt(180);

  // 将角度转换为弧度
  Decimal degreesToRadians(Decimal deg) {
    return deg / decimal180 * decimalPi;
  }

  // 将弧度转换为角度
    Decimal radiansToDegrees(Decimal rad) {
      return rad / decimalPi * decimal180;
    }

  // 计算离心角
  Decimal eccentricAngle(Decimal a, Decimal b, Decimal rad) {
    return decimalAtan2(a*decimalSin(rad), b*decimalCos(rad));
  }
}

// 参考内容:
// #include <math.h>
// #include <iostream>
// #include <utility>
//
// inline float degrees_to_radians(float deg) {
//   return deg / 180.0 * M_PI;
// }
//
// inline float radians_to_degrees(float rad) {
//   return rad / M_PI * 180.0;
// }
// // 计算离心角
// inline float eccentric_angle(float a, float b, float rad) {
//   return atan2(a*sin(rad), b*cos(rad));
// }
//
// std::pair<float, float> getEllipseXY(float a, float b, float degree) {
//   auto rad = degrees_to_radians(degree);
//   auto ecc_angle = eccentric_angle(a, b, rad);
//   auto x = a * cos(ecc_angle);
//   auto y = b * sin(ecc_angle);
//   return {x, y};
// }
//
// int main() {
//   std::pair<float, float> xy;
//   for (int deg = 0; deg <= 480; deg += 90) {
//   xy = getEllipseXY(10, 5, deg);
//   std::cout << "degree = " << deg << ": x, y = "<< xy.first << " " << xy.second << std::endl;
//   }
//   return 0;
// }