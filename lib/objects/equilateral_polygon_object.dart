import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/lines/line_segment.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../model/geometry/planes/equilateral_polygon.dart';
import '../viewer/line_painter.dart';
import '../viewer/space.dart';
import 'space_object.dart';

class EquilateralPolygonObject extends EquilateralPolygon with SpaceObject {
  EquilateralPolygonObject(this.position, {super.size, super.count});

  PointEX position;
  // RectObject.fromCenter({required super.center, required super.width, required super.height}) : super.fromCenter();
  @override
  EquilateralPolygonObject copyWith({PointEX? position, Decimal? size, int? sideCount}) {
    return EquilateralPolygonObject(position?? PointEX.zero, size:size, count:sideCount??3);
  }

  bool isPointOnEdgeLines(PointEX point, {Decimal? deviation}) {
    //check each line
    return getLineSegments()
        .any(
            (element) =>
            element.isPointOnLine(
              //由于贝塞尔曲线使用的是0点+世界坐标偏移的方式,所以在检测时也要使用这种方式,(减去偏移)
                point - position
                , deviation: deviation)
    );
  }
}
class EquilateralPolygonObjectNotifier extends StateNotifier<EquilateralPolygonObject>{
  bool _isInteractive = false;
  EquilateralPolygonObjectNotifier(super.state, this._isInteractive);
  get isInteractive => _isInteractive;
  void updateIsInteractive(bool newIsInteractive){
    _isInteractive = newIsInteractive;
    state = state.copyWith()
      ..isInteractive = newIsInteractive;
  }
}

final equilateralPolygonObjectsProvider =
StateNotifierProvider.family<EquilateralPolygonObjectNotifier, EquilateralPolygonObject, EquilateralPolygonObject>(
        (ref, rect) => EquilateralPolygonObjectNotifier(rect, false));

class EquilateralPolygonObjectWidget extends ConsumerWidget{
  final EquilateralPolygonObject equilateralPolygonObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;// = Colors.blue;
  const EquilateralPolygonObjectWidget({super.key,
    required this.equilateralPolygonObject,
    required this.viewPortScale,
    required this.viewPortOffset,
    required this.viewPortPixelSize,
    this.normalColor = Colors.black, this.hoverColor = Colors.white, this.focusColor = Colors.lightGreen,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var points = equilateralPolygonObject.points;
    //convert point ex to offset
    var offsetList = points.map(
            (e) =>
            Space.
            spacePointPos2ViewPortPointPos
              (e + equilateralPolygonObject.position
                , viewPortOffset, viewPortScale, viewPortPixelSize)
    ).toList();
    var linesPainter = LinesPainter(offsetList, ref.watch(equilateralPolygonObjectsProvider(equilateralPolygonObject)).isInteractive?
    hoverColor:normalColor
    );
    return CustomPaint(
      painter: linesPainter,
    );
  }
}