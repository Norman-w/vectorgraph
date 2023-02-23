import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:vectorgraph/objects/rect_object.dart';
import 'package:vectorgraph/utils/utils.dart';


import 'rect_painter.dart';
import 'ruler.dart';
import 'view_state.dart';

Widget getWidget4RectObject(
    RectObject rect,
    Size viewPortSize,
    Offset viewPortOffset,
    double viewPortScale,
    Color color) {
  var width = rect.width;
  var height = rect.height;
  var top = rect.top;
  var left = rect.left;


  var newWidth = width * viewPortScale;
  var newHeight = height * viewPortScale;
  var oldWidth = width;
  var oldHeight = height;
  var xAdded = (newWidth - oldWidth) / 2;
  var yAdded = (newHeight - oldHeight) / 2;
  var newLeft = left + viewPortOffset.dx + viewPortSize.width/2 - xAdded;
  var newTop = top + viewPortOffset.dy + viewPortSize.height/2  -yAdded;
  var realViewRect = Rect.fromLTWH(
      newLeft,
      newTop,
      newWidth,
      newHeight
  );
  return CustomPaint(
    painter: RectPainter(realViewRect, color),
  );
}
class ViewPort extends ConsumerWidget {
  const ViewPort({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        //绘制所有物件(通过物件转换成widget)
        ...ref.watch(viewStateControllerProvider).allObjectInViewPort.map((e) {
          if(e.runtimeType == RectObject){
            var rect = e as RectObject;
            return getWidget4RectObject(rect,
              ref.watch(viewStateControllerProvider).viewPortPixelSize,
              ref.watch(viewStateControllerProvider).currentOffset,
              ref.watch(viewStateControllerProvider).currentScale,
              rect.isInteractive? Colors.white:getRandomColor(),
            );
          }
          return Container();
        }
        ),
        SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Ruler(
              ref.watch(viewStateControllerProvider).rulerRectFromCenter
            )
        ),
      ],
    );
  }
}
