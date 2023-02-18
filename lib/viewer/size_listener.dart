/// 当组件的尺寸变化时(比如Stack尺寸变化了上面的可拖动组件可能就显示不到的了)
///
///
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

/// size nullable
typedef OnWidgetSizeChange = void Function(Size size);

class SizeListenerRenderObject extends RenderProxyBox {
  Size oldSize = Size.zero;
  final OnWidgetSizeChange onWidgetSizeChange;

  SizeListenerRenderObject(this.onWidgetSizeChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child?.size??Size.zero;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onWidgetSizeChange(newSize);
    });
  }
}
//原来叫MeasureSize
class SizeListener extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onWidgetSizeChange;

  const SizeListener(
       {
         required Widget child,
         required this.onWidgetSizeChange,
        Key? key,
      }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SizeListenerRenderObject(onWidgetSizeChange);
  }
}
