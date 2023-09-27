import 'package:vectorgraph/model/geometry/lines/cross_info.dart';
import 'package:vectorgraph/model/geometry/lines/straight_line.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/model/geometry/rect/RectEX.dart';
import 'package:vectorgraph/utils/num_utils.dart';

void main() {
  //给定一个矩形和矩形内部的两个点,计算两点组成的直线与矩形的交点
  var rect = RectEX(Decimal.fromDouble(0), Decimal.fromDouble(0),
      Decimal.fromDouble(100), Decimal.fromDouble(100));
  var p1 = PointEX(Decimal.fromDouble(50), Decimal.fromDouble(20));
  var p2 = PointEX(Decimal.fromDouble(20), Decimal.fromDouble(50));
  var crossPoint = getTwoPointCrossRectEdge(p1, p2, rect);
  print("crossPoint = $crossPoint");

  var info = StraightLine.getCrossPoint(
    PointEX(Decimal.fromDouble(50), Decimal.fromDouble(20)),
    PointEX(Decimal.fromDouble(20), Decimal.fromDouble(50)),
    PointEX(Decimal.fromDouble(100), Decimal.fromDouble(0)),
    PointEX(Decimal.fromDouble(100), Decimal.fromDouble(100)),
  );
  print('info = $info');
}
