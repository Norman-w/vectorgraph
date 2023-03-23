import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/lines/line_segment.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/model/geometry/rect/RectEX.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../model/geometry/lines/cross_info.dart';
import '../model/geometry/planes/polygon.dart';
import '../viewer/line_painter.dart';
import '../space/space.dart';
import 'space_object.dart';

///正多角星
class RegularPolygonalStarObject extends Polygon with SpaceObject{
  final PointEX _position;
  final int _stabCount;
  final Decimal _outsideRadius;
  final Decimal? _insideRadius;
  ///构造函数 传入正多角星的所在位置,刺数量(尖儿),外圈直径,内圈直径
  RegularPolygonalStarObject(this._position, this._stabCount, this._outsideRadius, this._insideRadius){
    var points = <PointEX>[];
    //半径
    Decimal outsideR = _outsideRadius / Decimal.two;
    //内圈半径.
    var insideR = _insideRadius == null ? outsideR / Decimal.fromDouble(
        _stabCount == 3?12/3
            :_stabCount == 4?12/4
            :3
    ) : _insideRadius! / Decimal.two;

    //每一条边所分的pi值
    var perDeg = decimalPi / Decimal.fromInt(_stabCount);
    //边数平分360之后的每一条边的角度跨度
    var perSideDeg = 360.0 / _stabCount;
    //1°的π值
    var deg1 = decimalPi / Decimal.halfCircle;
    //回转角度,让第一个点在圆的正上方
    var rotationAngle = ((perSideDeg
    //对单数变和多数边的星形都做一个旋转处理,让第一个点都在正上方
        + (_stabCount.isOdd? 0.5 * perSideDeg : perSideDeg)
    ).toDecimal() -
        Decimal.fromInt(90)) * deg1;
    //⭐️内圈短边的顶点所需要的回转角度
    var rotationAngleInside = ((perSideDeg
        + (_stabCount.isOdd? 0: 0.5 * perSideDeg)
    ).toDecimal() -
        Decimal.fromInt(90)) * deg1;
    var outsidePoints = <PointEX>[];
    var insidePoints = <PointEX>[];
    //创建外围的所有点
    for (int i = 0; i < _stabCount; i++) {
      var di = Decimal.fromInt(i+1) * Decimal.two;
        var outX = outsideR * decimalCos(perDeg * di - rotationAngle);
        var outY = outsideR * decimalSin(perDeg * di - rotationAngle);
        outsidePoints.add(PointEX(outX,outY));
    }
    //region 为了更好得到一个正多角星,我们需要再5个顶点及以上的图形中,计算一个新的内圈半径,让相隔一点的两个顶点之间的连线是直的
    if(_stabCount >4){
      //获取到相隔一点的两个顶点之间的连线
      var line1 = LineSegment(outsidePoints[0], outsidePoints[2]);
      var line2 = LineSegment(outsidePoints[1], outsidePoints[3]);
      //获取相交的交点信息
      CrossInfo crossInfo = getTwoLineSegmentsCrossInfo(line1, line2);
      // print("crossInfo: $crossInfo, 线段1: $line1, 线段2: $line2");
      //如果有交点,获取到交点的距离
      if(crossInfo.isCross && crossInfo.crossPoint != null){
        //获取到交点的距离
        var crossDistance = crossInfo.crossPoint!.distanceTo(PointEX.zero);
        //如果交点的距离小于内圈半径,那么就需要重新计算内圈半径
        insideR = crossDistance;
      }
    }
    //endregion
    //创建内圈的所有点
    for (int i = 0; i < _stabCount; i++) {
      var di = Decimal.fromInt(i+1) * Decimal.two;
      var inX = insideR * decimalCos(perDeg * di - rotationAngleInside);
      var inY = insideR * decimalSin(perDeg * di - rotationAngleInside);
      insidePoints.add(PointEX(inX, inY));
    }
    //将外圈的点和内圈的点交叉组合,得到最终的点集合
    for (int i = 0; i < _stabCount; i++) {
      points.add(outsidePoints[i]);
      points.add(insidePoints[i]);
    }
    //end  close 封闭
    points.add(outsidePoints[0]);
    super.points = points;
  }

  // RectObject.fromCenter({required super.center, required super.width, required super.height}) : super.fromCenter();
  @override
  RegularPolygonalStarObject copyWith(){
      return RegularPolygonalStarObject(_position, _stabCount,_outsideRadius,_insideRadius);
  }

  bool isPointOnEdgeLines(PointEX point, {Decimal? deviation}){
    //check each line
    return getLineSegments()
        .any(
            (element) =>
            element.isPointOnLine(
              //由于贝塞尔曲线使用的是0点+世界坐标偏移的方式,所以在检测时也要使用这种方式,(减去偏移)
                point - _position
                , deviation: deviation)
    );
  }
  @override
  PointEX get position => _position;

  @override
  RectEX get selfBounds => bounds;

  @override
  RectEX get worldBounds => bounds.shift(_position.x, _position.y);
}
class RegularPolygonalStarObjectNotifier extends StateNotifier<RegularPolygonalStarObject>{
  bool _isInteractive = false;
  RegularPolygonalStarObjectNotifier(super.state, this._isInteractive);
  get isInteractive => _isInteractive;
  void updateIsInteractive(bool newIsInteractive){
    _isInteractive = newIsInteractive;
    state = state.copyWith()
      ..isInteractive = newIsInteractive;
  }
}

final regularPolygonalStartsProvider =
StateNotifierProvider.family<RegularPolygonalStarObjectNotifier, RegularPolygonalStarObject, RegularPolygonalStarObject>(
        (ref, rect) => RegularPolygonalStarObjectNotifier(rect, false));

class RegularPolygonalStarWidget extends ConsumerWidget{
  final RegularPolygonalStarObject polygonObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;// = Colors.blue;
  const RegularPolygonalStarWidget({super.key,
    required this.polygonObject,
    required this.viewPortScale,
    required this.viewPortOffset,
    required this.viewPortPixelSize,
    this.normalColor = Colors.black, this.hoverColor = Colors.white, this.focusColor = Colors.lightGreen,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var points = polygonObject.points;
    //convert point ex to offset
    var offsetList = points.map(
            (e) =>
            Space.
            spacePointPos2ViewPortPointPos
              (e + polygonObject.position
                , viewPortOffset, viewPortScale, viewPortPixelSize)
    ).toList();
    if(offsetList.isNotEmpty){
      offsetList.add(offsetList[0]);
    }
    var linesPainter = LinesPainter(offsetList, ref.watch(regularPolygonalStartsProvider(polygonObject)).isInteractive?
    hoverColor:normalColor
    );
    return CustomPaint(
      painter: linesPainter,
    );
  }
}