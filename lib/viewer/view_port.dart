import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';


import '../utils/utils.dart';
import 'ruler.dart';
import 'view_state.dart';

class ViewPort extends ConsumerWidget {
  const ViewPort({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var viewState = ref.watch(viewStateControllerProvider);
    var allObjectInViewPort = viewState.allObjectInViewPort;
    var viewPortPixelSize = viewState.viewPortPixelSize;
    var currentOffset = viewState.currentOffset;
    var currentScale = viewState.currentScale;
    return Stack(
      children: [
        //绘制所有物件(通过物件转换成widget)
        ...allObjectInViewPort.map((e) {
          return e.getWidget(
            viewPortPixelSize, currentOffset, currentScale,
            // Colors.red
            getRandomColor(),
          );
        }
        ),
        //region 在视口中显示临时检测图形和log文字等
        SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Ruler(
              ref.watch(viewStateControllerProvider).rulerRectFromCenter
            )
        ),
        // Transform.translate(offset: const Offset(
        //     50, 50),
        //     child: Text(logText)
        // ),
        // Transform.translate(offset: const Offset(
        //     50, 80),
        //     child: Text(logText2)
        // ),
        //endregion
      ],
    );
  }
}
