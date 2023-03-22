import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/lines/line_segment.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/model/geometry/rect/RectEX.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../model/geometry/planes/polygon.dart';
import '../viewer/line_painter.dart';
import '../space/space.dart';
import 'space_object.dart';

///正多角星
class RegularPolygonalStarObject extends Polygon with SpaceObject{
  final PointEX _position;
  final int _stabCount;
  final Decimal _outsideRadius;
  final Decimal _insideRadius;
  ///构造函数 传入正多角星的所在位置,刺数量(尖儿),外圈直径,内圈直径
  RegularPolygonalStarObject(this._position, this._stabCount, this._outsideRadius, this._insideRadius){
    var points = <PointEX>[];
    //半径
    Decimal outside_r = _outsideRadius / Decimal.two;
    Decimal inside_r = _insideRadius / Decimal.two;
    //每一条边所分的pi值
    var perDeg = decimalPi / Decimal.fromInt(_stabCount);
    //边数平分360之后的每一条边的角度跨度
    var perSideDeg = 360.0 / _stabCount;
    //1°的π值
    var deg1 = decimalPi / Decimal.halfCircle;
    //回转角度,让第一个点在圆的正上方
    var rotationAngle = ((perSideDeg + perSideDeg).toDecimal() -
        Decimal.fromInt(90)) * deg1;
    //⭐️内圈短边的顶点所需要的回转角度
    var rotationAngleInside = ((perSideDeg + 0.5* perSideDeg).toDecimal() -
        Decimal.fromInt(90)) * deg1;
    //第一个点,为了看起来更好看.我们默认让第一个点在圆的正上方,但是比如说我们要画一个三角形,那么第一个点就不是在正上方了
    //所以我们要把角度再往前移动一个角度,比如3个顶点的,第一个顶点在旋转120度的地方
    var firstOutsideX = outside_r * decimalCos(perDeg - rotationAngle);
    var firstOutsideY = outside_r * decimalSin(perDeg - rotationAngle);

    //内圈第一个点
    var firstInsideX = inside_r * decimalCos(perDeg - rotationAngleInside);
    var firstInsideY = inside_r * decimalSin(perDeg - rotationAngleInside);
    //start 开始
    points.add(PointEX(firstOutsideX,firstOutsideY));
    //连到内层第一个点上
    points.add(PointEX(firstInsideX, firstInsideY));
    //创建每一个外面和里面要链接的点并链接上
    for (int i = 2; i <= _stabCount * 2; i++) {
      var di = Decimal.fromInt(i);
      if (i.isOdd) {
        var outX = outside_r * decimalCos(perDeg * di - rotationAngle);
        var outY = outside_r * decimalSin(perDeg * di - rotationAngle);
        //line to /link to 链接到
        points.add(PointEX(outX,outY));

        var inX = inside_r * decimalCos(perDeg * di - rotationAngleInside);
        var inY = inside_r * decimalSin(perDeg * di - rotationAngleInside);
        points.add(PointEX(inX, inY));
      }
    }
    //end  close 封闭
    points.add(PointEX(firstOutsideX,firstOutsideY));

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