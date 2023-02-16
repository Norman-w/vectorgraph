import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


import '../utils/utils.dart';
import '../utils/widget.dart';
import 'ruler.dart';
import 'viewState.dart';

class ViewPort extends StatefulWidget {
  const ViewPort({super.key});
  @override
  createState() => _ViewPortState();
}




class _ViewPortState extends State<ViewPort> with SingleTickerProviderStateMixin {

  //测试用日志文本1
  String logText = 'This is log text 1';
  //测试用日志文本2
  String logText2 = 'This is log text 2';


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
        ViewState.currentOffset / ViewState.currentScale, ViewState.validViewPortSizeOfSpace);
    return Stack(
            children: [
              //绘制所有物件(通过物件转换成widget)
              ...ViewState.allObjectInViewPort.map((e) {
                return e.getWidget(
                  ViewState.viewPortPixelSize, ViewState.currentOffset, ViewState.currentScale,
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
                      center: -ViewState.currentOffset / ViewState.currentScale,
                      width: ViewState.validViewPortSizeOfSpace.width,
                      height: ViewState.validViewPortSizeOfSpace.height,
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
          );
  }
}





