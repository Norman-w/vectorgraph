

/**
 * view port 相当于是显示器，显示器的大小是固定的，但是显示器上的内容是可以变化的。
 * 例如，显示器的大小是 800*600，但是显示器上的内容可以是 400*300，也可以是 800*600，也可以是 1600*1200。
 *
 * painting board 相当于是画板，画板的大小也是可以变化的.这个大小和view port是一样的.
 *
 * 可以理解为，view port是显示器，painting board是显示器上的一层支持笔和鼠标以及触摸的绘图板,在这个绘图板上作画会实时显示在显示器上。
 *
 * 如果当前的缩放倍数是2,显示器和绘图板的大小都是800x600, 那么绘图板上的内容就是400x300.
 * 在绘图板上绘制一个100x100像素的矩形,那么实际上在世界空间中,这个矩形的大小就是50x50像素.
 *
 * 相较于视口(显示器,显示区域),绘图板(绘画板,触摸屏,绘图屏)是距离用户更近的一层.但他是透明的.
 */

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:vectorgraph/utils/widget.dart';
import 'package:vectorgraph/viewer/ruler.dart';

import 'space.dart';
import 'viewState.dart';
class PaintingBoard extends StatefulWidget {
  const PaintingBoard({super.key});
  @override
  createState() => _PaintingBoardState();
}

class _PaintingBoardState extends State<PaintingBoard> with SingleTickerProviderStateMixin {
  double? panScaleStart;
  //视口的当前使用偏移量
  Offset currentOffset = Offset.zero;
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
    // setState(() {
    //   // logText = 'MouseRegion hover ${event.position}';
    // });
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
        // logText = '鼠标移动 ${event.position}';
        currentOffset = currentOffset.translate(event.delta.dx, event.delta.dy);
      });
    }
    else if(event.buttons == 1){
      setState(() {
        mouseMoveToPosition = event.position;
        logText = '鼠标左键移动 ${event.position}';
        //鼠标在世界中的坐标
        var mousePositionInSpace = Space.viewPortPointPos2SpacePointPos(mouseMoveToPosition);

        logText2 = '鼠标在世界中的坐标 $mousePositionInSpace';
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

  onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      setState(() {
        // logText = '鼠标滚轮 ${event.scrollDelta}';
        ViewState.currentScale = ViewState.currentScale + (reverseMouseWheel?event.scrollDelta.dy / 1000: - event.scrollDelta.dy / 1000);
        //region 限制最小和最大放大倍数
        if (ViewState.currentScale < 0.1) {
          ViewState.currentScale = 0.1;
        }
        else if(ViewState.currentScale >10000){
          ViewState.currentScale = 10000;
        }
        //endregion
      });
    }
  }

  onPointerPanZoomUpdate(PointerPanZoomUpdateEvent event) {
    //没有检测到触摸板按下时的原始放大倍数,不进行缩放,这个原始放大倍数应当在触摸板按下时保存
    if(panScaleStart == null) {
      return ;
    }
    setState(() {
      // logText = '触摸板双指滑动 scale ${event.scale} pan ${event.localPanDelta}';
      currentOffset = currentOffset.translate(
          event.localPanDelta.dx, event.localPanDelta.dy);
      //在上一次放大倍数的基础上缩放
      ViewState.currentScale = panScaleStart! * event.scale;
      //region 限制最小和最大放大倍数
      if (ViewState.currentScale < 0.1) {
        ViewState.currentScale = 0.1;
      }
      else if(ViewState.currentScale >10000){
        ViewState.currentScale = 10000;
      }
      //endregion
      // logText = '检测区域offset: ${currentOffset} space: ${validPaintingBoardSizeOfSpace} 检测到在区域内的物体数量 ${allObjectInPaintingBoard.length}';
    });
  }

  onPointerPanZoomStart(event) {
    setState(() {
      //保存现在的缩放倍数,不直接修改放大倍数防止setState造成过量乘数
      panScaleStart = ViewState.currentScale;
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
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    ViewState.bound = context.globalPaintBounds;
    if (ViewState.bound == null) {
      return Container();
    }
    //当前显示区域的像素大小
    ViewState.viewPortPixelSize = Size(ViewState.bound!.width, ViewState.bound!.height);
    //当前显示的空间范围
    ViewState.validViewPortSizeOfSpace = ViewState.viewPortPixelSize / ViewState.currentScale;
    //在当前有效空间范围内的物件
    ViewState.allObjectInViewPort = ViewState.space.getInViewPortObjects(
        currentOffset / ViewState.currentScale, ViewState.validViewPortSizeOfSpace);
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
          child: Stack(
            children: [
              //region 在视口中显示临时检测图形和log文字等
              SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Ruler(
                    Rect.fromCenter(
                      center: -currentOffset / ViewState.currentScale,
                      width: ViewState.validViewPortSizeOfSpace.width,
                      height: ViewState.validViewPortSizeOfSpace.height,
                    ),
                  )
              ),
              //endregion
            ],
          ),
        ),
      );
  }
}




