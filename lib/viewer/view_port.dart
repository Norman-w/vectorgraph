import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';


import '../utils/utils.dart';
import 'ruler.dart';
import 'view_state.dart';

class ViewPort extends ConsumerWidget {
  const ViewPort({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        //绘制所有物件(通过物件转换成widget)
        ...ref.watch(viewStateControllerProvider).allObjectInViewPort.map((e) {
          return e.getWidget(
            ref.watch(viewStateControllerProvider).viewPortPixelSize,
            ref.watch(viewStateControllerProvider).currentOffset,
            ref.watch(viewStateControllerProvider).currentScale,
            getRandomColor(),
          );
        }
        ),
        //绘制所有焦点中的物件
        ...ref.watch(viewStateControllerProvider).interactiveObjects.map((e) {
          return e.getWidget(
            ref.watch(viewStateControllerProvider).viewPortPixelSize,
            ref.watch(viewStateControllerProvider).currentOffset,
            ref.watch(viewStateControllerProvider).currentScale,
            Colors.white
          );
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
