import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
  double currentScale =1;
  Offset currentOffset = Offset.zero;
  double rectWidth = 200;
  double rectLeft = 0;
  double rectHeight = 150;
  double rectTop = 0;

  String logText = '3333333';

  Offset? mouseDownPosition;
  Offset? mouseMoveToPosition;



  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var viewPortPixelSize = Size(1920,1080);
    Offset viewPortLocalCenter = Offset(viewPortPixelSize.width/2, viewPortPixelSize.height/2);
    Size validViewPortSizeOfSpace = viewPortPixelSize/ currentScale;
    var allObjectInViewPort = widget.space.getInViewPortObjects(currentOffset, validViewPortSizeOfSpace);
    return
    MouseRegion(
      onHover: (event) {
        setState(() {
          logText = 'MouseRegion hover ${event.position}';
        });
      },
      child:Listener(
        onPointerMove: (event) {
          if(event.buttons == 2){
            setState(() {
              mouseDownPosition = event.position;
              logText = '鼠标移动 ${event.position}';
              currentOffset = currentOffset.translate(event.delta.dx, event.delta.dy);
            });
          }
        },
        //on mouse wheel
        onPointerSignal: (event) {
          if(event is PointerScrollEvent){
            setState(() {
              logText = '鼠标滚轮 ${event.scrollDelta}';
              currentScale = currentScale + event.scrollDelta.dy/1000;
              if(currentScale < 0.1){
                currentScale = 0.1;
              }
            });
          }
        },
        onPointerDown: (event) {
          if(event.buttons == 2){
            setState(() {
              mouseDownPosition = event.position;
              logText = '鼠标按下 ${event.position}';
            });
          }
        },
        onPointerUp: (event) {
          //因为在抬起的时候 event.buttons 就是0了 所以要通过刚才是不是按下的状态来判断
          if(mouseDownPosition != null || mouseMoveToPosition != null){
            setState(() {
              mouseDownPosition = null;
              mouseMoveToPosition = null;
              logText = '鼠标抬起 ${event.position}';
            });
          }
        },
        child: Stack(
                  children: [
                    //draw all rectEX
                    ...allObjectInViewPort.map((e) {
                      Widget ret = Container();
                        switch (e.runtimeType) {
                          case RectEX:
                            var rectEX = e as RectEX;
                            var newWidth = rectEX.width * currentScale;
                            var newHeight = rectEX.height * currentScale;
                            var oldWidth = rectEX.width;
                            var oldHeight = rectEX.height;
                            var xAdded = (newWidth - oldWidth) / 2;
                            var yAdded = (newHeight - oldHeight) / 2;
                            var newLeft = rectEX.left + currentOffset.dx + viewPortLocalCenter.dx - xAdded;
                            var newTop = rectEX.top + currentOffset.dy + viewPortLocalCenter.dy  -yAdded;
                            var realViewRect = Rect.fromLTWH(
                                newLeft,
                                newTop,
                                newWidth,
                                newHeight
                            );
                            ret = CustomPaint(
                              painter: RectPainter(realViewRect, Colors.red),
                            );
                        }
                        return ret;
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
                        300,400),
                        child: Text(logText)
                    ),
                  ],
                    ),
                ),
    );
  }
}





