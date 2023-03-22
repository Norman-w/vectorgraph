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
        this.count = 3,}) : super([]){
    this.size = size?? Decimal.fromInt(80);
    //region 函数定义
    start(Decimal x, Decimal y)
    {
      print("开始点: x:$x y:$y");
      points.add(PointEX(x,y));
    }
    lineTo(Decimal x, Decimal y)
    {
      print("链接点: x:$x y:$y");
      points.add(PointEX(x,y));
    }
    //endregion


    // // 将圆等分,开始第一个点
    // start(r * cos(pi / count)+r, r * sin(pi / count)+r);
    //
    // //创建边
    // // start(r * cos(pi / count), r * sin(pi / count));
    // for (int i = 2; i <= count * 2; i++) {
    //   if (i.isOdd) {
    //     lineTo(r * cos(pi / count * i)+r, r * sin(pi / count * i)+r);
    //   }
    // }

    //半径
    Decimal r = this.size / Decimal.two;
    print('半径:$r');
    Decimal perSidePi = decimalPi / Decimal.fromInt(count);
    Decimal cosPerSidePi = decimalCos(perSidePi);
    Decimal rX = r* cosPerSidePi;
    Decimal rX_r = rX + r;
    PointEX first = PointEX(Decimal.zero, -r);
    // 将圆等分,开始第一个点
    start(first.x,first.y);

    var xo = Decimal.zero;
    var yo = Decimal.zero;
    var x2 = xo + r * decimalCos(Decimal.fromInt(90) * decimalPi/ Decimal.fromInt(180));
    var y2 = yo + r * decimalSin(Decimal.fromInt(90) * decimalPi/ Decimal.fromInt(180));
    PointEX second = PointEX(x2, y2);
    lineTo(x2, y2);

    var x3 = xo + r * decimalCos(Decimal.fromInt(180) * decimalPi/ Decimal.fromInt(180));
    var y3 = yo + r * decimalSin(Decimal.fromInt(180) * decimalPi/ Decimal.fromInt(180));

    lineTo(x3, y3);


    var x4 = xo + r * decimalCos(Decimal.fromInt(270) * decimalPi/ Decimal.fromInt(180));
    var y4 = yo + r * decimalSin(Decimal.fromInt(270) * decimalPi/ Decimal.fromInt(180));
    lineTo(x4, y4);
  }
}