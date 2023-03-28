
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../objects/notifier_and_provider_of_object.dart';
import '../../objects/polygon_object.dart';
import '../../space/space.dart';
import '../../utils/num_utils.dart';
import '../painter_of_object/line_painter.dart';

class PolygonObjectWidget extends ConsumerWidget{
  final PolygonObject polygonObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;// = Colors.blue;
  const PolygonObjectWidget({super.key,
    required this.polygonObject,
    required this.viewPortScale,
    required this.viewPortOffset,
    required this.viewPortPixelSize,
    this.normalColor = Colors.black, this.hoverColor = Colors.white, this.focusColor = Colors.lightGreen,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var points = polygonObject.points;
    //convert point ex to offset
    var offsetList = points.map(
            (e) =>
            Space.
            spacePointPos2ViewPortPointPos
              (e + polygonObject.position
                , viewPortOffset, viewPortScale, viewPortPixelSize)
    ).toList();
    if(offsetList.isNotEmpty){
      offsetList.add(offsetList[0]);
    }
    var aPlaneObject = ref.watch(planeObjectsProvider(polygonObject));
    var color = aPlaneObject.isFocus? focusColor: aPlaneObject.isInteractive? hoverColor: normalColor;
    var linesPainter = LinesPainter(offsetList, color);
    return CustomPaint(
      painter: linesPainter,
    );
  }
}