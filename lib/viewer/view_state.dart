import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import 'package:vectorgraph/viewer/paper.dart';

import '../model/geometry/SizeEX.dart';
import '../objects/point_object.dart';
import '../objects/rect_object.dart';
import 'space.dart';
import '../objects/space_object.dart';
import 'space_layer.dart';


class ViewState{
  Decimal currentScale = Decimal.one;
  Offset currentOffset = Offset.zero;
  Rect bound = Rect.zero;
  Size viewPortPixelSize = Size.zero;
  SizeEX validViewPortSizeOfSpace = SizeEX.zero;
  List<SpaceObject> allObjectInViewPort = [];
  Rect get rulerRectFromCenter => Rect.fromCenter(
      center: (-PointEX.fromOffset(currentOffset) / currentScale).toOffset(),
      width: validViewPortSizeOfSpace.width.toDouble(),
      height: validViewPortSizeOfSpace.height.toDouble());
  // Space _space = initSpace();
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
//
// class ViewStateNotifier extends StateNotifier<ViewState>{
//   ViewStateNotifier(super.state);
//   void updateScale(Decimal newScale){
//     state.currentScale = newScale;
//   }
// }

final viewStateProvider = StateNotifierProvider<ViewStateNotifier, ViewState>((ref) {
  return ViewStateNotifier(ViewState());
});
//
// var viewStateControllerProvider =
// ChangeNotifierProvider<ViewStateController>((ref) => ViewStateController());

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
  Space _space = initSpace();
  init(){
    _space = initSpace();
    state.viewPortPixelSize = const Size(800,600);
  }
  PointEX worldPoint = PointEX.zero;
  void updateInteractiveObjects(Offset mousePosition){
    worldPoint = mousePosition.toPointEX() / state.currentScale
        - PointEX(state.validViewPortSizeOfSpace.width / Decimal.two, state.validViewPortSizeOfSpace.height / Decimal.two)
        - state.currentOffset.toPointEX()/state.currentScale;

    bool needUpdate = false;
    for (var element in state.allObjectInViewPort) {
      if(element.bounds.contains(worldPoint)){
        switch(element.runtimeType){
          case RectObject:
            var oldIsInteractive = element.isInteractive;
            var newIsInteractive = (element as RectObject).isPointOnSides(worldPoint);
            if(oldIsInteractive!= newIsInteractive){
              print('有交集');
              needUpdate = true;
              element.isInteractive = newIsInteractive;
              // }
            }
        }
      }
    }
    if(!needUpdate)
    {
      return;
    }
    state = state.copyWith()
      ..allObjectInViewPort = state.allObjectInViewPort;
    // if(needUpdate) {
    // }
  }
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


  // var RectEX1 = RectEX.fromLTWH(20, 30, 20, 20);
  // var RectEX2 = RectEX.fromLTWH(50, 60, 15, 20);
  // var RectEX3 = RectEX.fromLTWH(70, 80, 20, 12);
  // var RectEX4 = RectEX.fromLTWH(85, 105, 30, 25);

  // layer.addRectEX(RectEX1);
  // layer.addRectEX(RectEX2);
  // layer.addRectEX(RectEX3);
  // layer.addRectEX(RectEX4);
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