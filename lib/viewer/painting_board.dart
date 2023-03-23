/// view port 相当于是显示器，显示器的大小是固定的，但是显示器上的内容是可以变化的。
/// 例如，显示器的大小是 800*600，但是显示器上的内容可以是 400*300，也可以是 800*600，也可以是 1600*1200。
///
/// painting board 相当于是画板，画板的大小也是可以变化的.这个大小和view port是一样的.
///
/// 可以理解为，view port是显示器，painting board是显示器上的一层支持笔和鼠标以及触摸的绘图板,在这个绘图板上作画会实时显示在显示器上。
///
/// 如果当前的缩放倍数是2,显示器和绘图板的大小都是800x600, 那么绘图板上的内容就是400x300.
/// 在绘图板上绘制一个100x100像素的矩形,那么实际上在世界空间中,这个矩形的大小就是50x50像素.
///
/// 相较于视口(显示器,显示区域),绘图板(绘画板,触摸屏,绘图屏)是距离用户更近的一层.但他是透明的.

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/lines/line_segment.dart';
import 'package:vectorgraph/objects/equilateral_polygon_object.dart';
import 'package:vectorgraph/objects/line_object.dart';
import 'package:vectorgraph/objects/polygon_object.dart';
import 'package:vectorgraph/objects/regular_polygonal_star.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import 'package:vectorgraph/utils/widget.dart';

import '../model/geometry/points/point_ex.dart';
import '../objects/bezier_object.dart';
import '../objects/point_object.dart';
import '../objects/rect_object.dart';
import 'size_listener.dart';
import '../space/space.dart';
import '../view_state.dart';
class PaintingBoard extends ConsumerStatefulWidget {
  const PaintingBoard({super.key});
  @override
  createState() => _PaintingBoardState();
}

Size? currentContextSize;


class _PaintingBoardState extends ConsumerState<PaintingBoard> with SingleTickerProviderStateMixin {
  Decimal? panScaleStart ;
  //视口的当前使用偏移量
  // Offset currentOffset = Offset.zero;
  //测试用日志文本1
  String logText = 'This is log text 1';
  //测试用日志文本2
  String logText2 = 'This is log text 2';
  //鼠标点击的位置
  Offset? mouseDownPosition;
  //鼠标移动到的目标位置
  Offset? mouseMoveToPosition;
  //支持反向鼠标滚轮
  bool reverseMouseWheel = false;

