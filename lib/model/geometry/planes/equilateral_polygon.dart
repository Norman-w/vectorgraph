import 'package:vectorgraph/model/geometry/vectors/vector2d.dart';
import 'package:vectorgraph/utils/num_utils.dart';

import '../points/point_ex.dart';
import 'polygon.dart';


/// 使用边创建正多少边的形状
class EquilateralPolygon extends Polygon {
  late Decimal size; // 组件大小
  final int count; // 几边形
  EquilateralPolygon(
      {
        Decimal? size,
        this.count = 3,}){
    this.size = size ?? Decimal.fromInt(80);
    //region 函数定义
    start(Decimal x, Decimal y) {
      print("开始点: x:$x y:$y");
      points.add(PointEX(x, y));
    }
    lineTo(Decimal x, Decimal y) {
      print("链接点: x:$x y:$y");
      points.add(PointEX(x, y));
    }
    //endregion
    Decimal r = this.size / Decimal.two;
    var perDeg = decimalPi / Decimal.fromInt(count);
    var perSideDeg = 360.0/ count;
    // var deg120 = decimalPi / Decimal.fromInt(3);
    var deg1 = decimalPi / Decimal.fromInt(180);

    var rotationAngle = ((perSideDeg+perSideDeg).toDecimal() - Decimal.fromInt(90)) * deg1;
    //第一个点,为了看起来更好看.我们默认让第一个点在圆的正上方,但是比如说我们要画一个三角形,那么第一个点就不是在正上方了
    //所以我们要把角度再往前移动一个角度,比如3个顶点的,第一个顶点在旋转120度的地方
    var firstX = r * decimalCos(perDeg * Decimal.fromInt(1) - rotationAngle);
    var firstY = r * decimalSin(perDeg * Decimal.fromInt(1)- rotationAngle);
    start(firstX, firstY);
    //创建边
    for (int i = 2; i <= count * 2; i++) {
      if (i.isOdd) {
        var x = r * decimalCos(perDeg * Decimal.fromInt(i) - rotationAngle);
        var y = r * decimalSin(perDeg * Decimal.fromInt(i) - rotationAngle);
        lineTo(x,y);
      }
    }
    lineTo(firstX, firstY);
  }
}