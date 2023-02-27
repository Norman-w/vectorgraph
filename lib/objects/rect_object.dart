import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import 'package:vectorgraph/utils/utils.dart';
import 'package:vectorgraph/viewer/rect_painter.dart';

import '../model/geometry/SizeEX.dart';
import '../model/geometry/lines/line_segment.dart';
import 'space_object.dart';
import '../model/geometry/rect/RectEX.dart';

class RectObject extends RectEX with SpaceObject{
  RectObject.fromCenter({required super.center, required super.width, required super.height}) : super.fromCenter();
  RectObject.fromLTWH(Decimal left, Decimal top, Decimal width, Decimal height) : super.fromLTWH(left, top, width, height);
  RectObject.fromPoints(PointEX a, PointEX b) : super.fromPoints(a, b);
  RectObject.fromLTRB(Decimal left, Decimal top, Decimal right, Decimal bottom) : super.fromLTRB(left, top, right, bottom);

  @override
  RectEX get bounds => this;
  List<LineSegment> _lines = [];
  List<LineSegment> get lines {
    if(_lines.isEmpty && !isEmpty){
      //init lines
      var p1 = PointEX(left, top);
      var p2 = PointEX(right, top);
      var p3 = PointEX(right, bottom);
      var p4 = PointEX(left, bottom);
      _lines = [
        LineSegment(p1,p2),
        LineSegment(p2,p3),
        LineSegment(p3,p4),
        LineSegment(p4,p1),
      ];
    }
    return _lines;
  }
  ///检测点是否在矩形的边缘上.
  bool isPointOnSides(PointEX point, {Decimal? deviation}){
    var list = lines;
    for(var l in list){
      if(l.isPointOnLine(point,deviation : deviation?? Decimal.two)) {
        return true;
      }
    }
    return false;
  }
  @override
  RectObject copyWith({PointEX? center, Decimal? width, Decimal? height, Decimal? radius, Decimal? left, Decimal? top, Decimal? right, Decimal? bottom}){
    return RectObject.fromLTWH(left ?? this.left, top ?? this.top, width ?? this.width, height ?? this.height);
  }
}
class RectObjectNotifier extends StateNotifier<RectObject>{
  bool _isInteractive = false;
  RectObjectNotifier(super.state, this._isInteractive);
  get isInteractive => _isInteractive;
  void updateIsInteractive(bool newIsInteractive){
    _isInteractive = newIsInteractive;
    state = state.copyWith()
      ..isInteractive = newIsInteractive;
  }
}

final rectObjectsProvider =
StateNotifierProvider.family<RectObjectNotifier, RectObject, RectObject>(
        (ref, rect) => RectObjectNotifier(rect, false));

class RectObjectWidget extends ConsumerWidget{
  final RectObject rectObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final SizeEX viewPortSize;
  const RectObjectWidget({super.key,
    required this.rectObject,
    required this.viewPortScale,
    required this.viewPortOffset,
    required this.viewPortSize,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var width = rectObject.width;
    var height = rectObject.height;
    var top = rectObject.top;
    var left = rectObject.left;


    var newWidth = width * viewPortScale;
    var newHeight = height * viewPortScale;
    var oldWidth = width;
    var oldHeight = height;
    Decimal xAdded = (newWidth - oldWidth) / Decimal.two;
    Decimal yAdded = (newHeight - oldHeight) / Decimal.two;
    var newLeft = left + viewPortOffset.dx.toDecimal() + viewPortSize.width/Decimal.two - xAdded;
    var newTop = top + viewPortOffset.dy.toDecimal() + viewPortSize.height/Decimal.two -yAdded;
    var realViewRect = RectEX.fromLTWH(
        newLeft,
        newTop,
        newWidth,
        newHeight
    );
    return CustomPaint(
      painter: RectPainter(realViewRect.toRect(), ref.watch(rectObjectsProvider(rectObject)).isInteractive?
          Colors.white: getRandomColor()
      ),
    );
  }
}