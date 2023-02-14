import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vectorgraph/viewer/ruler.dart';

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
  double currentScale =1.5;
  Offset currentOffset = Offset.zero;
  double rectWidth = 200;
  double rectLeft = 80;
  double rectHeight = 150;
  double rectTop = 91.5;

  String logText = '';


  double _previousScale = 0;



  @override
  void initState() {
    super.initState();
    // Timer.periodic(Duration(milliseconds: 100), (timer) {
    //   setState(() {
    //     currentScale *= 1.001;
    //   });
    // });
    // Timer.periodic(Duration(milliseconds: 20), (timer) {
    //   setState(() {
    //     rectWidth = rectWidth *1.001;
    //     rectHeight = rectHeight *1.001;
    //     rectLeft = rectLeft * 1.0011;
    //     rectTop = rectTop * 1.0015;
    //     // print(rectTop);
    //   });
    // });
  }



  @override
  Widget build(BuildContext context) {

    Offset _normalizedOffset = Offset.zero;

    Offset _clampOffset(Offset offset) {
      final Size? size = context.size;
      // widget的屏幕宽度
      final Offset minOffset = Offset(size!.width, size!.height) * (1.0 - currentScale);
      // 限制他的最小尺寸
      return Offset(
          offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
    }


    var allRects = widget.space.layers.expand((element) => element.rects).toList();
    return
      GestureDetector(
        onScaleUpdate: (details){
          setState(() {
            currentScale = (_previousScale * details.scale).clamp(1.0, 3.0);
            // 限制放大倍数 1~3倍
            currentOffset = _clampOffset(details.focalPoint - _normalizedOffset * currentScale);
            // 更新当前位置
          });
        },
        onScaleStart: (details){
          setState(() {
            _previousScale = currentScale;
            _normalizedOffset = (details.focalPoint - currentOffset) / currentScale;
            // 计算图片放大后的位置
            // _controller.stop();
          });
        }
          ,
          onDoubleTap: () {
            setState(() {
              currentScale = 1.0;
            });
          },
        child: Stack(
              children: [
                Transform(
                transform: Matrix4.identity()
              ..translate(currentOffset.dx, currentOffset.dy)
              ..scale(currentScale),
                child: Stack(
                  children: [
                    //绘制所有矩形
                    ...allRects.map((e) => Positioned(
                      left: e.left * currentScale,
                      top: e.top*currentScale,
                      child: Container(
                        width: e.width*currentScale,
                        height: e.height*currentScale,
                        color: Colors.red,
                      ),
                    )),
                    //绘制所有的纸张
                    ...widget.space.papers.map((e) => Positioned(
                      left: e.left * currentScale,
                      top: e.top*currentScale,
                      child: Container(
                        width: e.width*currentScale,
                        height: e.height*currentScale,
                        color: e.color,
                      ),
                    )),
                    Align(
                      alignment: Alignment.center,
                      child: Text(rectLeft.toStringAsFixed(5)),
                    )
                  ],
                    ),
                ),
                Container(
                    width: double.infinity,
                    height: double.infinity,
                    child:Ruler(
                      Rect.fromLTWH(rectLeft, rectTop, rectWidth, rectHeight),
                    )
                ),

                Text(logText),
          ],
        ),
      );
  }
}





