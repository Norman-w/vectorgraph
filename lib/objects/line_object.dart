import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../model/geometry/lines/line_segment.dart';
import '../viewer/line_painter.dart';
import '../viewer/space.dart';
import 'space_object.dart';
import '../model/geometry/rect/RectEX.dart';

class LineObject extends LineSegment with SpaceObject{
  LineObject(super.start, super.end);

  // RectObject.fromCenter({required super.center, required super.width, required super.height}) : super.fromCenter();
  @override
  RectEX get bounds => getBoundingBox();
  @override
  LineObject copyWith({PointEX? start, PointEX? end}){
    if(start == null || end == null){
      return LineObject(PointEX.zero, PointEX.zero);
    }
    return LineObject(start,end);
  }

  @override
  toString() => 'LineObject{start: $start, end: $end}';
}
class LineObjectNotifier extends StateNotifier<LineObject>{
  bool _isInteractive = false;
  LineObjectNotifier(super.state, this._isInteractive);
  get isInteractive => _isInteractive;
  void updateIsInteractive(bool newIsInteractive){
    _isInteractive = newIsInteractive;
    state = state.copyWith()
      ..isInteractive = newIsInteractive;
  }
}

final lineObjectsProvider =
StateNotifierProvider.family<LineObjectNotifier, LineObject, LineObject>(
        (ref, rect) => LineObjectNotifier(rect, false));

class LineObjectWidget extends ConsumerWidget{
  final LineObject lineObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;// = Colors.blue;
  const LineObjectWidget({super.key,
    required this.lineObject,
    required this.viewPortScale,
    required this.viewPortOffset,
    required this.viewPortPixelSize,
    this.normalColor = Colors.black, this.hoverColor = Colors.white, this.focusColor = Colors.lightGreen,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var startPointInView = Space.spacePointPos2ViewPortPointPos(lineObject.start, viewPortOffset, viewPortScale, viewPortPixelSize);
    var endPointInView = Space.spacePointPos2ViewPortPointPos(lineObject.end, viewPortOffset, viewPortScale, viewPortPixelSize);;
    return CustomPaint(
      painter: LinePainter(startPointInView,endPointInView, ref.watch(lineObjectsProvider(lineObject)).isInteractive?
          // Colors.white: getRandomColor()
        hoverColor:normalColor
      ),
    );
  }
}