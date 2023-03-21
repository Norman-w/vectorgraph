import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:vectorgraph/objects/point_object.dart';
import 'package:vectorgraph/objects/rect_object.dart';


import '../model/geometry/points/point_ex.dart';
import '../objects/line_object.dart';
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
          else if(e.runtimeType == PointObject){
            PointObject point = e as PointObject;
            return PointObjectWidget(pointObject: point,
              viewPortPixelSize: ref.watch(viewStateProvider).viewPortPixelSize,
              viewPortOffset: ref.watch(viewStateProvider).currentOffset,
              viewPortScale: ref.watch(viewStateProvider).currentScale,
              // normalColor: Colors.deepOrange,
            );
          }
          else if(e.runtimeType == LineObject){
            LineObject line = e as LineObject;
            return LineObjectWidget(lineObject: line,
              viewPortPixelSize: ref.watch(viewStateProvider).viewPortPixelSize,
              viewPortOffset: ref.watch(viewStateProvider).currentOffset,
              viewPortScale: ref.watch(viewStateProvider).currentScale,
              // normalColor: Colors.deepOrange,
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
