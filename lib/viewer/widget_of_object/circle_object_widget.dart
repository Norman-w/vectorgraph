
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../objects/circle_object.dart';
import '../../objects/notifier_and_provider_of_object.dart';
import '../../space/space.dart';
import '../../utils/num_utils.dart';
import '../painter_of_object/circle_painter.dart';

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