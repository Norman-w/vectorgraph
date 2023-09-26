/*
几何扇形.
扇形由一条弧线和两个线段组成.
以x,y=1,0方向为起始方向,在矩形R的内切椭圆上通过起始点PS和终止点PE的弧线,以及起始点PS和终止点PE的连线,组成扇形.
这样的扇形我把它定义为椭圆上的一般扇形.
当椭圆是一个正圆,或者说椭圆的内切矩形是正方形时,这样的扇形就是一个正圆一般扇形.

那么一般对应的是什么呢?非一般
非一般的扇形,弧线还是那条弧线,但是两条线段的焦点不在正椭圆的圆心上,而是在可能的任一点,但两条线段仍然是在连接的,且不会穿过弧线.


如何判断一个扇形是一般扇形还是非一般扇形?
首先扇形一定要满足有一条弧线,有两个线段,如
线段L1(P0,P1),线段L2(P0,P2),弧线P1P2
所构成的扇形可以表示为(P0,P1,P2)即从弧线所在椭圆所内切的矩形的中心点P0起,线段连接到P1,再弧线连接到P2,再线段连接到P0,闭合所形成的图形.
我们知道扇形是一条弧线和两条线段组成,弧线我们知道是属于椭圆,椭圆是内切与矩形,所以只要判断扇形的两条线段焦点是在矩形的中心点上即表示是一般扇形,否则就是非一般扇形.


判断一个点是否在扇形内部.分两大种情况,第一种是一般扇形,第二种是非一般扇形.

第一种:线段焦点在圆弧所在椭圆所内切的矩形中心(没有被修改过的扇形)
从椭圆的圆心P0向鼠标所在点P3做射线L3,如果射线与扇形的弧线相交,则判断P3点在扇形内部,否则在扇形外部(超出角度)
求出P0到P3的距离
求出x轴正方向与L3的夹角 ∠L
在弧线上找出∠L的点,记为P4
求出P0到P4的距离,记为d1(distance1)
求出P0到P3的距离,记为d3
如果d3<=d1,则P3在扇形内部,否则在扇形外部(超出扇形区域)

第二种:两线段焦点有变化
如果扇形的直边有变化,就不是一个正常的扇形,这种要特殊处理.
如图

a是正常的,b,c等都是要特殊处理的.
方法是先找出正常扇形,然后算多的和少的三角形部分(可能是多个三角形)

如图

变化可能但不限于这些种变化




扇形->扇形的变种   ＝   扇形->弧不变,动两直线的交点.

情况分围如下四类:

1,新点在边上(只能是某一条,不能两条)

2,新点在变的延长线上(也是只能在某一条,不能两条)

3,新点在扇形的内部

4,新点在扇形的外部
  这种情况还分为三种细分的情况:
    A:弧线开始点和结束点到新点的连线和正常扇形的直边均不想交
    B:弧线开始点和结束点到新点的连线和正常扇形的直边有一条相交(有两条相交是不可能的)
    C:在正常扇形的弧的整个椭圆"外"的新点,这种不处理,属于坏扇形,种类包括穿刺扇形和不穿刺扇形.
      其中上图中的第二种情况属于非穿刺扇但是属于反扇
      上面说的外,指的是 在扇形角度内才算,也就是新点在正常扇形外且在正常扇形所在角内.

  以上正常扇形和非正常扇形,穿刺扇等均会出现在svg等场景,做图形检测等会用到的.


另,以上内容只是一个大纲,具体的参考 "扇形.xmind"及"正常扇形移动线段交点后的扇形变种.skp"
* */

/*
另外要注意一个问题是:
弧线所使用的坐标是世界坐标.而扇形所使用的坐标是相对坐标+Position的方式.
* */

//一般的扇形

import 'package:vectorgraph/model/geometry/lines/arc.dart';
import '../../../utils/num_utils.dart';
import '../lines/line_segment.dart';
import '../points/point_ex.dart';
import '../rect/RectEX.dart';

