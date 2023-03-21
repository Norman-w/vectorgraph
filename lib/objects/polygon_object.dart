import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/lines/line_segment.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/model/geometry/rect/RectEX.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../model/geometry/planes/polygon.dart';
import '../viewer/line_painter.dart';
import '../viewer/space.dart';
import 'space_object.dart';

class PolygonObject extends Polygon with SpaceObject{
  PolygonObject(super.points);

  // RectObject.fromCenter({required super.center, required super.width, required super.height}) : super.fromCenter();
  @override
  PolygonObject copyWith({List<PointEX>? points}){
    if(points == null){
      return PolygonObject([]);
    }
    return PolygonObject(points);
  }

  bool isPointOnEdgeLines(PointEX point, {Decimal? deviation}){
    //check each line
    return getLineSegments()
        .any(
            (element) =>
            element.isPointOnLine(
              //由于贝塞尔曲线使用的是0点+世界坐标偏移的方式,所以在检测时也要使用这种方式,(减去偏移)
                point, deviation: deviation)
    );
  }
}
class PolygonObjectNotifier extends StateNotifier<PolygonObject>{
  bool _isInteractive = false;
  PolygonObjectNotifier(super.state, this._isInteractive);
  get isInteractive => _isInteractive;
  void updateIsInteractive(bool newIsInteractive){
    _isInteractive = newIsInteractive;
    state = state.copyWith()
      ..isInteractive = newIsInteractive;
  }
}

final polygonObjectsProvider =
StateNotifierProvider.family<PolygonObjectNotifier, PolygonObject, PolygonObject>(
        (ref, rect) => PolygonObjectNotifier(rect, false));

class PolygonObjectWidget extends ConsumerWidget{
  final PolygonObject polygonObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;// = Colors.blue;
  const PolygonObjectWidget({super.key,
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
              (e, viewPortOffset, viewPortScale, viewPortPixelSize)
    ).toList();
    if(offsetList.isNotEmpty){
      offsetList.add(offsetList[0]);
    }
    var linesPainter = LinesPainter(offsetList, ref.watch(polygonObjectsProvider(polygonObject)).isInteractive?
    hoverColor:normalColor
    );
    return CustomPaint(
      painter: linesPainter,
    );
  }
}