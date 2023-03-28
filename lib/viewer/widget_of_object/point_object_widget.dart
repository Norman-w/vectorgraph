
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../objects/notifier_and_provider_of_object.dart';
import '../../objects/point_object.dart';
import '../../space/space.dart';
import '../../utils/num_utils.dart';
import '../painter_of_object/points_painter.dart';

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