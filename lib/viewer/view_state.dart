import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/viewer/paper.dart';

import '../objects/point_object.dart';
import '../objects/rect_object.dart';
import 'space.dart';
import '../objects/space_object.dart';
import 'space_layer.dart';


class ViewState{
  double currentScale = 1;
  Offset currentOffset = Offset.zero;
  Rect bound = Rect.zero;
  Size viewPortPixelSize = Size.zero;
  Size validViewPortSizeOfSpace = Size.zero;
  List<SpaceObject> allObjectInViewPort = [];
  Rect get rulerRectFromCenter => Rect.fromCenter(
      center: -currentOffset / currentScale,
      width: validViewPortSizeOfSpace.width,
      height: validViewPortSizeOfSpace.height);
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
//   void updateScale(double newScale){
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
    ..validViewPortSizeOfSpace = state.viewPortPixelSize / state.currentScale
    ..allObjectInViewPort = _space.getInViewPortObjects(state.currentOffset/state.currentScale, state.validViewPortSizeOfSpace);
  }
  set currentScale(double value) {
    state = state.copyWith()
    ..currentScale = value
      ..validViewPortSizeOfSpace = state.viewPortPixelSize / state.currentScale
      ..allObjectInViewPort = _space.getInViewPortObjects(state.currentOffset/state.currentScale, state.validViewPortSizeOfSpace);
  }
  set currentOffset(Offset value) {
    state = state.copyWith()..currentOffset = value
    ..validViewPortSizeOfSpace = state.viewPortPixelSize/state.currentScale
    ..allObjectInViewPort = _space.getInViewPortObjects(state.currentOffset / state.currentScale, state.validViewPortSizeOfSpace);
  }
  set viewPortPixelSize(Size value) {
    state = state.copyWith()
      ..viewPortPixelSize = value
      ..validViewPortSizeOfSpace = state.viewPortPixelSize / state.currentScale
      ..allObjectInViewPort = _space.getInViewPortObjects(state.currentOffset/state.currentScale, state.validViewPortSizeOfSpace);
  }
  Space _space = initSpace();
  init(){
    _space = initSpace();
    state.viewPortPixelSize = const Size(800,600);
  }
  var worldPoint = Offset.zero;
  void updateInteractiveObjects(Offset mousePosition){
    worldPoint = mousePosition / state.currentScale
        - Offset(state.validViewPortSizeOfSpace.width / 2, state.validViewPortSizeOfSpace.height / 2)
        - state.currentOffset/state.currentScale;
    final worldPointEX = PointEX(worldPoint.dx, worldPoint.dy);

    bool needUpdate = false;
    for (var element in state.allObjectInViewPort) {
      if(element.bounds.contains(worldPoint)){
        switch(element.runtimeType){
          case RectObject:
            var oldIsInteractive = element.isInteractive;
            var newIsInteractive = (element as RectObject).isPointOnSides(worldPointEX);
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


  // var rect1 = RectEX.fromLTWH(20, 30, 20, 20);
  // var rect2 = RectEX.fromLTWH(50, 60, 15, 20);
  // var rect3 = RectEX.fromLTWH(70, 80, 20, 12);
  // var rect4 = RectEX.fromLTWH(85, 105, 30, 25);

  // layer.addRect(rect1);
  // layer.addRect(rect2);
  // layer.addRect(rect3);
  // layer.addRect(rect4);
  layer.addRect(
      RectObject.fromCenter(center: const Offset(0,0), width: 100, height: 100)
  );
  layer.addRect(
      RectObject.fromCenter(center: const Offset(0,0), width: 400, height: 300)
  );

  layer.addPoint(
      PointObject(0, 0)
  );

  space.addPaper(paper);

  space.layers.add(layer);

  return space;
}