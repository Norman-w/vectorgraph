import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/num_utils.dart';
import '../points/point_ex.dart';
import '../rect/RectEX.dart';
import 'line_segment.dart';

class Bezier
{
  //开始点
  final PointEX position;
  //结束点
  final PointEX end;
  //主引导的四个点的最长等分数量.这个数量也用于画出的子线段再次分割时使用.
  int max1LevelDotCount = 0;
  //主引导的四个点组成的三条线段被等分后的点集合.
  var line0_1Dots = <PointEX>[];
  var line1_2Dots = <PointEX>[];
  var line2_3Dots = <PointEX>[];

  final bezierPoints = <PointEX>[];
  RectEX bounds = RectEX.zero;

  //开始点的控制点
  PointEX startController = PointEX.zero;
  //结束点的控制点
  PointEX endController = PointEX.zero;

  //构造函数
  Bezier(this.position, this.end)
  {
    var start = PointEX.zero;
    var xDistance = end.x - start.x;
    //开始点的控制点在结束点的横向一侧,高度用起始点的.
    // startController = Offset(end.dx,start.dy);
    startController = PointEX(start.x+xDistance/Decimal.two,start.y);
    //结束点的控制点在开始点的横向一侧,长度是横向起点终点的一半,高度用结束点的.

    endController = PointEX(end.x-xDistance/Decimal.two,end.y);
    // endController = Offset(end.dx-xDistance,end.dy);


    //在相邻的两条线上按照比例取点
    max1LevelDotCount = getPerLineSplit2DotCount();

    var level1Dots = getLevel1Dots();
    createLevel2LineAndDots(level1Dots);
    createLevel3RealBezierDots();

    var left = start.x> end.x ? end.x:start.x;
    var right = start.x > end.x? start.x:end.x;
    var top = start.y > end.y? end.y:start.y;
    var bottom = start.y > end.y? start.y:end.y;

    // print("left:$left,right:$right,top:$top,bottom:$bottom");
    bounds = RectEX.fromLTRB(left, top, right, bottom);
    // print(bounds);
  }
  //
  // factory Bezier.to(Offset dest)
  // {
  //   return Bezier(const Offset(0,0), dest);
  // }
  //获取主路径点的四个点:开始点,开始控制点,结束控制点,结束点.
  List<PointEX> getLevel1Dots()
  {
    return [PointEX.zero,startController,endController,end];
  }
  //根据主要的三条直线创建直线上的点集合
  createLevel2LineAndDots(List<PointEX> dots)
  {
    line0_1Dots = createDotsForLine(dots[0], dots[1], max1LevelDotCount);
    line1_2Dots = createDotsForLine(dots[1], dots[2], max1LevelDotCount);
    line2_3Dots = createDotsForLine(dots[2], dots[3], max1LevelDotCount);
  }
  //根据四个点所产生的一级直线创建两条二级直线然后再在二级直线上创建三级(最后一级)直线并取点,添加到正式需要渲染的点表中.
  createLevel3RealBezierDots()
  {
    bezierPoints.clear();
    for(var i=0;i<max1LevelDotCount;i++)
    {
      //为运动的两条线创建点
      var movingLevel2Line1Dots = createDotsForLine(line0_1Dots[i], line1_2Dots[i], max1LevelDotCount);
      var movingLevel2Line2Dots = createDotsForLine(line1_2Dots[i], line2_3Dots[i], max1LevelDotCount);

      //在最后一条直线上画出来当前时间点所对应的点,也就是贝塞尔曲线的最终组成点.
      var movingLevel3LineDots = createDotsForLine(movingLevel2Line1Dots[i], movingLevel2Line2Dots[i], max1LevelDotCount);
      var currentBezierDot = movingLevel3LineDots[i];
      bezierPoints.add(currentBezierDot);
    }
  }
  //获取需要把每条线段切割成多少个点(根据横向或者纵向的距离的最长距离)
  int getPerLineSplit2DotCount()
  {
    //获取过两点做出的水平且垂直的长方体的较长边有多少像素
    var xMax = PointEX.zero.x>end.x? PointEX.zero.x:end.x;
    var xMin = PointEX.zero.x>end.x? end.x:PointEX.zero.x;
    var yMax = PointEX.zero.y>end.y? PointEX.zero.y:end.y;
    var yMin = PointEX.zero.y>end.y? end.y:PointEX.zero.y;
    Decimal xDistance = xMax - xMin;
    Decimal yDistance = yMax - yMin;
    return xDistance>yDistance? xDistance.toDouble().toInt():yDistance.toDouble().toInt();
  }
  //获取两个点之间的距离.
  getDistance(Offset start, Offset end){
    var dx= start.dx-end.dx;
    var dy= start.dy-end.dy;
    return sqrt(dx*dx+dy*dy);
  }
  //为线段均匀创建指定数量的点.
  List<PointEX> createDotsForLine(PointEX start,PointEX end, int dotCount)
  {
    var ret = <PointEX>[];
    //总长度
    // var distance = getDistance(start, end);
    //每一段的长度,也就是每两个点之间的长度
    // var perDotDistance = distance / dotCount;
    //根据需要的次数循环制作出来直线路径上的点.
    var perStepMoveX = (end.x-start.x)/Decimal.fromInt(dotCount);
    var perStepMoveY = (end.y-start.y)/Decimal.fromInt(dotCount);
    for(var i=0;i<dotCount;i++)
    {
      var totalMoveX = perStepMoveX*Decimal.fromInt(i);
      var totalMoveY = perStepMoveY*Decimal.fromInt(i);
      var newX = start.x+totalMoveX;
      var newY = start.y+totalMoveY;
      var current = PointEX(newX, newY);
      ret.add(current);
    }
    return ret;
  }

  ///转换成LineSegment的集合
  List<LineSegment> toLineSegments(){
    var ret = <LineSegment>[];
    for(var i=0;i<bezierPoints.length-1;i++)
    {
      ret.add(LineSegment(bezierPoints[i], bezierPoints[i+1]));
    }
    return ret;
  }
  ///获取外边框
  RectEX getBoundingBox()
  {
    return bounds;
  }
}

//region 带有动画效果的贝塞尔曲线显示组件





//endregion

extension BezierFunctions on Bezier{
  ///判断点是否在贝塞尔曲线上
  bool isPointOn(PointEX pointEX){
    //原方程
    //x=x0*(1-t)^3 + 3*x1*t*(1-t)^2+3*x2*t^2*(1-t)+x3*t^3
    //变形后
    //(x3-3*x2+3*x1-x0)*t^3 + (3*x2 - 6*x1 + 3*x0)*t^2 + (3*x1 - 3*x0)*t + (x0-x) = 0;
    //解出这个方程中的x,假设t = 0.5
    var t = Decimal.fromDouble(0.5);
    var x3 = end.x;
    var x2 = endController.x;
    var x1 = startController.x;
    var x0 = PointEX.zero.x;
    var d3 = Decimal.fromInt(3);
    var d6 = Decimal.fromInt(6);
    var x = (x3-d3*x2+d3*x1-x0)*decimalPow(t, 3) + (d3*x2 - d6*x1 + d3*x0)*decimalPow(t, 2) + (d3*x1 - d3*x0)*t + (x0-pointEX.x);
  }

}

