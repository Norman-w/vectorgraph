/*
圆角矩形物件,具备四个圆角弧线(半径来自基类),具备四个边线(宽高等来自基类)
可通过该类的对象访问到四个弧线的Object以进行绘制
* */


import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/model/geometry/rect/BoundedRectEX.dart';
import 'package:vectorgraph/objects/arc_object.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import 'space_object.dart';
import '../model/geometry/rect/RectEX.dart';

class BoundedRectObject extends BoundedRectEX with SpaceObject,APlaneObject{
  ///初始化四个弧线的对象
  void _initCornerArcObjects()
  {
    //如果四个弧度都为0,则不需要初始化
    if(leftTopRadius <= Decimal.zero)
    {
      return;
    }
    leftTopArc = ArcObject.fromCanvas(
        RectEX.fromLTWH(left, top, leftTopRadius * Decimal.two, leftTopRadius * Decimal.two),
        Decimal.zero,
        Decimal.fromInt(180),
        Decimal.fromInt(90));
    if(rightTopRadius <= Decimal.zero)
    {
      return;
    }
    rightTopArc = ArcObject.fromCanvas(
        RectEX.fromLTWH(right - rightTopRadius * Decimal.two, top, rightTopRadius * Decimal.two, rightTopRadius * Decimal.two),
        Decimal.zero,
        Decimal.fromInt(270),
        Decimal.fromInt(90));
    if(leftBottomRadius <= Decimal.zero)
    {
      return;
    }
    leftBottomArc = ArcObject.fromCanvas(
        RectEX.fromLTWH(left, bottom - leftBottomRadius * Decimal.two, leftBottomRadius * Decimal.two, leftBottomRadius * Decimal.two),
        Decimal.zero,
        Decimal.fromInt(90),
        Decimal.fromInt(90));
    if(rightBottomRadius <= Decimal.zero)
    {
      return;
    }
    rightBottomArc = ArcObject.fromCanvas(
        RectEX.fromLTWH(right - rightBottomRadius * Decimal.two, bottom - rightBottomRadius * Decimal.two, rightBottomRadius * Decimal.two, rightBottomRadius * Decimal.two),
        Decimal.zero,
        Decimal.zero,
        Decimal.fromInt(90));
  }
  BoundedRectObject.fromLTWH(super.left, super.top, super.width, super.height) : super.fromLTWH(){
    _initCornerArcObjects();
  }
  BoundedRectObject.fromLTWHRadius(
      Decimal left,
      Decimal top,
      Decimal width,
      Decimal height,
      Decimal radius)
      : super.fromLTWHRadius(left, top, width, height, radius){
    _initCornerArcObjects();
  }
  BoundedRectObject.fromLTWHEachRadius(
      Decimal left,
      Decimal top,
      Decimal width,
      Decimal height,
      Decimal leftTopRadius,
      Decimal rightTopRadius,
      Decimal leftBottomRadius,
      Decimal rightBottomRadius)
      : super.fromLTWHEachRadius(left, top, width, height, leftTopRadius,
      rightTopRadius, leftBottomRadius, rightBottomRadius){
    _initCornerArcObjects();
  }

  @override
  APlaneObject copyWith() {
    return BoundedRectObject.fromLTWHEachRadius(
        super.left, super.top, super.width, super.height, super.leftTopRadius,
        super.rightTopRadius, super.leftBottomRadius, super.rightBottomRadius);
  }

  //region 字段
  ArcObject? leftTopArc;
  ArcObject? rightTopArc;
  ArcObject? leftBottomArc;
  ArcObject? rightBottomArc;
  //endregion

  @override
  bool isWorldPointIn(PointEX pointEX) {
    // TODO: implement isWorldPointIn
    throw UnimplementedError();
  }

  @override
  bool isWorldPointOnEdgeLines(PointEX pointEX, Decimal deviation
      ) {
    // TODO: implement isWorldPointOnEdgeLines
    throw UnimplementedError();
  }

  @override
  // TODO: implement position
  PointEX get position => throw UnimplementedError();

  @override
  // TODO: implement selfBounds
  RectEX get selfBounds => throw UnimplementedError();

  @override
  // TODO: implement worldBounds
  RectEX get worldBounds => throw UnimplementedError();

}