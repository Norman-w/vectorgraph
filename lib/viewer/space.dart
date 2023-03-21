//这是二维平面,所有物体的基板,可以理解为无限的空间.它从中心点开始计算,没有尺寸,所有的图形在这上面只有偏移量相对位置.
//在需要显示space上的内容时,用户通过鼠标键盘等交互确认显示范围(宽度,高度)以及相对于space中心点的偏移量确认视口(view_port)
//在视口外的内容不进行渲染,视口内的内容根据缩放比例进行渲染.

import 'dart:ui';
import 'package:vectorgraph/utils/num_utils.dart';

import '../model/geometry/SizeEX.dart';
import '../model/geometry/points/point_ex.dart';
import '../model/geometry/rect/RectEX.dart';
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

  List<SpaceObject> getInViewPortObjects(PointEX viewPortShowingSpaceRectCenter, SizeEX showingSpaceRectSize){
    var result = <SpaceObject>[];
    for (var layer in layers) {
      result.addAll(layer.getInBounds(
          RectEX.fromLTWH(
              viewPortShowingSpaceRectCenter.x - showingSpaceRectSize.width / Decimal.two,
              viewPortShowingSpaceRectCenter.y - showingSpaceRectSize.height / Decimal.two,
              showingSpaceRectSize.width,
              showingSpaceRectSize.height)
      ));
    }
    return result;
  }
  static PointEX viewPortPointPos2SpacePointPos(
      Offset? mousePosition,
      Offset currentOffset,
      Decimal currentScale,
      SizeEX validViewPortSizeOfSpace) {
    return mousePosition == null? PointEX.zero: mousePosition.toPointEX() / currentScale
        - PointEX(validViewPortSizeOfSpace.width / Decimal.two, validViewPortSizeOfSpace.height / Decimal.two)
        - currentOffset.toPointEX()/currentScale
    ;
  }
  static Offset spacePointPos2ViewPortPointPos(
      PointEX spacePointPos,
      Offset currentViewPortOffset,
      Decimal currentScale,
      Size currentViewPortSize) {
    var zoomedSpacePointPos = spacePointPos * currentScale;
    var afterOffset = zoomedSpacePointPos.toOffset() + currentViewPortOffset
    + Offset(currentViewPortSize.width / 2, currentViewPortSize.height / 2)
    ;
    return afterOffset;
  }
}