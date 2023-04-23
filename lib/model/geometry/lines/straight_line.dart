import 'dart:html';

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
  Decimal getAngle(){
    return getVector().getAngle();
  }
  void normalize(){
    var vector = getVector();
    vector.setLength(Decimal.one);
    point2 = PointEX(point1.x + vector.x, point1.y + vector.y);
  }
  // ///判断两条直线的交点坐标  有问题
  // static PointEX? getCrossPoint(PointEX point1,PointEX point2,PointEX point3,PointEX point4) {
  //   if ((point2.y - point1.y) * (point4.x - point3.x) ==
  //       (point4.y - point3.y) * (point2.x - point1.x)) return null;
  //   if (point2.x - point1.x == Decimal.zero) {
  //     Decimal k2 = (point4.y - point3.y) / (point4.x - point3.x);
  //     Decimal b2 = point3.y - point3.x * k2;
  //     Decimal cross_x = point1.x;
  //     Decimal cross_y = k2 * cross_x + b2;
  //     return PointEX(cross_x, cross_y);
  //   }
  //   if (point4.x - point3.x == Decimal.zero) {
  //     Decimal k1 = (point2.y - point1.y) / (point2.x - point1.x);
  //     Decimal b1 = point1.y - point1.x * k1;
  //     Decimal cross_x = point3.x;
  //     Decimal cross_y = k1 * cross_x + b1;
  //     return PointEX(cross_x, cross_y);
  //   }
  //   Decimal k1 = (point2.y - point1.y) / (point2.x - point1.x);
  //   Decimal b1 = point1.y - point1.x * k1;
  //   Decimal k2 = (point4.y - point3.y) / (point4.x - point3.x);
  //   Decimal b2 = point3.y - point3.x * k2;
  //   Decimal cross_x = (b1 - b2) / (k2 - k1);
  //   Decimal cross_y = k1 * cross_x + b1;
  //   return PointEX(cross_x, cross_y);
  // }
  ///判断两条直线的交点坐标
  /// <summary>
  /// 计算两条直线的交点
  /// </summary>
  /// <param name="lineFirstStar">L1的点1坐标</param>
  /// <param name="lineFirstEnd">L1的点2坐标</param>
  /// <param name="lineSecondStar">L2的点1坐标</param>
  /// <param name="lineSecondEnd">L2的点2坐标</param>
  /// <returns></returns>
  static PointEX? getCrossPoint(PointEX lineFirstStar, PointEX lineFirstEnd, PointEX lineSecondStar, PointEX lineSecondEnd)
  {
    /*
             * L1，L2都存在斜率的情况：
             * 直线方程L1: ( y - y1 ) / ( y2 - y1 ) = ( x - x1 ) / ( x2 - x1 )
             * => y = [ ( y2 - y1 ) / ( x2 - x1 ) ]( x - x1 ) + y1
             * 令 a = ( y2 - y1 ) / ( x2 - x1 )
             * 有 y = a * x - a * x1 + y1   .........1
             * 直线方程L2: ( y - y3 ) / ( y4 - y3 ) = ( x - x3 ) / ( x4 - x3 )
             * 令 b = ( y4 - y3 ) / ( x4 - x3 )
             * 有 y = b * x - b * x3 + y3 ..........2
             *
             * 如果 a = b，则两直线平等，否则， 联解方程 1,2，得:
             * x = ( a * x1 - b * x3 - y1 + y3 ) / ( a - b )
             * y = a * x - a * x1 + y1
             *
             * L1存在斜率, L2平行Y轴的情况：
             * x = x3
             * y = a * x3 - a * x1 + y1
             *
             * L1 平行Y轴，L2存在斜率的情况：
             * x = x1
             * y = b * x - b * x3 + y3
             *
             * L1与L2都平行Y轴的情况：
             * 如果 x1 = x3，那么L1与L2重合，否则平等
             *
            */
    Decimal a = Decimal.zero ,b=Decimal.zero;
    int state = 0;
    if (lineFirstStar.x != lineFirstEnd.x)
    {
      a = (lineFirstEnd.y - lineFirstStar.y) / (lineFirstEnd.x - lineFirstStar.x);
      state |= 1;
    }
    if (lineSecondStar.x != lineSecondEnd.x)
    {
      b = (lineSecondEnd.y - lineSecondStar.y) / (lineSecondEnd.x - lineSecondStar.x);
      state |= 2;
    }
    switch (state)
    {
      case 0: //L1与L2都平行Y轴
        {
          if (lineFirstStar.x == lineSecondStar.x)
          {
            //throw new Exception("两条直线互相重合，且平行于Y轴，无法计算交点。");
            return null;
          }
          else
          {
            //throw new Exception("两条直线互相平行，且平行于Y轴，无法计算交点。");
            return null;
          }
        }
      case 1: //L1存在斜率, L2平行Y轴
        {
          Decimal x = lineSecondStar.x;
          Decimal y = (lineFirstStar.x - x) * (-a) + lineFirstStar.y;
          return PointEX(x, y);
        }
      case 2: //L1 平行Y轴，L2存在斜率
        {
          Decimal x = lineFirstStar.x;
          //网上有相似代码的，这一处是错误的。你可以对比case 1 的逻辑 进行分析
          //源code:lineSecondStar * x + lineSecondStar * lineSecondStar.X + p3.Y;
          Decimal y = (lineSecondStar.x - x) * (-b) + lineSecondStar.y;
          return PointEX(x, y);
        }
      case 3: //L1，L2都存在斜率
        {
          if (a == b)
          {
            // throw new Exception("两条直线平行或重合，无法计算交点。");
            return null;
          }
          Decimal x = (a * lineFirstStar.x - b * lineSecondStar.x - lineFirstStar.y + lineSecondStar.y) / (a - b);
          Decimal y = a * x - a * lineFirstStar.x + lineFirstStar.y;
          return PointEX(x, y);
        }
    }
    // throw new Exception("不可能发生的情况");
    return null;
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