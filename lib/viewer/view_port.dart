import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:vectorgraph/model/geometry/rect/RectEX.dart';
import 'package:vectorgraph/objects/rect_object.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import 'package:vectorgraph/utils/utils.dart';


import '../model/geometry/SizeEX.dart';
import '../model/geometry/points/point_ex.dart';
import 'rect_painter.dart';
import 'ruler.dart';
import 'view_state.dart';

class ViewPort extends ConsumerWidget {
  const ViewPort({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    var state = ref.watch(viewStateProvider);
    var center = (-PointEX.fromOffset(state.currentOffset) / state.currentScale).toOffset();
    var width = state.validViewPortSizeOfSpace.width.toDouble();
    var height = state.validViewPortSizeOfSpace.height.toDouble();
    Rect rulerRect = Rect.fromCenter(center: center, width: width, height: height);
    return Stack(
      children: [
        //绘制所有物件(通过物件转换成widget)
        ...ref.watch(viewStateProvider).allObjectInViewPort.map((e) {
          if(e.runtimeType == RectObject){
            var rect = e as RectObject;
            return RectObjectWidget(rectObject: rect,
              viewPortPixelSize: ref.watch(viewStateProvider).viewPortPixelSize,
              viewPortOffset: ref.watch(viewStateProvider).currentOffset,
              viewPortScale: ref.watch(viewStateProvider).currentScale,
            );
          }
          return Container();
        }
        ),
        SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Ruler(
                rulerRect
            )
        ),
      ],
    );
  }
}