  //region 鼠标和触摸板事件
  onHoverMouseRegion(PointerHoverEvent event) {
    //鼠标移动检测鼠标焦点上的物件
    // ref.read(viewStateProvider.notifier).updateInteractiveObjects(event.position);
    var state = ref.watch(viewStateProvider);
    PointEX worldPoint = event.position.toPointEX() / state.currentScale
        - PointEX(state.validViewPortSizeOfSpace.width / Decimal.two, state.validViewPortSizeOfSpace.height / Decimal.two)
        - state.currentOffset.toPointEX()/state.currentScale;

    for (var element in state.allObjectInViewPort) {
      var deviation = Decimal.fromInt(2)/state.currentScale.abs();
        switch(element.runtimeType){
          case RectObject:
            var rect = element as RectObject;
            var oldIsInteractive = rect.isInteractive;
            var newIsInteractive = rect.isPointOnEdgeLines(worldPoint, deviation);
            if(oldIsInteractive != newIsInteractive)
              {
                rect.isInteractive = newIsInteractive;
                ref.read(rectObjectsProvider(rect).notifier).updateIsInteractive(newIsInteractive);
                if(newIsInteractive)
                  {
                    // print('on it');
                  }
              }
            break;
          case LineObject:
            var line = element as LineObject;
            var oldIsInteractive = line.isInteractive;
            var newIsInteractive = line.isPointOnLine(worldPoint, deviation:deviation);
            if(oldIsInteractive != newIsInteractive)
            {
              line.isInteractive = newIsInteractive;
              ref.read(lineObjectsProvider(line).notifier).updateIsInteractive(newIsInteractive);
              if(newIsInteractive)
              {
                // print('on it');
              }
            }
            break;
          case BezierObject:
            var bezier = element as BezierObject;
            var oldIsInteractive = bezier.isInteractive;
            var newIsInteractive = bezier.isPointOnLine(worldPoint, deviation:deviation);
            if(oldIsInteractive != newIsInteractive)
            {
              bezier.isInteractive = newIsInteractive;
              ref.read(bezierObjectsProvider(bezier).notifier).updateIsInteractive(newIsInteractive);
              if(newIsInteractive)
              {
                // print('on it');
              }
            }
            break;
          case EquilateralPolygonObject:
            var ePolygon = element as EquilateralPolygonObject;
            var oldIsInteractive = ePolygon.isInteractive;
            var newIsInteractive = ePolygon.isPointOnEdgeLines(worldPoint, deviation:deviation);
            if(oldIsInteractive != newIsInteractive)
            {
              ePolygon.isInteractive = newIsInteractive;
              ref.read(equilateralPolygonObjectsProvider(ePolygon).notifier).updateIsInteractive(newIsInteractive);
              if(newIsInteractive)
              {
                // print('on it');
              }
            }
            break;
          case PolygonObject:
            var polygon = element as PolygonObject;
            var oldIsInteractive = polygon.isInteractive;
            var newIsInteractive = polygon.isPointOnEdgeLines(worldPoint, deviation:deviation);
            if(oldIsInteractive != newIsInteractive)
            {
              polygon.isInteractive = newIsInteractive;
              ref.read(polygonObjectsProvider(polygon).notifier).updateIsInteractive(newIsInteractive);
              if(newIsInteractive)
              {
                // print('on it');
              }
            }
            break;
          case RegularPolygonalStarObject:
            var star = element as RegularPolygonalStarObject;
            var oldIsInteractive = star.isInteractive;
            var newIsInteractive = star.isPointOnEdgeLines(worldPoint, deviation:deviation);
            if(oldIsInteractive != newIsInteractive)
            {
              star.isInteractive = newIsInteractive;
              ref.read(regularPolygonalStartsProvider(star).notifier).updateIsInteractive(newIsInteractive);
              if(newIsInteractive)
              {
                // print('on it');
              }
            }
            break;
          case PointObject:
            var point = element as PointObject;
            var oldIsInteractive = point.isInteractive;
            var distanceToCursor = point.distanceTo(worldPoint);
            bool newIsInteractive = distanceToCursor < point.radius/Decimal.two + deviation;
            if(oldIsInteractive != newIsInteractive)
              {
                point.isInteractive = newIsInteractive;
                ref.read(pointObjectsProvider(point).notifier).updateIsInteractive(newIsInteractive);
                if(newIsInteractive)
                  {
                    // print('on it');
                  }
              }
            break;
        }
    }
    setState(() {
      logText = '世界坐标$worldPoint   视图坐标${event.position}';
      logText2 = '视图坐标${event.position}';
    });
  }


  onPointerDown(event) {
    if (event.buttons == 2) {
      setState(() {
        mouseDownPosition = event.position;
        // logText = '鼠标按下 ${event.position}';
      });
    }
    else if(event.buttons == 1){
      setState(() {
        mouseDownPosition = event.position;
        logText = '鼠标左键按下 ${event.position}';
      });
    }
  }

  onPointerMove(PointerMoveEvent event) {
    if (event.buttons == 2) {
      setState(() {
        mouseDownPosition = event.position;
        logText = '右键按下,鼠标所在位置 ${event.position}';
      });
      var oldOffset = ref.watch(viewStateProvider).currentOffset;
      ref.read(viewStateProvider.notifier).currentOffset = oldOffset.translate(event.delta.dx, event.delta.dy);

      //更新坐标检测鼠标焦点上的物件
      // ref.read(viewStateProvider.notifier).updateInteractiveObjects(event.position);
    }
    else if(event.buttons == 1){
      var viewState = ref.read(viewStateProvider);
      setState(() {
        mouseMoveToPosition = event.position;
        logText = '鼠标左键移动 ${event.position}';
        //鼠标在世界中的坐标
        PointEX mousePositionInSpace = Space.viewPortPointPos2SpacePointPos(
            mouseMoveToPosition,
            viewState.currentOffset,
            viewState.currentScale,
            viewState.validViewPortSizeOfSpace
        );
        debugPrint('鼠标在世界中的坐标 $mousePositionInSpace');
      });
    }
  }

  onPointerUp(event) {
    //因为在抬起的时候 event.buttons 就是0了 所以要通过刚才是不是按下的状态来判断
    if (mouseDownPosition != null || mouseMoveToPosition != null) {
      setState(() {
        mouseDownPosition = null;
        mouseMoveToPosition = null;
        // logText = '鼠标抬起 ${event.position}';
      });
    }
  }

  Decimal decimal1000 = Decimal.fromInt(1000);
  Decimal decimal10000 = Decimal.fromInt(10000);
  Decimal decimalDot1 = Decimal.parse("0.1");
  onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      // logText = '鼠标滚轮 ${event.scrollDelta}';
      var oldScale = ref
          .watch(viewStateProvider)
          .currentScale;

