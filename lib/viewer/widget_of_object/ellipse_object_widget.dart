
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../objects/ellipse_object.dart';
import '../../objects/notifier_and_provider_of_object.dart';
import '../../space/space.dart';
import '../../utils/num_utils.dart';
import '../painter_of_object/ellipse_painter.dart';

class EllipseObjectWidget extends ConsumerWidget{
  final EllipseObject ellipseObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;// = Colors.blue;
  const EllipseObjectWidget({super.key,
    required this.ellipseObject,
    required this.viewPortScale,
    required this.viewPortOffset,
    required this.viewPortPixelSize,
    this.normalColor = Colors.black, this.hoverColor = Colors.white, this.focusColor = Colors.lightGreen,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var aPlaneObject = ref.watch(planeObjectsProvider(ellipseObject));
    var color = aPlaneObject.isFocus? focusColor: aPlaneObject.isInteractive? hoverColor: normalColor;
    var viewOffset = Space.
    spacePointPos2ViewPortPointPos
      (aPlaneObject.position , viewPortOffset, viewPortScale, viewPortPixelSize);
    var ellipsePainter = EllipsePainter(
      viewOffset,
      (ellipseObject.radiusX * viewPortScale).toDouble(),
      (ellipseObject.radiusY * viewPortScale).toDouble(),
      color, 2,);
    return CustomPaint(
      painter: ellipsePainter,
    );
  }
}