import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/viewer/painter_of_object/arc_painter.dart';
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
    return CustomPaint(
      painter: ArcPainter(startPointInView,
          rectInView,
          0,(decimalPi/Decimal.fromInt(180)*Decimal.fromInt(360)).toDouble(),
          true,
          Colors.red
      ),
    );
  }
}