      Decimal newScale = oldScale +
          (reverseMouseWheel ? event.scrollDelta.dy.toDecimal() / decimal1000 : -event.scrollDelta
              .dy.toDecimal() / decimal1000);
      //region 限制最小和最大放大倍数
      if (newScale < decimalDot1) {
        ref.read(viewStateProvider.notifier).currentScale = decimalDot1;
      }
      else if (newScale > decimal10000) {
        ref.read(viewStateProvider.notifier).currentScale = decimal10000;
      }
      else {
        ref.read(viewStateProvider.notifier).currentScale = newScale;
      }
      //endregion
      //鼠标滚轮更新尺寸检测鼠标焦点上的物件
      // ref.read(viewStateProvider.notifier).updateInteractiveObjects(event.position);
    }
  }

  onPointerPanZoomUpdate(PointerPanZoomUpdateEvent event) {
    //没有检测到触摸板按下时的原始放大倍数,不进行缩放,这个原始放大倍数应当在触摸板按下时保存
    if (panScaleStart == null) {
      return;
    }
    setState(() {
      logText =
      '触摸板双指滑动 scale ${event.scale} pan ${event.localPanDelta}';
    });
    //region 位移
    var oldOffset = ref
        .watch(viewStateProvider)
        .currentOffset;

    var newOffset = oldOffset.translate(
        event.localPanDelta.dx, event.localPanDelta.dy);
    ref.read(viewStateProvider.notifier).currentOffset = newOffset;
    //endregion
    // var oldScale = ref
    //     .watch(viewStateControllerProvider)
    //     .currentScale;

    //在上一次放大倍数的基础上缩放
    var newScale = panScaleStart! * event.scale.toDecimal();
    //region 限制最小和最大放大倍数
    // if (newScale < decimalDot1) {
    //   ref.read(viewStateProvider.notifier).currentScale = decimalDot1;
    // }
    // else if (newScale > decimal10000) {
    //   ref.read(viewStateProvider.notifier).currentScale = decimal10000;
    // }
    // else {
      ref.read(viewStateProvider.notifier).currentScale = newScale;
    // }
    //endregion

    //更新尺寸检测鼠标焦点上的物件
    // ref.read(viewStateProvider.notifier).updateInteractiveObjects(event.position);
    // logText = '检测区域offset: ${currentOffset} space: ${validPaintingBoardSizeOfSpace} 检测到在区域内的物体数量 ${allObjectInPaintingBoard.length}';);
  }

  onPointerPanZoomStart(event) {
    setState(() {
      //保存现在的缩放倍数,不直接修改放大倍数防止setState造成过量乘数
      panScaleStart = ref.watch(viewStateProvider).currentScale;
    });
  }

  onPointerPanZoomEnd(event) {
    setState(() {
      // logText = '触摸板双指滑动结束';
      panScaleStart = null;
    });
  }

  //endregion




  @override
  Widget build(BuildContext context) {
    return
      MouseRegion(
        onHover: onHoverMouseRegion,
        child: Listener(
          //region 对鼠标和触摸板检测事件的绑定
          //鼠标移动
          onPointerMove: onPointerMove,
          //鼠标信号
          onPointerSignal: onPointerSignal,
          //鼠标按下
          onPointerDown: onPointerDown,
          //鼠标抬起
          onPointerUp: onPointerUp,


          //苹果笔记本触摸板支持双指拖动
          onPointerPanZoomUpdate: onPointerPanZoomUpdate,
          //苹果笔记本触摸板支持双指拖动和缩放,记录起始放大倍数
          onPointerPanZoomStart: onPointerPanZoomStart,
          //结束双指缩放时,重置放大倍数临时值
          onPointerPanZoomEnd: onPointerPanZoomEnd,
          //endregion
          child:
              //listen size change


          SizeListener(
              onWidgetSizeChange: (size) {
                ref.read(viewStateProvider.notifier).bound = context.globalPaintBounds;
                ref.read(viewStateProvider.notifier).viewPortPixelSize = size;
              },
            child:
          Stack(
            children: [
              //region 在视口中显示临时检测图形和log文字等
              const SizedBox(
                width: double.infinity,
                height: double.infinity,
                  //必须写点什么,不然Container和SizedBox等里面什么都没有的话,是检测不到鼠标和触摸板事件的.
                  //可能是因为没有内容以后,Container之类的尺寸就是0,因为在下面Positioned组件里面的Text上移动鼠标时可促发事件.
                  child: Text(''),
              ),
              Positioned(
                left: 100,
                top: 50,
                child: Text(logText),
              ),
              Positioned(
                left: 100,
                top: 100,
                child: Text(logText2),
              ),
              //endregion
            ],
          ),
          ),
        ),
      );
  }
}





