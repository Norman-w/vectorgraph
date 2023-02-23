import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:vectorgraph/objects/rect_object.dart';
import 'package:vectorgraph/utils/utils.dart';


import 'rect_painter.dart';
import 'ruler.dart';
import 'view_state.dart';

class ViewPort extends ConsumerWidget {
  const ViewPort({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        //绘制所有物件(通过物件转换成widget)
        ...ref.watch(viewStateProvider).allObjectInViewPort.map((e) {
          if(e.runtimeType == RectObject){
            var rect = e as RectObject;
            return RectObjectWidget(rectObject: rect,
              viewPortSize: ref.watch(viewStateProvider).viewPortPixelSize,
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
              ref.watch(viewStateProvider).rulerRectFromCenter
            )
        ),
      ],
    );
  }
}
