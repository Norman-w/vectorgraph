import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/objects/equilateral_polygon_object.dart';
import 'package:vectorgraph/objects/polygon_object.dart';
import 'package:vectorgraph/objects/regular_polygonal_star.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import 'package:vectorgraph/viewer/paper.dart';

import 'model/geometry/rect/RectEX.dart';
import 'objects/bezier_object.dart';
import 'objects/line_object.dart';
import 'objects/point_object.dart';
import 'objects/rect_object.dart';
import 'space/space.dart';
import 'objects/space_object.dart';
import 'space/space_layer.dart';

class ViewState{
  //region 视图空间
  Offset viewSpaceViewPortOffset = Offset.zero;
  ///视口聚焦的位置,因为是鼠标往右拖动,视口中心实际上是在左移,所以是负数
  PointEX get viewPortPosition => -PointEX.fromOffset(viewSpaceViewPortOffset)/viewPortScale;
  ///视口的放大倍数
  Decimal viewPortScale = Decimal.one;
  ///视口的大小
  Size viewPortSize = Size.zero;
  //endregion

  //region 物体空间
  ///当前视口中能看到的所有物件
  List<SpaceObject> allObjectInViewPort = [];
  
  ///物体空间内可视大小
  RectEX get objectSpaceViewingRect => RectEX.fromCenter(
      center: viewPortPosition,
      width: viewPortSize.width.toDecimal() / viewPortScale,
      height: viewPortSize.height.toDecimal() / viewPortScale);
  //endregion

  //region state拷贝
  ViewState copyWith(){
    return ViewState()
        ..viewSpaceViewPortOffset = viewSpaceViewPortOffset
        ..viewPortScale = viewPortScale
        ..viewPortSize = viewPortSize
        ..viewPortScale = viewPortScale
        ..allObjectInViewPort = allObjectInViewPort
    ;
  }
  //endregion
}

final viewStateProvider = StateNotifierProvider<ViewStateNotifier, ViewState>((ref) {
  return ViewStateNotifier(ViewState());
});

class ViewStateNotifier extends StateNotifier<ViewState> {
  Rect? _viewSpaceBounds;

  ViewStateNotifier(super.state);

  ///视图空间的矩形区域
  Rect? get viewSpaceBounds => _viewSpaceBounds;
  // RectEX? get objectSpaceBounds => RectEX.
  set viewSpaceBounds(Rect? value) {
    if(_viewSpaceBounds == value || value == null){
      return;
    }
    var newState = state.copyWith()
    ..viewPortSize = value.size;
    newState.allObjectInViewPort = _space.getInViewPortObjects(newState.objectSpaceViewingRect);

    state = newState;
  }
  Decimal decimal1000 = Decimal.fromInt(1000);
  Decimal decimal10000 = Decimal.fromInt(10000);
  Decimal decimalDot1 = Decimal.parse("0.1");
  ///更新当前缩放比例
  void updateViewPortScale(Decimal newScale, Offset cursorPosition) {
    if(newScale > decimal1000 || newScale < decimalDot1){
      return;
    }
    var newState = state.copyWith()
      ..viewPortScale = newScale;
    newState.allObjectInViewPort = _space.getInViewPortObjects(newState.objectSpaceViewingRect);
    state = newState;
  }
  ///更新当前视口偏移量
  void updateViewSpaceOffset(Offset value) {
    var newState = state.copyWith();
    // var objectSpaceOffset = PointEX.fromOffset(value) / newState.viewPortScale;
    // newState.viewPortPosition = newState.viewPortPosition - objectSpaceOffset;
    newState.viewSpaceViewPortOffset = value;
    newState.allObjectInViewPort = _space.getInViewPortObjects(newState.objectSpaceViewingRect);
    state = newState;
  }
  set viewPortPixelSize(Size value) {
    var newState = state.copyWith()
      ..viewPortSize = value;
    newState.allObjectInViewPort = _space.getInViewPortObjects(newState.objectSpaceViewingRect);
    state = newState;
  }
  final Space _space = initSpace();
  PointEX worldPoint = PointEX.zero;
}

