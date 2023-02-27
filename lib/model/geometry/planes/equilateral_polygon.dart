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
      points.add(PointEX(x,y));
    }
    lineTo(Decimal x, Decimal y)
    {
      points.add(PointEX(x,y));
    }
    //endregion

    Decimal r = this.size / decimal2;
    // 将圆等分,开始第一个点
    start(r * decimalCos(decimalPi / Decimal.fromInt(count))+r,
        r * decimalSin(decimalPi / Decimal.fromInt(count))+r);

    //创建边
    // start(r * cos(pi / count), r * sin(pi / count));
    for (int i = 2; i <= count * 2; i++) {
      if (i.isOdd) {
        lineTo(r * decimalCos(decimalPi / Decimal.fromInt(count*i))+r, r * decimalSin(decimalPi / Decimal.fromInt(count*i))+r);
      }
    }
  }
}