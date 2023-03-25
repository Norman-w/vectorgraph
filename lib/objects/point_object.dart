import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/geometry/rect/RectEX.dart';
import '../model/geometry/points/point_ex.dart';
import '../utils/num_utils.dart';
import '../viewer/points_painter.dart';
import '../space/space.dart';
import 'notifier_and_provider_of_object.dart';
import 'space_object.dart';

class PointObject extends PointEX with SpaceObject,APointObject{
  late Decimal radius;
  PointObject(super.x, super.y, {Decimal? radius}){
    this.radius = radius ?? Decimal.fromInt(1);
  }
  @override
  PointObject copyWith(){
    return PointObject(x, y, radius:radius);
  }

  @override
  PointEX get position => PointEX(x, y);

  @override
  RectEX get selfBounds => RectEX.fromCircle(center: PointEX.zero, radius: radius);

  @override
  RectEX get worldBounds => RectEX.fromCircle(center: PointEX(x, y), radius: radius);

  @override
  bool isPointOn(PointEX pointEX, Decimal deviation) {
    var distance = distanceTo(pointEX);
    var newIsInteractive = distance < radius/Decimal.two + deviation;
    return newIsInteractive;
  }
}

class PointObjectWidget extends ConsumerWidget{
  final PointObject pointObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;// = Colors.blue;
  const PointObjectWidget(
  {
    required this.pointObject,
    required this.viewPortScale,
    required this.viewPortOffset,
    required this.viewPortPixelSize,
    this.normalColor = Colors.black, this.hoverColor = Colors.white, this.focusColor = Colors.lightGreen,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color color = ref.watch(pointObjectsProvider(pointObject)).isInteractive?
        // Colors.white: getRandomColor();
    hoverColor:normalColor;
    Offset point = Space.spacePointPos2ViewPortPointPos(
        pointObject, viewPortOffset,viewPortScale, viewPortPixelSize);
    var newRadius = pointObject.radius * viewPortScale;
    return CustomPaint(
      painter: PointPainter(point, color, newRadius.toDouble()),
    );
  }
}