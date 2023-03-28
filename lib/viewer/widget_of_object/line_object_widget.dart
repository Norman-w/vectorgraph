

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../objects/line_object.dart';
import '../../objects/notifier_and_provider_of_object.dart';
import '../../space/space.dart';
import '../../utils/num_utils.dart';
import '../painter_of_object/line_painter.dart';

class LineObjectWidget extends ConsumerWidget{
  final LineObject lineObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;// = Colors.blue;
  const LineObjectWidget({super.key,
    required this.lineObject,
    required this.viewPortScale,
    required this.viewPortOffset,
    required this.viewPortPixelSize,
    this.normalColor = Colors.black, this.hoverColor = Colors.white, this.focusColor = Colors.lightGreen,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var startPointInView =
    Space.spacePointPos2ViewPortPointPos(lineObject.start, viewPortOffset, viewPortScale, viewPortPixelSize);
    var endPointInView =
    Space.spacePointPos2ViewPortPointPos(lineObject.end, viewPortOffset, viewPortScale, viewPortPixelSize);
    return CustomPaint(
      painter: LinePainter(startPointInView,endPointInView, ref.watch(lineObjectsProvider(lineObject)).isInteractive?
      // Colors.white: getRandomColor()
      hoverColor:normalColor
      ),
    );
  }
}