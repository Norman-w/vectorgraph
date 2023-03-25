import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/lines/line_segment.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/model/geometry/rect/RectEX.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../model/geometry/planes/polygon.dart';
import '../viewer/line_painter.dart';
import '../space/space.dart';
import 'notifier_and_provider_of_object.dart';
import 'space_object.dart';

class PolygonObject extends Polygon with SpaceObject,APlaneObject{
  final PointEX _position;
  PolygonObject(this._position, List<PointEX> points){
    super.points = points;
  }

  // RectObject.fromCenter({required super.center, required super.width, required super.height}) : super.fromCenter();
  @override
  PolygonObject copyWith(){
      return PolygonObject(_position, points);
  }

  @override
  bool isWorldPointOnEdgeLines(PointEX pointEX, Decimal? deviation){
    //check each line
    return getLineSegments()
        .any(
            (element) =>
            element.isPointOnLine(
              //由于贝塞尔曲线使用的是0点+世界坐标偏移的方式,所以在检测时也要使用这种方式,(减去偏移)
                pointEX - _position
                , deviation: deviation)
    );
  }
  @override
  PointEX get position => _position;

  @override
  RectEX get selfBounds => bounds;

  @override
  RectEX get worldBounds => bounds.shift(_position.x, _position.y);

  @override
  bool isWorldPointIn(PointEX pointEX) {
    return !worldBounds.contains(pointEX)?false:isPointIn(pointEX - position);
  }
}

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
              (e + polygonObject.position
                , viewPortOffset, viewPortScale, viewPortPixelSize)
    ).toList();
    if(offsetList.isNotEmpty){
      offsetList.add(offsetList[0]);
    }
    var aPlaneObject = ref.watch(planeObjectsProvider(polygonObject));
    var color = aPlaneObject.isFocus? focusColor: aPlaneObject.isInteractive? hoverColor: normalColor;
    var linesPainter = LinesPainter(offsetList, color);
    return CustomPaint(
      painter: linesPainter,
    );
  }
}