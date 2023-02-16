import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/utils/utils.dart';
import 'package:vectorgraph/utils/widget.dart';
import 'package:vectorgraph/viewer/ruler.dart';

import '../objects/rect_object.dart';
import 'rect_painter.dart';
import 'space.dart';
class ViewPort extends StatefulWidget {
  final Space space;
  ViewPort(this.space);
  @override
  createState() => _ViewPortState();
}
class _ViewPortState extends State<ViewPort> with SingleTickerProviderStateMixin
{
  //放大倍数
  double currentScale =2;
  //触摸板开始双指缩放时的放大倍数,不直接*=currentScale 防止因为刷新频率的问题导致放大倍数不准确
  double panScaleStart = 1;
  Offset currentOffset = Offset(200,0);// Offset.zero;
  double rectWidth = 200;
  double rectLeft = 0;
  double rectHeight = 150;
  double rectTop = 0;

  String logText = '3333333';
  String logText2 = '';

  Offset? mouseDownPosition;
  Offset? mouseMoveToPosition;



  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var bound = context.globalPaintBounds;
    if(bound == null){
      return Container();
    }
    Size viewPortPixelSize = Size(bound.width, bound.height);
    Offset viewPortLocalCenter = Offset(viewPortPixelSize.width/2, viewPortPixelSize.height/2);
    Size validViewPortSizeOfSpace = viewPortPixelSize / currentScale;
    // logText = "当前有效的检测区域是: $validViewPortSizeOfSpace  位移:${currentOffset}";
    var allObjectInViewPort = widget.space.getInViewPortObjects(currentOffset /currentScale, validViewPortSizeOfSpace);
    // logText2 = '在区域内的物件数量: ${allObjectInViewPort.length}';
    return
    MouseRegion(
      onHover: (event) {
        setState(() {
          // logText = 'MouseRegion hover ${event.position}';
        });
      },
      child:Listener(
        onPointerMove: (event) {
          if(event.buttons == 2){
            setState(() {
              mouseDownPosition = event.position;
              // logText = '鼠标移动 ${event.position}';
              currentOffset = currentOffset.translate(event.delta.dx, event.delta.dy);
            });
          }
        },
        //on mouse wheel
        onPointerSignal: (event) {
          if(event is PointerScrollEvent){
            setState(() {
              // logText = '鼠标滚轮 ${event.scrollDelta}';
              currentScale = currentScale + event.scrollDelta.dy/1000;
              if(currentScale < 0.1){
                currentScale = 0.1;
              }
            });
          }
        },
        //苹果笔记本触摸板支持双指拖动
        onPointerPanZoomUpdate: (event) {
          setState(() {
            // logText = '触摸板双指滑动 scale ${event.scale} pan ${event.localPanDelta}';
            currentOffset = currentOffset.translate(event.localPanDelta.dx, event.localPanDelta.dy);
            //在上一次放大倍数的基础上缩放
            currentScale = panScaleStart * event.scale;
            // logText = '检测区域offset: ${currentOffset} space: ${validViewPortSizeOfSpace} 检测到在区域内的物体数量 ${allObjectInViewPort.length}';
          });
        },
        onPointerPanZoomStart: (event) {
          setState(() {
            //保存现在的缩放倍数,不直接修改放大倍数防止setState造成过量乘数
            panScaleStart = currentScale;
          });
        },
        onPointerPanZoomEnd: (event) {
          setState(() {
            // logText = '触摸板双指滑动结束';
            panScaleStart = 1;
          });
        },
        onPointerDown: (event) {
          if(event.buttons == 2){
            setState(() {
              mouseDownPosition = event.position;
              // logText = '鼠标按下 ${event.position}';
            });
          }
        },
        onPointerUp: (event) {
          //因为在抬起的时候 event.buttons 就是0了 所以要通过刚才是不是按下的状态来判断
          if(mouseDownPosition != null || mouseMoveToPosition != null){
            setState(() {
              mouseDownPosition = null;
              mouseMoveToPosition = null;
              // logText = '鼠标抬起 ${event.position}';
            });
          }
        },
        child: Stack(
                  children: [
                    //draw all rectEX
                    ...allObjectInViewPort.map((e) {
                      return e.getWidget(viewPortPixelSize, currentOffset, currentScale,
                          // Colors.red
                        getRandomColor(),
                      );
                      }
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(rectLeft.toStringAsFixed(5)),
                    ),
                    Container(
                        width: double.infinity,
                        height: double.infinity,
                        child:Ruler(
                          Rect.fromCenter(
                              center: -currentOffset / currentScale,
                              width: validViewPortSizeOfSpace.width,
                              height: validViewPortSizeOfSpace.height,
                          ),
                        )
                    ),
                    Transform.translate(offset: Offset(
                        50,50),
                        child: Text(logText)
                    ),
                    Transform.translate(offset: Offset(
                        50,80),
                        child: Text(logText2)
                    ),
                  ],
                    ),
                ),
    );
  }
}





