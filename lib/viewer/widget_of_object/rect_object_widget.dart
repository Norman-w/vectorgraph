

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/geometry/SizeEX.dart';
import '../../model/geometry/rect/RectEX.dart';
import '../../objects/notifier_and_provider_of_object.dart';
import '../../objects/rect_object.dart';
import '../../utils/num_utils.dart';
import '../painter_of_object/rect_painter.dart';

class RectObjectWidget extends ConsumerWidget{
  final RectObject rectObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;// = Colors.blue;
  const RectObjectWidget({super.key,
    required this.rectObject,
    required this.viewPortScale,
    required this.viewPortOffset,
    required this.viewPortPixelSize,
    this.normalColor = Colors.black, this.hoverColor = Colors.white, this.focusColor = Colors.lightGreen,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var realViewRect = getViewRect(rectObject, viewPortScale, viewPortOffset, viewPortPixelSize);
    var aPlaneObject = ref.watch(planeObjectsProvider(rectObject));
    var color = aPlaneObject.isFocus? focusColor: aPlaneObject.isInteractive? hoverColor: normalColor;
    return CustomPaint(
      painter: RectPainter(realViewRect, color),
    );
  }
  ///获取真实的视图矩形
  ///[rectObject] 矩形对象
  ///[viewPortScale] 视图缩放比例(视图到世界空间的缩放比例)
  ///[viewPortOffset] 视图偏移量
  ///[viewPortSize] 视图大小
  static Rect getViewRect(RectObject rectObject, Decimal viewPortScale, Offset viewPortOffset, Size viewPortSize){
    var width = rectObject.width;
    var height = rectObject.height;
    var top = rectObject.top + rectObject.position.x * viewPortScale;
    var left = rectObject.left + rectObject.position.y * viewPortScale;
    var newWidth = width * viewPortScale;
    var newHeight = height * viewPortScale;
    var oldWidth = width;
    var oldHeight = height;
    Decimal xAdded = (newWidth - oldWidth) / Decimal.two;
    Decimal yAdded = (newHeight - oldHeight) / Decimal.two;
    var viewPortSizeEX = SizeEX(viewPortSize.width.toDecimal(), viewPortSize.height.toDecimal());
    var newLeft = left + viewPortOffset.dx.toDecimal() + viewPortSizeEX.width/Decimal.two - xAdded;
    var newTop = top + viewPortOffset.dy.toDecimal() + viewPortSizeEX.height/Decimal.two -yAdded;
    var realViewRect = RectEX.fromLTWH(
        newLeft,
        newTop,
        newWidth,
        newHeight
    );
    return realViewRect.toRect();
  }
}