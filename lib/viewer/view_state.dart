import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/viewer/paper.dart';

import '../objects/point_object.dart';
import '../objects/rect_object.dart';
import 'space.dart';
import '../objects/space_object.dart';
import 'space_layer.dart';

// class ViewStateController extends ChangeNotifier {
//   double currentScale = 1.0;
//   Offset currentOffset = Offset.zero;
//
//   Space space = Space();
//
//   Rect? bound;
//   Size viewPortPixelSize = Size.zero;
//   Size validViewPortSizeOfSpace = Size.zero;
//   List<SpaceObject> allObjectInViewPort = [];
// }

// var stateControllerProvider =
// ChangeNotifierProvider<ViewStateController>((ref) => ViewStateController());

var viewStateControllerProvider =
ChangeNotifierProvider<ViewStateController>((ref) => ViewStateController());

class ViewStateController extends ChangeNotifier {
  Rect? _bound;
  Rect? get bound => _bound;
  set bound(Rect? value) {
    if(value == null){
      print('这应该是第一次');
      return ;
    }
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
  List<SpaceObject> get allObjectInViewPort => _allObjectInViewPort;
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