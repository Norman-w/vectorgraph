import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/viewer/painter_of_object/arc_painter.dart';
import '../../model/geometry/lines/arc.dart';
import '../../objects/arc_object.dart';
import '../../space/space.dart';
import '../../utils/num_utils.dart';

class ArcObjectWidget extends ConsumerWidget{
  final ArcObject arcObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;// = Colors.blue;
  const ArcObjectWidget({super.key,
    required this.arcObject,
    required this.viewPortScale,
    required this.viewPortOffset,
    required this.viewPortPixelSize,
    this.normalColor = Colors.black, this.hoverColor = Colors.white, this.focusColor = Colors.lightGreen,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var startPointInView =
    Space.spacePointPos2ViewPortPointPos(arcObject.position, viewPortOffset, viewPortScale, viewPortPixelSize);
    var endPointInView =
    Space.spacePointPos2ViewPortPointPos(arcObject.endPoint, viewPortOffset, viewPortScale, viewPortPixelSize);
    var rectInView = Rect.fromLTWH(
        startPointInView.dx,
        startPointInView.dy,
        (arcObject.rx * viewPortScale).toDouble(),
        (arcObject.ry * viewPortScale).toDouble()
    );

    ArcInfo arcInfo = arcObject.getArcStartAngAndSwAng(0, 0, 100, 0, true, true, 100, 50, 0);
    // var painter = ArcPainter(startPointInView,
    //     rectInView,
    //     0,(decimalPi/Decimal.fromInt(180)*Decimal.fromInt(360)).toDouble(),
    //     true,
    //     Colors.red
    // );
    var a1 = (decimalPi/Decimal.fromInt(180)*Decimal.fromDouble(arcInfo.startAngle)).toDouble();
    var a2 = (decimalPi/Decimal.fromInt(180)*Decimal.fromDouble(arcInfo.sweepAngle)).toDouble();
    var painter = ArcPainter(
        arcInfo.centerPoint + Offset(125,75),
        Rect.fromCenter(center: Offset(125,75), width: 100, height: 50),
        0,
        a2 * 2,
        true,
        Colors.red);

    return CustomPaint(
      painter: painter
    );
  }
}