class Sector{
  //region 字段
  ///中心点到起始点的连线
  late final LineSegment _centerToStartLine;
  ///中心点到终止点的连线
  late final LineSegment _centerToEndLine;
  ///弧线
  late final Arc _arc;
  //endregion


  //region 属性
  ///相对坐标,不是世界坐标的弧线信息
  Arc get arc => _arc;
  //endregion


  //region 工厂函数

  ///从canvas的弧线构造扇形
  Sector.fromCanvas(
      RectEX arcOwnEllipseBoundRect,
      Decimal rotationRadian, Decimal startAngle, Decimal sweepAngle)
  : _arc = Arc.fromCanvas(arcOwnEllipseBoundRect, rotationRadian, startAngle, sweepAngle){
    _centerToStartLine = LineSegment(_arc.bounds.center, _arc.startPoint);
    _centerToEndLine = LineSegment(_arc.bounds.center, _arc.endPoint);
  }

  ///从svg的弧线构造扇形
  Sector.fromSVG(
      PointEX startPoint,
      Decimal rx,
      Decimal ry,
      Decimal rotationDegrees,
      bool laf,
      bool sf,
      PointEX endPoint
      ) : _arc = Arc.fromSVG(startPoint, rx, ry, rotationDegrees, laf, sf, endPoint){
    _centerToStartLine = LineSegment(PointEX.zero, startPoint);
    _centerToEndLine = LineSegment(PointEX.zero, endPoint);
  }
  //endregion

  //region 属性
  // @override
  // PointEX position;
  ///中心点到起始点的连线
  LineSegment get centerToStartLine => _centerToStartLine;
  ///中心点到终止点的连线
  LineSegment get centerToEndLine => _centerToEndLine;
  PointEX get startPoint => _arc.startPoint;
  PointEX get endPoint => _arc.endPoint;
  RectEX get bounds => _arc.bounds;
  //endregion

  //region 方法
  ///点是否在扇形内部
  bool contains(PointEX pointEX, {Decimal? deviation}){
    // pointEX = PointEX(Decimal.fromInt(-333), Decimal.fromInt(-277));
    var realDeviation = deviation ?? Decimal.one;
    //中心点到鼠标所在位置的连线的向量
    var centerToMouseVector = _arc.getCenterToMouseAngle(pointEX);
    //如果不在弧线的角度内,则一定不在扇形内部
    if(!_arc.isInArcAngleRange(centerToMouseVector, realDeviation)) {
      return false;
    }
    //在弧线上该角度的点
    var onArcPoint = _arc.getOnEdgePointByAngle(radiansToDegrees(centerToMouseVector.getAngle()));
    //对比长度,如果鼠标所在的点到圆心的距离小于等于弧线上该角度的点到圆心的距离,则在扇形内部
    var zero2PointDistance = pointEX.distanceTo(_arc.position);
    var zero2OnArcPointDistance = onArcPoint.distanceTo(PointEX.zero);
    var lessThanRadius = zero2PointDistance <= zero2OnArcPointDistance;
    if(lessThanRadius){
      print("在里面哦");
    }
    return lessThanRadius;
  }

  //重写isPointOnLine,因为除了弧线以外还应该检查是否在圆心到起始点和圆心到终止点的连线上
  bool isPointOnLine(PointEX point, {Decimal? deviation}) {
    var realDeviation = deviation ?? Decimal.one;
    //在弧线上吗?
    if(_arc.isPointOnLine(point, deviation: realDeviation)) {
      return true;
    }
    //在原点到起始点的连线上吗?
    if(_centerToStartLine.isPointOnLine(point, deviation: realDeviation)) {
      return true;
    }
    //在原点到终止点的连线上吗?
    if(_centerToEndLine.isPointOnLine(point, deviation: realDeviation)) {
      return true;
    }
    return false;
  }
  //endregion
}