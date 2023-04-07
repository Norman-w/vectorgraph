import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/objects/circle_object.dart';
import 'package:vectorgraph/objects/equilateral_polygon_object.dart';
import 'package:vectorgraph/objects/polygon_object.dart';
import 'package:vectorgraph/objects/regular_polygonal_star.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import 'package:vectorgraph/viewer/paper.dart';

import 'model/geometry/lines/arc.dart';
import 'model/geometry/planes/ellipse.dart';
import 'model/geometry/rect/RectEX.dart';
import 'objects/arc_object.dart';
import 'objects/bezier_object.dart';
import 'objects/ellipse_object.dart';
import 'objects/line_object.dart';
import 'objects/point_object.dart';
import 'objects/rect_object.dart';
import 'space/space.dart';
import 'objects/space_object.dart';
import 'space/space_layer.dart';

class ViewState{
  PointEX _viewPortPosition = PointEX.zero;
  // Offset _viewSpaceViewPortOffset = Offset.zero;
  //region 视图空间
  // Offset get viewSpaceViewPortOffset => _viewSpaceViewPortOffset;
  Offset get viewSpaceViewPortOffset => -(_viewPortPosition * viewPortScale).toOffset();
  ///视口聚焦的位置,因为是鼠标往右拖动,视口中心实际上是在左移,所以是负数
  PointEX get viewPortPosition => _viewPortPosition;
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
        .._viewPortPosition = _viewPortPosition
        // .._viewSpaceViewPortOffset = _viewSpaceViewPortOffset
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
  void updateViewPortScale(Decimal newScale, Offset viewSpaceCursorPosition) {
    if(newScale > decimal1000 || newScale < decimalDot1){
      return;
    }
    var oldState = state;
    //拉点
    var cursorWorldPoint = PointEX(Decimal.fromInt(100),Decimal.zero);
    cursorWorldPoint = Space.viewPortPointPos2SpacePointPos(
        viewSpaceCursorPosition,
        oldState.viewSpaceViewPortOffset,
        oldState.viewPortScale,
        oldState.objectSpaceViewingRect.size
    );
    //这次是上次的倍数
    var thisTimeIsLastTimeScale = newScale / oldState.viewPortScale;
    //拉动点到中心
    var pullPoint2WorldCenter = cursorWorldPoint - oldState.viewPortPosition;
    //新的中心点
    var newViewPortPosition = cursorWorldPoint - (pullPoint2WorldCenter) / thisTimeIsLastTimeScale;

    var newState = oldState.copyWith()..viewPortScale = newScale;
    newState._viewPortPosition = newViewPortPosition;
    newState.allObjectInViewPort = _space.getInViewPortObjects(newState.objectSpaceViewingRect);
    state = newState;
  }
  ///更新当前视口偏移量
  void updateViewSpaceOffset(Offset value) {
    var newState = state.copyWith();
    // newState._viewSpaceViewPortOffset = value;
    newState._viewPortPosition = -PointEX.fromOffset(value)/newState.viewPortScale;
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
  var layer6 = SpaceLayer(5);
  var layer7 = SpaceLayer(6);
  var layer8 = SpaceLayer(7);
  var layer9 = SpaceLayer(9);



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

  layer1.addPoint(
      PointObject(Decimal.fromInt(50), Decimal.zero)..radius = Decimal.fromInt(4)
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

  //region 第七层,圆形
  for(int i=0;i<1000;i++){
    var radius = Decimal.fromInt(Random().nextInt(70)+30);
    var x = Decimal.fromInt(Random().nextInt(40000)-20000);
    var y = Decimal.fromInt(Random().nextInt(20000)-10000);
    var point = PointEX(x,y);
    CircleObject circleObject = CircleObject(point, radius);
    layer6.addCircle(circleObject);
  }
  //endregion

  //region 第八层,椭圆和验证椭圆的点
  Ellipse ellipse = Ellipse()
    ..radiusX = Decimal.fromInt(50)
    ..radiusY = Decimal.fromInt(25);

  // for(var i=0;i<360;i++){
  //   var pt = ellipse.getOnEdgePointByAngle(Decimal.fromInt(i));
  //   PointObject pointObject = PointObject(pt.x,pt.y);
  //   layer8.addPoint(pointObject);
  // }

  layer8.addEllipse(
    EllipseObject(
      PointEX.zero
      ,Decimal.fromInt(100)
      ,Decimal.fromInt(50)
  ));

  // var pt = ellipse.getOnEdgePointByAngle(Decimal.fromInt(15));
  // print(pt);
  //endregion

  //region 第九层,圆弧
  //这样因为弧线所在的椭圆上得不到这样一个弧,所以绘制时候直接绘制为直线.
  ArcObject arcObject = ArcObject.fromSVG(
    PointEX(Decimal.fromInt(0), Decimal.fromInt(0)),
    Decimal.fromInt(100),
    Decimal.fromInt(50),
    Decimal.fromInt(90),
    true,true,
    PointEX(Decimal.fromInt(100), Decimal.fromInt(50)),
  );
  //
  ArcObject arcObject1 = ArcObject.fromSVG(
    PointEX(Decimal.fromInt(0), Decimal.fromInt(0)),
    Decimal.fromInt(100),
    Decimal.fromInt(50),
    Decimal.fromInt(30),
    true,true,
    PointEX(Decimal.fromInt(100), Decimal.fromInt(50)),
  );


  //测试svg参数到canvas参数填充的有效性

  //测试将转化来的canvas参数再转换回svg参数,看看方法有没有问题

  ArcObject arcObject2 = ArcObject.fromSVG(
    PointEX(Decimal.fromInt(400), Decimal.fromInt(300)),
    Decimal.fromInt(100),
    Decimal.fromInt(50),
    Decimal.fromInt(90),
    true,true,
    PointEX(Decimal.fromInt(450), Decimal.fromInt(350)),
  );

  // print(arcObject2.toString());

  ArcObject arcObject3 = ArcObject.fromCanvas(
    //矩形
      Rect.fromLTWH(100,-100,200,200),
      //旋转
      0.0.toDecimal()*decimalPerDegree,
      //开始
      45.0.toDecimal()*decimalPerDegree,
      //结束
      90.0.toDecimal()*decimalPerDegree
  );
  // print("arcObject3 = $arcObject3");


  // layer9.addArc(arcObject);
  // layer9.addArc(arcObject1);
  // layer9.addArc(arcObject2);
  layer9.addArc(arcObject3);



  //region 随机的弧线
  // for(int i=0;i<1000;i++){
  //   var radiusX = Decimal.fromInt(Random().nextInt(100)+50);
  //   var radiusY = Decimal.fromInt(Random().nextInt(100)+50);
  //   var startX = Decimal.fromInt(Random().nextInt(40000)-20000);
  //   var startY = Decimal.fromInt(Random().nextInt(20000)-10000);
  //   var endX = Decimal.fromInt(Random().nextInt(200)-100) + startX;
  //   var endY = Decimal.fromInt(Random().nextInt(200)-100) + startY;
  //   var rotationDegrees = Decimal.fromInt(Random().nextInt(360));
  //   var laf = Random().nextBool();
  //   var sf = Random().nextBool();
  //   ArcObject arcObject = ArcObject.fromSVG(
  //     PointEX(startX, startY),
  //     radiusX,
  //     radiusY,
  //     rotationDegrees,
  //     laf,sf,
  //     PointEX(endX, endY),
  //   );
  //   layer9.addArc(arcObject);
  // }
  //endregion
  //endregion

  space.addPaper(paper);

  space.layers.add(layer1);
  space.layers.add(layer2);
  space.layers.add(layer3);
  space.layers.add(layer4);
  space.layers.add(layer5);
  space.layers.add(layer6);
  space.layers.add(layer7);
  space.layers.add(layer8);
  space.layers.add(layer9);
  return space;
}