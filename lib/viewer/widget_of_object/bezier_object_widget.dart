import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../objects/bezier_object.dart';
import '../../objects/notifier_and_provider_of_object.dart';
import '../../space/space.dart';
import '../../utils/num_utils.dart';
import '../painter_of_object/line_painter.dart';

class BezierObjectWidget extends ConsumerWidget{
  final BezierObject bezierObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;// = Colors.blue;
  const BezierObjectWidget({super.key,
    required this.bezierObject,
    required this.viewPortScale,
    required this.viewPortOffset,
    required this.viewPortPixelSize,
    this.normalColor = Colors.black, this.hoverColor = Colors.white, this.focusColor = Colors.lightGreen,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var points = bezierObject.bezierPoints;
    //convert point ex to offset
    var offsetList = points.map(
            (e) =>
            Space.
            spacePointPos2ViewPortPointPos
              (e + bezierObject.position , viewPortOffset, viewPortScale, viewPortPixelSize)
      //哈哈 像不像3D效果
      // +viewPortOffset
    ).toList();
    var linesPainter = LinesPainter(offsetList, ref.watch(lineObjectsProvider(bezierObject)).isInteractive?
    hoverColor:normalColor
    );
    return CustomPaint(
      painter: linesPainter,
    );
  }
}