import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import 'package:vectorgraph/viewer/paper.dart';

import '../model/geometry/SizeEX.dart';
import '../model/geometry/rect/RectEX.dart';
import '../objects/point_object.dart';
import '../objects/rect_object.dart';
import 'space.dart';
import '../objects/space_object.dart';
import 'space_layer.dart';


class ViewState{
  ///当前视口到世界空间的缩放比例
  Decimal currentScale = Decimal.one;
  ///当前视口的偏移量,不是世界空间的偏移量
  Offset currentOffset = Offset.zero;
  ///当前视口的边界
  Rect bound = Rect.zero;
  ///当前视口的像素大小
  Size viewPortPixelSize = Size.zero;
  ///当前视口在世界空间中的有效大小
  SizeEX validViewPortSizeOfSpace = SizeEX.zero;
  ///当前视口中能看到的所有物件
  List<SpaceObject> allObjectInViewPort = [];
  // ///标尺需要的矩形,从中心点开始
  // Rect get rulerRectFromCenter => Rect.fromCenter(
  //     center: (-PointEX.fromOffset(currentOffset) / currentScale).toOffset(),
  //     width: validViewPortSizeOfSpace.width.toDouble(),
  //     height: validViewPortSizeOfSpace.height.toDouble());
  // Space _space = initSpace();
  ///拷贝当前视图状态
  ViewState copyWith(){
    return ViewState()
      ..currentScale = currentScale
      ..currentOffset = currentOffset
      ..bound = bound
      ..viewPortPixelSize = viewPortPixelSize
      ..validViewPortSizeOfSpace = validViewPortSizeOfSpace
      ..allObjectInViewPort = allObjectInViewPort
    ;
  }
}

final viewStateProvider = StateNotifierProvider<ViewStateNotifier, ViewState>((ref) {
  return ViewStateNotifier(ViewState());
});

class ViewStateNotifier extends StateNotifier<ViewState> {
  Rect? _bound;

  ViewStateNotifier(super.state);

  Rect? get bound => _bound;
  set bound(Rect? value) {
    if(_bound == value || value == null){
      return;
    }
    state = state.copyWith()
    ..bound = value
    ..viewPortPixelSize = value!.size
    ..validViewPortSizeOfSpace = SizeEX.fromSize(state.viewPortPixelSize) / state.currentScale
    ..allObjectInViewPort = _space.getInViewPortObjects(
        PointEX.fromOffset(state.currentOffset)/state.currentScale,
        state.validViewPortSizeOfSpace);
  }
  set currentScale(Decimal value) {
    state = state.copyWith()
    ..currentScale = value
      ..validViewPortSizeOfSpace = state.viewPortPixelSize.toSizeEX() / state.currentScale
      ..allObjectInViewPort = _space.getInViewPortObjects(
          PointEX.fromOffset(state.currentOffset)/state.currentScale,
          state.validViewPortSizeOfSpace);
  }
  set currentOffset(Offset value) {
    state = state.copyWith()..currentOffset = value
    ..validViewPortSizeOfSpace = state.viewPortPixelSize.toSizeEX()/state.currentScale
      ..allObjectInViewPort = _space.getInViewPortObjects(
          PointEX.fromOffset(state.currentOffset)/state.currentScale,
          state.validViewPortSizeOfSpace);
  }
  set viewPortPixelSize(Size value) {
    state = state.copyWith()
      ..viewPortPixelSize = value
      ..validViewPortSizeOfSpace = state.viewPortPixelSize.toSizeEX() / state.currentScale
      ..allObjectInViewPort = _space.getInViewPortObjects(
          PointEX.fromOffset(state.currentOffset)/state.currentScale,
          state.validViewPortSizeOfSpace);
  }
  final Space _space = initSpace();
  PointEX worldPoint = PointEX.zero;
}

Space initSpace(){
  var space = Space();
  var layer = SpaceLayer(0);



  var paper = Paper(
    name: "paper1",
    width: 400,
    height: 300,
    color: Colors.lightGreen,
  )..left = 180..top = 150;

  RectObject rectObject = RectObject.fromCenter(
      center: PointEX(Decimal.zero,Decimal.zero),
      width: Decimal.fromInt(100),
      height: Decimal.fromInt(100));
  layer.addRect(
      rectObject
  );


  layer.addRect(
      RectObject.fromCenter(center: PointEX(Decimal.zero,Decimal.zero), width: Decimal.fromInt(400), height: Decimal.fromInt(300))
  );

  layer.addPoint(
      PointObject(Decimal.zero, Decimal.zero)
  );

  space.addPaper(paper);

  space.layers.add(layer);

  return space;
}