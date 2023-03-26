import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/model/geometry/rect/RectEX.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import 'package:vectorgraph/viewer/circle_painter.dart';
import '../model/geometry/planes/circle.dart';
import '../space/space.dart';
import 'notifier_and_provider_of_object.dart';
import 'space_object.dart';

class CircleObject extends Circle with SpaceObject,APlaneObject{
  final PointEX _position;
  CircleObject(this._position, Decimal radius) {
    super.radius = radius;
  }
  @override
  CircleObject copyWith(){
    return CircleObject(_position, radius);
  }

  @override
  bool isWorldPointOnEdgeLines(PointEX pointEX, Decimal deviation){
    var distance = _position.distanceTo(pointEX);
    var newIsInteractive = (distance - radius).abs() < deviation;
    return newIsInteractive;
  }
  @override
  PointEX get position => _position;

  @override
  RectEX get selfBounds => bounds;

  @override
  RectEX get worldBounds => bounds.shift(_position.x, _position.y);

  @override
  bool isWorldPointIn(PointEX pointEX) {
    return !worldBounds.contains(pointEX)?false:isPointIn(pointEX - position, Decimal.one);
  }

  bool isPointIn(PointEX pointEX, Decimal deviation){
    var distance = _position.distanceTo(pointEX);
    var newIsInteractive = distance < radius;
    return newIsInteractive;
  }
}

class CircleObjectWidget extends ConsumerWidget{
  final CircleObject circleObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;// = Colors.blue;
  const CircleObjectWidget({super.key,
    required this.circleObject,
    required this.viewPortScale,
    required this.viewPortOffset,
    required this.viewPortPixelSize,
    this.normalColor = Colors.black, this.hoverColor = Colors.white, this.focusColor = Colors.lightGreen,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var aPlaneObject = ref.watch(planeObjectsProvider(circleObject));
    var color = aPlaneObject.isFocus? focusColor: aPlaneObject.isInteractive? hoverColor: normalColor;
    var viewOffset = Space.
    spacePointPos2ViewPortPointPos
      (aPlaneObject.position , viewPortOffset, viewPortScale, viewPortPixelSize);
    var circlePainter = CirclePainter(
      viewOffset,
      (circleObject.radius * viewPortScale).toDouble(),
      color, 2,);
    return CustomPaint(
      painter: circlePainter,
    );
  }
}