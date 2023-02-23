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
  Offset validViewPortSizeOfSpace = Offset.zero;
  List<SpaceObject> allObjectInViewPort = [];
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

class ViewStateNotifier extends StateNotifier<ViewState>{
  ViewStateNotifier(super.state);
  void updateScale(double newScale){
    state.currentScale = newScale;
  }
}

final viewStateProvider = StateNotifierProvider<ViewStateNotifier, ViewState>((ref) {
  return ViewStateNotifier(ViewState());
});

var viewStateControllerProvider =
ChangeNotifierProvider<ViewStateController>((ref) => ViewStateController());

class ViewStateController extends ChangeNotifier {
  Rect? _bound;
  Rect? get bound => _bound;
  set bound(Rect? value) {
    if(_bound == value || value == null){
      return;
    }
    _bound = value;
    _viewPortPixelSize = value!.size;
    _validViewPortSizeOfSpace = _viewPortPixelSize / _currentScale;
    _allObjectInViewPort = _space.getInViewPortObjects(
        _currentOffset / _currentScale, _validViewPortSizeOfSpace);
    notifyListeners();
  }
  double _currentScale = 1;
  double get currentScale => _currentScale;
  set currentScale(double value) {
    _currentScale = value;
    _validViewPortSizeOfSpace = _viewPortPixelSize / _currentScale;
    _allObjectInViewPort = _space.getInViewPortObjects(
        _currentOffset / _currentScale, _validViewPortSizeOfSpace);
    notifyListeners();
  }
  Offset _currentOffset = Offset.zero;
  Offset get currentOffset => _currentOffset;
  set currentOffset(Offset value) {
    _currentOffset = value;
    _validViewPortSizeOfSpace = _viewPortPixelSize / _currentScale;
    _allObjectInViewPort = _space.getInViewPortObjects(
        _currentOffset / _currentScale, _validViewPortSizeOfSpace);
    notifyListeners();
  }
  Size _viewPortPixelSize = const Size(800,600);
  Size get viewPortPixelSize => _viewPortPixelSize;
  set viewPortPixelSize(Size value) {
    _viewPortPixelSize = value;
    _validViewPortSizeOfSpace = _viewPortPixelSize / _currentScale;
    _allObjectInViewPort = _space.getInViewPortObjects(
        _currentOffset / _currentScale, _validViewPortSizeOfSpace);

    notifyListeners();
  }
  Size _validViewPortSizeOfSpace = const Size(800,600);
  Size get validViewPortSizeOfSpace => _validViewPortSizeOfSpace;
  List<SpaceObject> _allObjectInViewPort = [];
  // List<SpaceObject> _interactiveObjects = [];
  List<SpaceObject> get allObjectInViewPort => _allObjectInViewPort;
  // List<SpaceObject> get interactiveObjects => _interactiveObjects;
  Rect get rulerRectFromCenter => Rect.fromCenter(
      center: -_currentOffset / _currentScale,
      width: _validViewPortSizeOfSpace.width,
      height: _validViewPortSizeOfSpace.height);
  Space _space = initSpace();
  // Space get space => _space;
  // set space(Space value) {
  //   _space = value;
  //   notifyListeners();
  // }
  init(){
    _space = initSpace();
    _viewPortPixelSize = const Size(800,600);
    notifyListeners();
  }
  void updateInteractiveObjects(Offset mousePosition){
    final worldPoint = mousePosition / currentScale
        - Offset(validViewPortSizeOfSpace.width / 2, validViewPortSizeOfSpace.height / 2)
        - currentOffset/currentScale;
    final worldPointEX = PointEX(worldPoint.dx, worldPoint.dy);
    // bool needUpdate = false;
    for (var element in _allObjectInViewPort) {
      if(element.bounds.contains(worldPoint)){
        switch(element.runtimeType){
          case RectObject:
            var old = element.isInteractive;
            var interactive = (element as RectObject).isPointOnSides(worldPointEX);
            // if(old!= interactive){
              // needUpdate = true;
              element.isInteractive = interactive;
            // }
        }
      }
    }
    // if(needUpdate) {
      notifyListeners();
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