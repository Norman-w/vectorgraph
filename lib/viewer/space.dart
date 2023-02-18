//这是二维平面,所有物体的基板,可以理解为无限的空间.它从中心点开始计算,没有尺寸,所有的图形在这上面只有偏移量相对位置.
//在需要显示space上的内容时,用户通过鼠标键盘等交互确认显示范围(宽度,高度)以及相对于space中心点的偏移量确认视口(view_port)
//在视口外的内容不进行渲染,视口内的内容根据缩放比例进行渲染.

import 'dart:ui';

import '../objects/space_object.dart';
import 'paper.dart';
import 'space_layer.dart';

class Space {
  final layers = <SpaceLayer>[];
  //get all layer's objects
  List<Object> get objects {
    var result = <Object>[];
    for (var layer in layers) {
      result.addAll(layer.objects);
    }
    return result;
  }
  final papers = <Paper>[];
  void addPaper(Paper paper){
    papers.add(paper);
  }

  List<SpaceObject> getInViewPortObjects(Offset viewPortCenter, Size viewPortSize){
    var result = <SpaceObject>[];
    for (var layer in layers) {
      result.addAll(layer.getInBounds(
          Rect.fromLTWH(
              viewPortCenter.dx - viewPortSize.width / 2,
              viewPortCenter.dy - viewPortSize.height / 2,
              viewPortSize.width,
              viewPortSize.height)
      //   Rect.fromCenter(
      //       center: viewPortCenter,
      //       width: viewPortSize.width,
      //       height: viewPortSize.height
      // )
      ));
    }
    return result;
  }
  static Offset viewPortPointPos2SpacePointPos(Offset? mousePosition,Offset currentOffset, double currentScale, Size validViewPortSizeOfSpace) {
    return mousePosition == null? Offset.zero: mousePosition! / currentScale
        - Offset(validViewPortSizeOfSpace.width / 2, validViewPortSizeOfSpace.height / 2)
        - currentOffset/currentScale
    ;
  }
}