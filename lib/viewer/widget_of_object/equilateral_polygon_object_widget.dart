

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../objects/equilateral_polygon_object.dart';
import '../../objects/notifier_and_provider_of_object.dart';
import '../../space/space.dart';
import '../../utils/num_utils.dart';
import '../painter_of_object/line_painter.dart';

class EquilateralPolygonObjectWidget extends ConsumerWidget{
  final EquilateralPolygonObject equilateralPolygonObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;// = Colors.blue;
  const EquilateralPolygonObjectWidget({super.key,
    required this.equilateralPolygonObject,
    required this.viewPortScale,
    required this.viewPortOffset,
    required this.viewPortPixelSize,
    this.normalColor = Colors.black, this.hoverColor = Colors.white, this.focusColor = Colors.lightGreen,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var points = equilateralPolygonObject.points;
    //convert point ex to offset
    var offsetList = points.map(
            (e) =>
            Space.
            spacePointPos2ViewPortPointPos
              (e + equilateralPolygonObject.position
                , viewPortOffset, viewPortScale, viewPortPixelSize)
    ).toList();
    var aPlaneObject = ref.watch(planeObjectsProvider(equilateralPolygonObject));
    var color = aPlaneObject.isFocus? focusColor: aPlaneObject.isInteractive? hoverColor: normalColor;
    var linesPainter = LinesPainter(offsetList,color);
    return CustomPaint(
      painter: linesPainter,
    );
  }
}