import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/model/geometry/rect/RectEX.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../model/geometry/lines/bezier.dart';
import '../model/geometry/lines/line_segment.dart';
import '../viewer/line_painter.dart';
import '../viewer/space.dart';
import 'space_object.dart';

class BezierObject extends Bezier with SpaceObject{
  BezierObject(super.position, super.end);

  // RectObject.fromCenter({required super.center, required super.width, required super.height}) : super.fromCenter();
  @override
  ///构造函数,给定的参数是贝塞尔曲线的所在位置 也就是起点,和终点 也就是连接的目标的位置
  BezierObject copyWith({PointEX? position, PointEX? end}){
    return BezierObject(position ?? this.position, end ?? this.end);
  }

  bool isPointOnLine(PointEX point, {Decimal? deviation}){
    //check each line
    return toLineSegments()
        .any(
            (element) =>
                element.isPointOnLine(
                  //由于贝塞尔曲线使用的是0点+世界坐标偏移的方式,所以在检测时也要使用这种方式,(减去偏移)
                    point - position, deviation: deviation)
    );
  }

  @override
  toString() => 'BezierObject{start: $position, end: $end}';

  @override
  RectEX get selfBounds => bounds.shift(-position.x, -position.y);

  @override
  RectEX get worldBounds => bounds;
}
class BezierObjectNotifier extends StateNotifier<BezierObject>{
  bool _isInteractive = false;
  BezierObjectNotifier(super.state, this._isInteractive);
  get isInteractive => _isInteractive;
  void updateIsInteractive(bool newIsInteractive){
    _isInteractive = newIsInteractive;
    state = state.copyWith()
      ..isInteractive = newIsInteractive;
  }
}

final bezierObjectsProvider =
StateNotifierProvider.family<BezierObjectNotifier, BezierObject, BezierObject>(
        (ref, rect) => BezierObjectNotifier(rect, false));

class BezierObjectWidget extends ConsumerWidget{
  final BezierObject bezierObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;// = Colors.blue;
  const BezierObjectWidget({super.key,
    required this.bezierObject,
    required this.viewPortScale,
    required this.viewPortOffset,
    required this.viewPortPixelSize,
    this.normalColor = Colors.black, this.hoverColor = Colors.white, this.focusColor = Colors.lightGreen,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var points = bezierObject.bezierPoints;
    //convert point ex to offset
    var offsetList = points.map(
            (e) =>
                Space.
                spacePointPos2ViewPortPointPos
                  (e + bezierObject.position , viewPortOffset, viewPortScale, viewPortPixelSize)
                //哈哈 像不像3D效果
                // +viewPortOffset
    ).toList();
    var linesPainter = LinesPainter(offsetList, ref.watch(bezierObjectsProvider(bezierObject)).isInteractive?
    hoverColor:normalColor
    );
    return CustomPaint(
      painter: linesPainter,
    );
  }
}