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
    var degree90 = Decimal.fromInt(90) * decimalPerDegree;
    var degree180 = Decimal.fromInt(180) * decimalPerDegree;
    var degree270 = Decimal.fromInt(270) * decimalPerDegree;
    //如果四个弧度都为0,则不需要初始化
    if(leftTopRadius <= Decimal.zero)
    {
      return;
    }
    leftTopSector = SectorObject.fromCanvas(
        RectEX.fromLTWH(left, top, leftTopRadius * Decimal.two, leftTopRadius * Decimal.two),
        Decimal.zero,
        degree180,
        degree90);
    if(rightTopRadius <= Decimal.zero)
    {
      return;
    }
    rightTopSector = SectorObject.fromCanvas(
        RectEX.fromLTWH(right - rightTopRadius * Decimal.two, top, rightTopRadius * Decimal.two, rightTopRadius * Decimal.two),
        Decimal.zero,
        degree270,
        degree90);
    if(leftBottomRadius <= Decimal.zero)
    {
      return;
    }
    leftBottomSector = SectorObject.fromCanvas(
        RectEX.fromLTWH(left, bottom - leftBottomRadius * Decimal.two, leftBottomRadius * Decimal.two, leftBottomRadius * Decimal.two),
        Decimal.zero,
        degree90,
        degree90);
    if(rightBottomRadius <= Decimal.zero)
    {
      return;
    }
    rightBottomSector = SectorObject.fromCanvas(
        RectEX.fromLTWH(right - rightBottomRadius * Decimal.two, bottom - rightBottomRadius * Decimal.two, rightBottomRadius * Decimal.two, rightBottomRadius * Decimal.two),
        Decimal.zero,
        Decimal.zero,
        degree90);
  }
  void _initRealLineSegments()
  {
    /*
    ╭0→→→→→→→→╮
    ↑         ↓
    ↑         ↓
    ↑         ↓
    ╰←←←←←←←←←╯
    * */
    //初始化四条边(去掉四个角的弧线) 顺时针方向.左上角过了弧线以后开始,从上图的"0"点开始
    //上方线的开始点为左上角弧线的结束点,如果没有左上角弧线,则使用左上角点.
    var topLineStart = leftTopSector?.endPoint??leftTop;
    var topLineEnd = rightTopSector?.startPoint??topRight;
    //右方线的开始点为右上角弧线的结束点,如果没有右上角弧线,则使用右上角点.
    var rightLineStart = rightTopSector?.endPoint??topRight;
    var rightLineEnd = rightBottomSector?.startPoint??bottomRight;
    //下方线的开始点为右下角弧线的结束点,如果没有右下角弧线,则使用右下角点.
    var bottomLineStart = rightBottomSector?.endPoint??bottomRight;
    var bottomLineEnd = leftBottomSector?.startPoint??bottomLeft;
    //左方线的开始点为左下角弧线的结束点,如果没有左下角弧线,则使用左下角点.
    var leftLineStart = leftBottomSector?.endPoint??bottomLeft;
    var leftLineEnd = leftTopSector?.startPoint??topLeft;
    topLine = LineSegment(topLineStart, topLineEnd);
    rightLine = LineSegment(rightLineStart, rightLineEnd);
    bottomLine = LineSegment(bottomLineStart, bottomLineEnd);
    leftLine = LineSegment(leftLineStart, leftLineEnd);
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
      // print('相对坐标$pointEX不在我自身内部');
      return false;
    }
    //如果相对坐标点在我的自身范围内,需要判断是不是在我的四个角的扇形中
    //运行到这个地方,只有鼠标在四个角的矩形中
    //但是不在鼠标所在的角的扇形中,才会判断为不在我的世界范围内

    //region 弧线所在的矩形是更大一些的,但是我们检查的只是检查了某一个角的,如果是90度角的话 只是检测那个弧线所在矩形的四分之一
    var leftTopCheckingRect = RectEX.zero;
    if(leftTopSector!= null){
      leftTopCheckingRect = RectEX.fromLTWH(
          selfBounds.left,
          selfBounds.top,
          leftTopRadius,
          leftTopRadius);
    }
    var rightTopCheckingRect = RectEX.zero;
    if(rightTopSector!= null){
      rightTopCheckingRect = RectEX.fromLTWH(
          selfBounds.right - rightTopRadius,
          selfBounds.top,
          rightTopRadius,
          rightTopRadius);
    }
    var leftBottomCheckingRect = RectEX.zero;
    if(leftBottomSector!= null){
      leftBottomCheckingRect = RectEX.fromLTWH(
          selfBounds.left,
          selfBounds.bottom - leftBottomRadius,
          leftBottomRadius,
          leftBottomRadius);
    }
    var rightBottomCheckingRect = RectEX.zero;
    if(rightBottomSector!= null){
      rightBottomCheckingRect = RectEX.fromLTWH(
          selfBounds.right - rightBottomRadius,
          selfBounds.bottom - rightBottomRadius,
          rightBottomRadius,
          rightBottomRadius);
    }
    //endregion

    var atLeftTopRect = leftTopCheckingRect.contains(relativePoint);
    if(atLeftTopRect && !leftTopSector!.contains(relativePoint))
    {
      // print('相对坐标$pointEX在左上角矩形内部,但不在左上角扇形内部');
      return false;
    }
    var atRightTopRect = rightTopCheckingRect.contains(relativePoint);
    if(atRightTopRect && !rightTopSector!.contains(relativePoint))
    {
      // print('相对坐标$pointEX在右上角矩形内部,但不在右上角扇形内部');
      return false;
    }
    var atLeftBottomRect = leftBottomCheckingRect.contains(relativePoint);
    if(atLeftBottomRect && !leftBottomSector!.contains(relativePoint))
    {
      return false;
    }
    var atRightBottomRect =rightBottomCheckingRect.contains(relativePoint);
    if(atRightBottomRect && !rightBottomSector!.contains(relativePoint))
    {
      return false;
    }
    return true;
  }

  @override
  bool isWorldPointOnEdgeLines(PointEX pointEX, Decimal deviation) {
    //获得相对坐标
    var relativePoint = pointEX - position;
    //如果相对坐标点不在我的自身范围内,则一定不在我的世界范围内
    //使用selfBounds.expand是因为如果是通过外围的大小来检测的话,就没有容差了.
    //如 矩形是 从0,0开始到100,100结束,如果容差是10,那么就是从-10,-10开始到110,110结束
    //如果不进行expand的话,就是从0,0开始到100,100结束,那么就没有容差了.所以鼠标在矩形外围的附近时,检测不到鼠标是否在线上
    if(!selfBounds.expand(deviation).contains(relativePoint))
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