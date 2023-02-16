import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vectorgraph/utils/utils.dart';
import 'package:vectorgraph/utils/widget.dart';
import 'package:vectorgraph/viewer/ruler.dart';

import 'space.dart';
class ViewPort extends StatefulWidget {
  final Space space;
  const ViewPort(this.space, {super.key});
  @override
  createState() => _ViewPortState();
}
class _ViewPortState extends State<ViewPort> with SingleTickerProviderStateMixin {
  //视口的当前使用放大倍数
  double currentScale = 1;
  //触摸板开始双指缩放时的放大倍数,不直接*=currentScale 防止因为刷新频率的问题导致放大倍数不准确
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

  onPointerMove(PointerMoveEvent event) {
    if (event.buttons == 2) {
      setState(() {
        mouseDownPosition = event.position;
        // logText = '鼠标移动 ${event.position}';
        currentOffset = currentOffset.translate(event.delta.dx, event.delta.dy);
      });
    }
  }

  onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      setState(() {
        // logText = '鼠标滚轮 ${event.scrollDelta}';
        currentScale = currentScale + (reverseMouseWheel?event.scrollDelta.dy / 1000: - event.scrollDelta.dy / 1000);
        if (currentScale < 0.1) {
          currentScale = 0.1;
        }
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
      currentScale = panScaleStart! * event.scale;
      // logText = '检测区域offset: ${currentOffset} space: ${validViewPortSizeOfSpace} 检测到在区域内的物体数量 ${allObjectInViewPort.length}';
    });
  }

  onPointerPanZoomStart(event) {
    setState(() {
      //保存现在的缩放倍数,不直接修改放大倍数防止setState造成过量乘数
      panScaleStart = currentScale;
    });
  }

  onPointerPanZoomEnd(event) {
    setState(() {
      // logText = '触摸板双指滑动结束';
      panScaleStart = null;
    });
  }

  onPointerDown(event) {
    if (event.buttons == 2) {
      setState(() {
        mouseDownPosition = event.position;
        // logText = '鼠标按下 ${event.position}';
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
  //endregion

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var bound = context.globalPaintBounds;
    if (bound == null) {
      return Container();
    }
    //当前显示区域的像素大小
    Size viewPortPixelSize = Size(bound.width, bound.height);
    //当前显示的空间范围
    Size validViewPortSizeOfSpace = viewPortPixelSize / currentScale;
    //在当前有效空间范围内的物件
    var allObjectInViewPort = widget.space.getInViewPortObjects(
        currentOffset / currentScale, validViewPortSizeOfSpace);
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
                    Rect.fromCenter(
                      center: -currentOffset / currentScale,
                      width: validViewPortSizeOfSpace.width,
                      height: validViewPortSizeOfSpace.height,
                    ),
                  )
              ),
              Transform.translate(offset: const Offset(
                  50, 50),
                  child: Text(logText)
              ),
              Transform.translate(offset: const Offset(
                  50, 80),
                  child: Text(logText2)
              ),
              //endregion
            ],
          ),
        ),
      );
  }
}





