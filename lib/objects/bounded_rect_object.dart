/*
圆角矩形物件,具备四个圆角弧线(半径来自基类),具备四个边线(宽高等来自基类)
可通过该类的对象访问到四个弧线的Object以进行绘制
* */


import 'package:vectorgraph/model/geometry/lines/line_segment.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/model/geometry/rect/BoundedRectEX.dart';
import 'package:vectorgraph/objects/sector_object.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import 'space_object.dart';
import '../model/geometry/rect/RectEX.dart';

class BoundedRectObject extends BoundedRectEX with SpaceObject,APlaneObject{
  ///初始化四个扇形的对象
  void _initCornerSectorObjects()
  {
    //如果四个弧度都为0,则不需要初始化
    if(leftTopRadius <= Decimal.zero)
    {
      return;
    }
    leftTopSector = SectorObject.fromCanvas(
        RectEX.fromLTWH(left, top, leftTopRadius * Decimal.two, leftTopRadius * Decimal.two),
        Decimal.zero,
        Decimal.fromInt(180),
        Decimal.fromInt(90));
    if(rightTopRadius <= Decimal.zero)
    {
      return;
    }
    rightTopSector = SectorObject.fromCanvas(
        RectEX.fromLTWH(right - rightTopRadius * Decimal.two, top, rightTopRadius * Decimal.two, rightTopRadius * Decimal.two),
        Decimal.zero,
        Decimal.fromInt(270),
        Decimal.fromInt(90));
    if(leftBottomRadius <= Decimal.zero)
    {
      return;
    }
    leftBottomSector = SectorObject.fromCanvas(
        RectEX.fromLTWH(left, bottom - leftBottomRadius * Decimal.two, leftBottomRadius * Decimal.two, leftBottomRadius * Decimal.two),
        Decimal.zero,
        Decimal.fromInt(90),
        Decimal.fromInt(90));
    if(rightBottomRadius <= Decimal.zero)
    {
      return;
    }
    rightBottomSector = SectorObject.fromCanvas(
        RectEX.fromLTWH(right - rightBottomRadius * Decimal.two, bottom - rightBottomRadius * Decimal.two, rightBottomRadius * Decimal.two, rightBottomRadius * Decimal.two),
        Decimal.zero,
        Decimal.zero,
        Decimal.fromInt(90));
  }
  void _initRealLineSegments()
  {
    //初始化四条边(去掉四个角的弧线)
    var realTopLeft = leftTopSector?.startPoint ?? leftTop;
    var realTopRight = rightTopSector?.startPoint ?? topRight;
    var realBottomLeft = leftBottomSector?.startPoint ?? bottomLeft;
    var realBottomRight = rightBottomSector?.startPoint ?? bottomRight;
    leftLine = LineSegment(realTopLeft, realBottomLeft);
    topLine = LineSegment(realTopLeft, realTopRight);
    rightLine = LineSegment(realTopRight, realBottomRight);
    bottomLine = LineSegment(realBottomLeft, realBottomRight);
  }
  BoundedRectObject.fromLTWH(super.left, super.top, super.width, super.height) :
      leftLine = LineSegment(PointEX.zero, PointEX.zero),
      topLine = LineSegment(PointEX.zero, PointEX.zero),
      rightLine = LineSegment(PointEX.zero, PointEX.zero),
      bottomLine = LineSegment(PointEX.zero, PointEX.zero),
        super.fromLTWH(){
    _initCornerSectorObjects();
    _initRealLineSegments();
  }
  BoundedRectObject.fromLTWHRadius(
      Decimal left,
      Decimal top,
      Decimal width,
      Decimal height,
      Decimal radius)
      : leftLine = LineSegment.zero,
        topLine = LineSegment.zero,
        rightLine = LineSegment.zero,
        bottomLine = LineSegment.zero,
        super.fromLTWHRadius(left, top, width, height, radius){
    _initCornerSectorObjects();
    _initRealLineSegments();
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
      : leftLine = LineSegment.zero,
        topLine = LineSegment.zero,
        rightLine = LineSegment.zero,
        bottomLine = LineSegment.zero,
        super.fromLTWHEachRadius(left, top, width, height, leftTopRadius,
      rightTopRadius, leftBottomRadius, rightBottomRadius){
    _initCornerSectorObjects();
    _initRealLineSegments();
  }

  @override
  APlaneObject copyWith() {
    return BoundedRectObject.fromLTWHEachRadius(
        super.left, super.top, super.width, super.height, super.leftTopRadius,
        super.rightTopRadius, super.leftBottomRadius, super.rightBottomRadius);
  }

  //region 字段
  PointEX? _position;
  SectorObject? leftTopSector;
  SectorObject? rightTopSector;
  SectorObject? leftBottomSector;
  SectorObject? rightBottomSector;
  LineSegment leftLine;
  LineSegment topLine;
  LineSegment rightLine;
  LineSegment bottomLine;
  //endregion

  @override
  bool isWorldPointIn(PointEX pointEX) {
    //鼠标的世界坐标点减去我的世界坐标点就是鼠标相对于我的坐标点
    var relativePoint = pointEX - position;
    //如果相对坐标点不在我的自身范围内,则一定不在我的世界范围内
    if(!selfBounds.contains(relativePoint))
    {
      return false;
    }
    //如果相对坐标点在我的自身范围内,需要判断是不是在我的四个角的扇形中
    //运行到这个地方,只有鼠标在四个角的矩形中
    //但是不在鼠标所在的角的扇形中,才会判断为不在我的世界范围内
    var atLeftTopRect = leftTopSector?.bounds.contains(relativePoint) ?? false;
    if(atLeftTopRect && !leftTopSector!.isPointIn(relativePoint))
    {
      return false;
    }
    var atRightTopRect = rightTopSector?.bounds.contains(relativePoint) ?? false;
    if(atRightTopRect && !rightTopSector!.isPointIn(relativePoint))
    {
      return false;
    }
    var atLeftBottomRect = leftBottomSector?.bounds.contains(relativePoint) ?? false;
    if(atLeftBottomRect && !leftBottomSector!.isPointIn(relativePoint))
    {
      return false;
    }
    var atRightBottomRect = rightBottomSector?.bounds.contains(relativePoint) ?? false;
    if(atRightBottomRect && !rightBottomSector!.isPointIn(relativePoint))
    {
      return false;
    }
    return true;
  }

  @override
  bool isWorldPointOnEdgeLines(PointEX pointEX, Decimal deviation
      ) {
    //获得相对坐标
    var relativePoint = pointEX - position;
    //如果相对坐标点不在我的自身范围内,则一定不在我的世界范围内
    if(!selfBounds.contains(relativePoint))
    {
      return false;
    }
    //如果在我的四条边线的任意一条边线上,则在边线上
    if(leftLine.isPointOnLine(relativePoint, deviation: deviation))
    {
      return true;
    }
    if(topLine.isPointOnLine(relativePoint, deviation: deviation))
    {
      return true;
    }
    if(rightLine.isPointOnLine(relativePoint, deviation: deviation))
    {
      return true;
    }
    if(bottomLine.isPointOnLine(relativePoint, deviation: deviation))
    {
      return true;
    }

    //如果相对坐标在某个扇形所在的矩形内,则判断是否在扇形的边线上
    var atLeftTopRect = leftTopSector?.bounds.contains(relativePoint) ?? false;
    if(atLeftTopRect && leftTopSector!.isPointOnLine(relativePoint, deviation: deviation))
    {
      return true;
    }
    var atRightTopRect = rightTopSector?.bounds.contains(relativePoint) ?? false;
    if(atRightTopRect && rightTopSector!.isPointOnLine(relativePoint, deviation: deviation))
    {
      return true;
    }
    var atLeftBottomRect = leftBottomSector?.bounds.contains(relativePoint) ?? false;
    if(atLeftBottomRect && leftBottomSector!.isPointOnLine(relativePoint, deviation: deviation))
    {
      return true;
    }
    var atRightBottomRect = rightBottomSector?.bounds.contains(relativePoint) ?? false;
    if(atRightBottomRect && rightBottomSector!.isPointOnLine(relativePoint, deviation: deviation))
    {
      return true;
    }
    return false;
  }

  @override
  PointEX get position => _position??PointEX.zero;

  //为什么判断是否在扇形的边线上,而不是直接使用这个矩形的边缘
  //是因为扇形有可能是鼓起来的,这样的话,扇形的边缘要比矩形的边缘要大
  @override
  RectEX get selfBounds => RectEX.fromLTRB(
      leftTopSector?.bounds.left??left,
      leftTopSector?.bounds.top??top,
      rightTopSector?.bounds.right??right,
      leftBottomSector?.bounds.bottom??bottom);

  @override
  RectEX get worldBounds => RectEX.fromLTRB(
      leftTopSector?.worldBounds.left??left,
      leftTopSector?.worldBounds.top??top,
      rightTopSector?.worldBounds.right??right,
      leftBottomSector?.worldBounds.bottom??bottom);
}