Space initSpace(){
  var space = Space();
  var layer1 = SpaceLayer(0);
  var layer2 = SpaceLayer(1);
  var layer3 = SpaceLayer(2);
  var layer4 = SpaceLayer(3);
  var layer5 = SpaceLayer(4);
  var layer6 = SpaceLayer(6);



  var paper = Paper(
    name: "paper1",
    width: 400,
    height: 300,
    color: Colors.lightGreen,
  )..left = 180..top = 150;

  //region 第一层矩形和点

  RectObject rectObject = RectObject.fromCenter(
      center: PointEX(Decimal.zero,Decimal.zero),
      width: Decimal.fromInt(100),
      height: Decimal.fromInt(100));
  rectObject.position = PointEX(Decimal.fromInt(100), Decimal.fromInt(100));
  layer1.addRect(
      rectObject
  );

  layer1.addRect(
      RectObject.fromCenter(center: PointEX(Decimal.zero,Decimal.zero), width: Decimal.fromInt(400), height: Decimal.fromInt(300))
  );

  PointObject pointObject = PointObject(Decimal.parse('50'), Decimal.parse("50"))
    ..radius = Decimal.fromInt(20)
  ;
  layer1.addPoint(
      pointObject
  );

  layer1.addPoint(
      PointObject(Decimal.zero, Decimal.ten)..radius = Decimal.fromInt(2)
  );

  //endregion

  //region 第二层 线段
  layer2.addLine(LineObject(
    PointEX(Decimal.fromInt(-200), Decimal.fromInt(-150)),
    PointEX(Decimal.fromInt(-50), Decimal.fromInt(-50)),
  ));
  layer2.addLine(LineObject(
    PointEX(Decimal.fromInt(200), Decimal.fromInt(-150)),
    PointEX(Decimal.fromInt(50), Decimal.fromInt(-50)),
  ));

  //endregion

  //region 第三层 贝塞尔曲线
  try {
    var start = PointEX(Decimal.fromInt(0), Decimal.fromInt(0));
    var end = PointEX(Decimal.fromInt(200), Decimal.fromInt(150));
    var bezier = BezierObject(start, end);
    // print(bezier);
    layer3.addBezier(bezier);

    layer3.addBezier(BezierObject(
      PointEX(Decimal.fromInt(0), Decimal.fromInt(0)),
      PointEX(Decimal.fromInt(-200), Decimal.fromInt(150)),
    ));

    layer3.addBezier(BezierObject(
      PointEX(Decimal.fromInt(100), Decimal.fromInt(0)),
      PointEX(Decimal.fromInt(300), Decimal.fromInt(-150)),
    ));
  } catch (e) {
    print('添加贝塞尔曲线发生错误');
    print(e);
  }
  //endregion

  //region 第四层 多边形
  PolygonObject polygonObject = PolygonObject(
    PointEX(Decimal.fromInt(100), Decimal.fromInt(0)),
    [
      PointEX(Decimal.fromInt(-80), Decimal.fromInt(-80)),
      PointEX(Decimal.fromInt(0), Decimal.fromInt(-100)),
      PointEX(Decimal.fromInt(80), Decimal.fromInt(-80)),
      PointEX(Decimal.fromInt(100), Decimal.fromInt(80)),
      PointEX(Decimal.fromInt(-100), Decimal.fromInt(80)),
    ]
  );
  layer4.addPolygon(polygonObject);
  //endregion


  //region 第五层 规则多边形
  EquilateralPolygonObject equilateralPolygonObject = EquilateralPolygonObject(
    PointEX(Decimal.fromInt(-300), Decimal.fromInt(0)),
    size: Decimal.fromInt(200),count:3
  );
  layer5.addEquilateralPolygon(equilateralPolygonObject);

  EquilateralPolygonObject circlePolygonObject = EquilateralPolygonObject(
      PointEX(Decimal.fromInt(-300), Decimal.fromInt(0)),
      size: Decimal.fromInt(200),count:15
  );

  layer5.addEquilateralPolygon(circlePolygonObject);

  EquilateralPolygonObject rectPolygonObject = EquilateralPolygonObject(
      PointEX(Decimal.fromInt(300), Decimal.fromInt(0)),
      size: Decimal.fromInt(200),count:4
  );

  layer5.addEquilateralPolygon(rectPolygonObject);

  EquilateralPolygonObject rect8PolygonObject = EquilateralPolygonObject(
      PointEX(Decimal.fromInt(300), Decimal.fromInt(0)),
      size: Decimal.fromInt(200),count:8
  );

  layer5.addEquilateralPolygon(rect8PolygonObject);

  EquilateralPolygonObject rect5PolygonObject = EquilateralPolygonObject(
      PointEX(Decimal.fromInt(0), Decimal.fromInt(300)),
      size: Decimal.fromInt(200),count:5
  );

  layer5.addEquilateralPolygon(rect5PolygonObject);


  //使用随机大小30-300, 随机边数3-10的多边形 在 x=-2000~+2000, y=-1000~+1000的范围内随机生成多边形并添加到layer5
  for(int i=0;i<1000;i++){
    var size = Decimal.fromInt(Random().nextInt(270)+30);
    var count = Random().nextInt(8)+3;
    var x = Decimal.fromInt(Random().nextInt(40000)-20000);
    var y = Decimal.fromInt(Random().nextInt(20000)-10000);
    var point = PointEX(x,y);
    EquilateralPolygonObject polygonObject = EquilateralPolygonObject(
        point,
        size: size,count:count
    );
    layer5.addEquilateralPolygon(polygonObject);
  }
  //endregion

  //region 第六层,正多角星
  for(int i=0;i<1000;i++){
    var size = Decimal.fromInt(Random().nextInt(270)+30);
    var count = Random().nextInt(8)+3;
    var x = Decimal.fromInt(Random().nextInt(40000)-20000);
    var y = Decimal.fromInt(Random().nextInt(20000)-10000);
    var point = PointEX(x,y);
    RegularPolygonalStarObject regularPolygonalStarObject = RegularPolygonalStarObject(
        point,count,size, null
    );
    layer6.addRegularPolygonalStart(regularPolygonalStarObject);
  }
  //endregion

  space.addPaper(paper);

  space.layers.add(layer1);
  space.layers.add(layer2);
  space.layers.add(layer3);
  space.layers.add(layer4);
  space.layers.add(layer5);
  space.layers.add(layer6);

  return space;
}