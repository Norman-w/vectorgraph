import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/lines/straight_line.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/objects/circle_object.dart';
import 'package:vectorgraph/objects/equilateral_polygon_object.dart';
import 'package:vectorgraph/objects/polygon_object.dart';
import 'package:vectorgraph/objects/regular_polygonal_star.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import 'package:vectorgraph/viewer/paper.dart';

import 'model/geometry/lines/arc.dart';
import 'model/geometry/lines/cross_info.dart';
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

class ViewState {
  PointEX _viewPortPosition = PointEX.zero;

  // Offset _viewSpaceViewPortOffset = Offset.zero;
  //region 视图空间
  // Offset get viewSpaceViewPortOffset => _viewSpaceViewPortOffset;
  Offset get viewSpaceViewPortOffset =>
      -(_viewPortPosition * viewPortScale).toOffset();

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
  ViewState copyWith() {
    return ViewState()
      .._viewPortPosition = _viewPortPosition
      // .._viewSpaceViewPortOffset = _viewSpaceViewPortOffset
      ..viewPortScale = viewPortScale
      ..viewPortSize = viewPortSize
      ..viewPortScale = viewPortScale
      ..allObjectInViewPort = allObjectInViewPort;
  }
//endregion
}

final viewStateProvider =
    StateNotifierProvider<ViewStateNotifier, ViewState>((ref) {
  return ViewStateNotifier(ViewState());
});

class ViewStateNotifier extends StateNotifier<ViewState> {
  Rect? _viewSpaceBounds;

  ViewStateNotifier(super.state);

  ///视图空间的矩形区域
  Rect? get viewSpaceBounds => _viewSpaceBounds;

  set viewSpaceBounds(Rect? value) {
    if (_viewSpaceBounds == value || value == null) {
      return;
    }
    var newState = state.copyWith()..viewPortSize = value.size;
    newState.allObjectInViewPort =
        _space.getInViewPortObjects(newState.objectSpaceViewingRect);

    state = newState;
  }

  Decimal decimal1000 = Decimal.fromInt(1000);
  Decimal decimal10000 = Decimal.fromInt(10000);
  Decimal decimalDot1 = Decimal.parse("0.1");

  ///更新当前缩放比例
  void updateViewPortScale(Decimal newScale, Offset viewSpaceCursorPosition) {
    if (newScale > decimal1000 || newScale < decimalDot1) {
      return;
    }
    var oldState = state;
    //拉点
    var cursorWorldPoint = PointEX(Decimal.fromInt(100), Decimal.zero);
    cursorWorldPoint = Space.viewPortPointPos2SpacePointPos(
        viewSpaceCursorPosition,
        oldState.viewSpaceViewPortOffset,
        oldState.viewPortScale,
        oldState.objectSpaceViewingRect.size);
    //这次是上次的倍数
    var thisTimeIsLastTimeScale = newScale / oldState.viewPortScale;
    //拉动点到中心
    var pullPoint2WorldCenter = cursorWorldPoint - oldState.viewPortPosition;
    //新的中心点
    var newViewPortPosition =
        cursorWorldPoint - (pullPoint2WorldCenter) / thisTimeIsLastTimeScale;

    var newState = oldState.copyWith()..viewPortScale = newScale;
    newState._viewPortPosition = newViewPortPosition;
    newState.allObjectInViewPort =
        _space.getInViewPortObjects(newState.objectSpaceViewingRect);
    state = newState;
  }

  ///更新当前视口偏移量
  void updateViewSpaceOffset(Offset value) {
    var newState = state.copyWith();
    // newState._viewSpaceViewPortOffset = value;
    newState._viewPortPosition =
        -PointEX.fromOffset(value) / newState.viewPortScale;
    newState.allObjectInViewPort =
        _space.getInViewPortObjects(newState.objectSpaceViewingRect);
    state = newState;
  }

  set viewPortPixelSize(Size value) {
    var newState = state.copyWith()..viewPortSize = value;
    newState.allObjectInViewPort =
        _space.getInViewPortObjects(newState.objectSpaceViewingRect);
    state = newState;
  }

  final Space _space = initSpace();
  PointEX worldPoint = PointEX.zero;
}

Space initSpace() {
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
  )
    ..left = 180
    ..top = 150;

  //region 第一层矩形和点

  RectObject rectObject = RectObject.fromCenter(
      center: PointEX(Decimal.zero, Decimal.zero),
      width: Decimal.fromInt(100),
      height: Decimal.fromInt(100));
  rectObject.position = PointEX(Decimal.fromInt(100), Decimal.fromInt(100));
  layer1.addRect(rectObject);

  layer1.addRect(RectObject.fromCenter(
      center: PointEX(Decimal.zero, Decimal.zero),
      width: Decimal.fromInt(400),
      height: Decimal.fromInt(300)));

  PointObject pointObject =
      PointObject(Decimal.parse('50'), Decimal.parse("50"))
        ..radius = Decimal.fromInt(20);
  layer1.addPoint(pointObject);

  layer1.addPoint(
      PointObject(Decimal.zero, Decimal.ten)..radius = Decimal.fromInt(2));

  layer1.addPoint(PointObject(Decimal.fromInt(50), Decimal.zero)
    ..radius = Decimal.fromInt(4));

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
  PolygonObject polygonObject =
      PolygonObject(PointEX(Decimal.fromInt(100), Decimal.fromInt(0)), [
    PointEX(Decimal.fromInt(-80), Decimal.fromInt(-80)),
    PointEX(Decimal.fromInt(0), Decimal.fromInt(-100)),
    PointEX(Decimal.fromInt(80), Decimal.fromInt(-80)),
    PointEX(Decimal.fromInt(100), Decimal.fromInt(80)),
    PointEX(Decimal.fromInt(-100), Decimal.fromInt(80)),
  ]);
  layer4.addPolygon(polygonObject);
  //endregion

  //region 第五层 规则多边形
  EquilateralPolygonObject equilateralPolygonObject = EquilateralPolygonObject(
      PointEX(Decimal.fromInt(-300), Decimal.fromInt(0)),
      size: Decimal.fromInt(200),
      count: 3);
  layer5.addEquilateralPolygon(equilateralPolygonObject);

  EquilateralPolygonObject circlePolygonObject = EquilateralPolygonObject(
      PointEX(Decimal.fromInt(-300), Decimal.fromInt(0)),
      size: Decimal.fromInt(200),
      count: 15);

  layer5.addEquilateralPolygon(circlePolygonObject);

  EquilateralPolygonObject rectPolygonObject = EquilateralPolygonObject(
      PointEX(Decimal.fromInt(300), Decimal.fromInt(0)),
      size: Decimal.fromInt(200),
      count: 4);

  layer5.addEquilateralPolygon(rectPolygonObject);

  EquilateralPolygonObject rect8PolygonObject = EquilateralPolygonObject(
      PointEX(Decimal.fromInt(300), Decimal.fromInt(0)),
      size: Decimal.fromInt(200),
      count: 8);

  layer5.addEquilateralPolygon(rect8PolygonObject);

  EquilateralPolygonObject rect5PolygonObject = EquilateralPolygonObject(
      PointEX(Decimal.fromInt(0), Decimal.fromInt(300)),
      size: Decimal.fromInt(200),
      count: 5);

  layer5.addEquilateralPolygon(rect5PolygonObject);

  //使用随机大小30-300, 随机边数3-10的多边形 在 x=-2000~+2000, y=-1000~+1000的范围内随机生成多边形并添加到layer5
  for (int i = 0; i < 1000; i++) {
    var size = Decimal.fromInt(Random().nextInt(270) + 30);
    var count = Random().nextInt(8) + 3;
    var x = Decimal.fromInt(Random().nextInt(40000) - 20000);
    var y = Decimal.fromInt(Random().nextInt(20000) - 10000);
    var point = PointEX(x, y);
    EquilateralPolygonObject polygonObject =
        EquilateralPolygonObject(point, size: size, count: count);
    layer5.addEquilateralPolygon(polygonObject);
  }
  //endregion

  //region 第六层,正多角星
  for (int i = 0; i < 1000; i++) {
    var size = Decimal.fromInt(Random().nextInt(270) + 30);
    var count = Random().nextInt(8) + 3;
    var x = Decimal.fromInt(Random().nextInt(40000) - 20000);
    var y = Decimal.fromInt(Random().nextInt(20000) - 10000);
    var point = PointEX(x, y);
    RegularPolygonalStarObject regularPolygonalStarObject =
        RegularPolygonalStarObject(point, count, size, null);
    layer6.addRegularPolygonalStart(regularPolygonalStarObject);
  }
  //endregion

  //region 第七层,圆形
  for (int i = 0; i < 1000; i++) {
    var radius = Decimal.fromInt(Random().nextInt(70) + 30);
    var x = Decimal.fromInt(Random().nextInt(40000) - 20000);
    var y = Decimal.fromInt(Random().nextInt(20000) - 10000);
    var point = PointEX(x, y);
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
      EllipseObject(PointEX.zero, Decimal.fromInt(100), Decimal.fromInt(50)));

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
    true,
    false,
    PointEX(Decimal.fromInt(100), Decimal.fromInt(50)),
  );
  //给定的参数没有有效的弧线,显示一条红色的线段
  ArcObject arcObject1 = ArcObject.fromSVG(
    PointEX(Decimal.fromInt(0), Decimal.fromInt(0)),
    Decimal.fromInt(100),
    Decimal.fromInt(50),
    Decimal.fromInt(30),
    true,
    true,
    PointEX(Decimal.fromInt(100), Decimal.fromInt(50)),
  );

  //测试svg参数到canvas参数填充的有效性

  //测试将转化来的canvas参数再转换回svg参数,看看方法有没有问题

  ArcObject arcObject2 = ArcObject.fromSVG(
    PointEX(Decimal.fromInt(400), Decimal.fromInt(300)),
    Decimal.fromInt(100),
    Decimal.fromInt(50),
    Decimal.fromInt(90),
    true,
    true,
    PointEX(Decimal.fromInt(450), Decimal.fromInt(350)),
  );

  // print(arcObject2.toString());

  ArcObject arcObject3 = ArcObject.fromCanvas(
    //矩形,如果是正圆的时候,旋转也能正常检测鼠标交互点
    //   Rect.fromLTWH(100,-100,200,200),
    const Rect.fromLTWH(100, -100, 400, 200),
    //旋转,如果是正圆的时候,旋转是没有问题的
    // 30.0.toDecimal()*decimalPerDegree,
    0.0.toDecimal() * decimalPerDegree,
    //圆弧的起始角度
    50.0.toDecimal() * decimalPerDegree,
    //圆弧的旋转角度,旋转正20度和旋转负340度是一样的终点
    20.0.toDecimal() * decimalPerDegree,
    // -340.0.toDecimal()*decimalPerDegree
  );
  // print("arcObject3 = $arcObject3");
  arcObject3 = ArcObject.fromSVG(
      arcObject3.startPoint,
      arcObject3.rx,
      arcObject3.ry,
      arcObject3.rotationDegrees,
      false,
      true,
      arcObject3.endPoint);

  // layer9.addArc(arcObject);
  // layer9.addArc(arcObject1);
  // layer9.addArc(arcObject2);
  layer9.addArc(arcObject3);

  //region 随机的弧线
  for(int i=0;i<1000;i++){
    var radiusX = Decimal.fromInt(Random().nextInt(100)+50);
    var radiusY = Decimal.fromInt(Random().nextInt(100)+50);
    var startX = Decimal.fromInt(Random().nextInt(40000)-20000);
    var startY = Decimal.fromInt(Random().nextInt(20000)-10000);
    var endX = Decimal.fromInt(Random().nextInt(200)-100) + startX;
    var endY = Decimal.fromInt(Random().nextInt(200)-100) + startY;
    var rotationDegrees = Decimal.fromInt(Random().nextInt(360));
    var laf = Random().nextBool();
    var sf = Random().nextBool();
    ArcObject arcObject = ArcObject.fromSVG(
      PointEX(startX, startY),
      radiusX,
      radiusY,
      rotationDegrees,
      laf,sf,
      PointEX(endX, endY),
    );
    layer9.addArc(arcObject);
  }
  //endregion
  //endregion

  addTestArcList2SpaceLayer(layer9);

  space.addPaper(paper);
  //
  // space.layers.add(layer1);
  // space.layers.add(layer2);
  // space.layers.add(layer3);
  // space.layers.add(layer4);
  // space.layers.add(layer5);
  // space.layers.add(layer6);
  // space.layers.add(layer7);
  // space.layers.add(layer8);
  space.layers.add(layer9);

  //给定一个矩形和矩形内部的两个点,计算两点组成的直线与矩形的交点
  var rect = RectEX(Decimal.fromDouble(0), Decimal.fromDouble(0),
      Decimal.fromDouble(100), Decimal.fromDouble(100));
  var p1 = PointEX(Decimal.fromDouble(50), Decimal.fromDouble(20));
  var p2 = PointEX(Decimal.fromDouble(20), Decimal.fromDouble(50));
  var crossPoint = getTwoPointCrossRectEdge(p1, p2, rect);
  print("crossPoint = $crossPoint");

  var info = StraightLine.getCrossPoint(
    PointEX(Decimal.fromDouble(50), Decimal.fromDouble(20)),
    PointEX(Decimal.fromDouble(20), Decimal.fromDouble(50)),
    PointEX(Decimal.fromDouble(100), Decimal.fromDouble(0)),
    PointEX(Decimal.fromDouble(100), Decimal.fromDouble(100)),
  );
  print('info = $info');
  return space;
}

///添加弧线的测试数据到SpaceLayer中
void addTestArcList2SpaceLayer(SpaceLayer layer) {
  //添加的弧线按照跨越象限来分
  //第一种不只在单独一个象限中
  //第二种跨越相邻的下一个象限
  //第三种跨越相邻的两个象限
  //第四种跨越相邻的三个象限
  //第五种四个象限都跨越

  //每种当中都有两种情况,一种是顺时针,一种是逆时针
  var position = PointEX(Decimal.fromInt(-400), Decimal.fromInt(-400));
  //从横向x轴作为起点,0点坐标的右下角作为第一个象限.
  //第一条样本弧线为起始角度22.5度,所占45度,顺时针
  //第二条样本弧线在第二个象限,起始角度为22.5+90度,所占45度,顺时针
  //第三条样本弧线在第三个象限,起始角度为22.5+180度,所占45度,顺时针
  //第四条样本弧线在第四个象限,起始角度为22.5+270度,所占45度,顺时针

  var startAngle = Decimal.fromInt(22) * decimalPerDegree;
  var sweepAngle = Decimal.fromInt(45) * decimalPerDegree;
  var radiusX = Decimal.fromInt(50);
  var radiusY = Decimal.fromInt(50);
  var arcObject = ArcObject.fromCanvas(
    Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
        radiusX.toDouble() * 2, radiusY.toDouble() * 2),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
        radiusX.toDouble() * 2, radiusY.toDouble() * 2),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
        radiusX.toDouble() * 2, radiusY.toDouble() * 2),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
        radiusX.toDouble() * 2, radiusY.toDouble() * 2),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  position = PointEX(Decimal.fromInt(-400), Decimal.fromInt(-200));
  //第二种情况,跨越相邻的象限
  //第一条样本弧线为起始角度22.5度,所占180-45=135度,顺时针
  //第二条样本弧线在第二个象限,起始角度为22.5+90度,所占180-45=135度,顺时针
  //第三条样本弧线在第三个象限,起始角度为22.5+180度,所占180-45=135度,顺时针
  //第四条样本弧线在第四个象限,起始角度为22.5+270度,所占180-45=135度,顺时针

  startAngle = Decimal.fromInt(22) * decimalPerDegree;
  sweepAngle = Decimal.fromInt(135) * decimalPerDegree;
  arcObject = ArcObject.fromCanvas(
    Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
        radiusX.toDouble() * 2, radiusY.toDouble() * 2),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
        radiusX.toDouble() * 2, radiusY.toDouble() * 2),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
        radiusX.toDouble() * 2, radiusY.toDouble() * 2),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
        radiusX.toDouble() * 2, radiusY.toDouble() * 2),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  position = PointEX(Decimal.fromInt(-400), Decimal.fromInt(0));
  //第三种情况,跨越相邻的两个象限
  //第一条样本弧线为起始角度22.5度,所占180+45=225度,顺时针
  //第二条样本弧线在第二个象限,起始角度为22.5+90度,所占180+45=225度,顺时针
  //第三条样本弧线在第三个象限,起始角度为22.5+180度,所占180+45=225度,顺时针
  //第四条样本弧线在第四个象限,起始角度为22.5+270度,所占180+45=225度,顺时针

  startAngle = Decimal.fromInt(22) * decimalPerDegree;
  sweepAngle = Decimal.fromInt(225) * decimalPerDegree;
  arcObject = ArcObject.fromCanvas(
    Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
        radiusX.toDouble() * 2, radiusY.toDouble() * 2),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
        radiusX.toDouble() * 2, radiusY.toDouble() * 2),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
        radiusX.toDouble() * 2, radiusY.toDouble() * 2),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
        radiusX.toDouble() * 2, radiusY.toDouble() * 2),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  position = PointEX(Decimal.fromInt(-400), Decimal.fromInt(200));
  //第五种情况,跨越所有的象限
  //第一条样本弧线为起始角度90-22.5=67.5度,所占360-45=315度,顺时针
  //第二条样本弧线在第二个象限,起始角度为67.5+90度,所占360-45=315度,顺时针
  //第三条样本弧线在第三个象限,起始角度为67.5+180度,所占360-45=315度,顺时针
  //第四条样本弧线在第四个象限,起始角度为67.5+270度,所占360-45=315度,顺时针

  startAngle = Decimal.fromInt(67) * decimalPerDegree;
  sweepAngle = Decimal.fromInt(315) * decimalPerDegree;
  arcObject = ArcObject.fromCanvas(
    Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
        radiusX.toDouble() * 2, radiusY.toDouble() * 2),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
        radiusX.toDouble() * 2, radiusY.toDouble() * 2),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
        radiusX.toDouble() * 2, radiusY.toDouble() * 2),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
        radiusX.toDouble() * 2, radiusY.toDouble() * 2),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  //下面是逆时针弧
  // 象限的顺序还是跟之前一样,只是弧线的方向变了
  // 第一条弧线是从67.5度开始,逆时针,旋转-45度,后面的三个横向位移跟之前一样,每一个都是角度+90度,旋转-45度
  // 第一种的逆时针4个象限的弧线
  position = PointEX(Decimal.fromInt(0), Decimal.fromInt(-400));
  startAngle = Decimal.fromInt(67) * decimalPerDegree;
  sweepAngle = Decimal.fromInt(-45) * decimalPerDegree;
  for (int i = 0; i < 4; i++) {
    arcObject = ArcObject.fromCanvas(
      Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
          radiusX.toDouble() * 2, radiusY.toDouble() * 2),
      Decimal.zero,
      startAngle,
      sweepAngle,
    );
    layer.addArc(arcObject);
    startAngle += Decimal.fromInt(90) * decimalPerDegree;
    position += PointEX(Decimal.fromInt(100), Decimal.zero);
  }
  //第二种的逆时针4个象限的弧线
  position = PointEX(Decimal.fromInt(0), Decimal.fromInt(-200));
  startAngle = Decimal.fromInt(67 + 90) * decimalPerDegree;
  sweepAngle = Decimal.fromInt(-135) * decimalPerDegree;
  for (int i = 0; i < 4; i++) {
    arcObject = ArcObject.fromCanvas(
      Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
          radiusX.toDouble() * 2, radiusY.toDouble() * 2),
      Decimal.zero,
      startAngle,
      sweepAngle,
    );
    layer.addArc(arcObject);
    startAngle += Decimal.fromInt(90) * decimalPerDegree;
    position += PointEX(Decimal.fromInt(100), Decimal.zero);
  }
  //第三种的逆时针4个象限的弧线
  position = PointEX(Decimal.fromInt(0), Decimal.fromInt(0));
  startAngle = Decimal.fromInt(67 + 180) * decimalPerDegree;
  sweepAngle = Decimal.fromInt(-225) * decimalPerDegree;
  for (int i = 0; i < 4; i++) {
    arcObject = ArcObject.fromCanvas(
      Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
          radiusX.toDouble() * 2, radiusY.toDouble() * 2),
      Decimal.zero,
      startAngle,
      sweepAngle,
    );
    layer.addArc(arcObject);
    startAngle += Decimal.fromInt(90) * decimalPerDegree;
    position += PointEX(Decimal.fromInt(100), Decimal.zero);
  }
  //第四种的逆时针4个象限的弧线
  position = PointEX(Decimal.fromInt(0), Decimal.fromInt(200));
  startAngle = Decimal.fromInt(67 + 270) * decimalPerDegree;
  sweepAngle = Decimal.fromInt(-315) * decimalPerDegree;
  for (int i = 0; i < 4; i++) {
    arcObject = ArcObject.fromCanvas(
      Rect.fromLTWH(position.x.toDouble(), position.y.toDouble(),
          radiusX.toDouble() * 2, radiusY.toDouble() * 2),
      Decimal.zero,
      startAngle,
      sweepAngle,
    );
    layer.addArc(arcObject);
    startAngle += Decimal.fromInt(90) * decimalPerDegree;
    position += PointEX(Decimal.fromInt(100), Decimal.zero);
  }
  //2023年09月24日00:25:50经过验证,使用如下检测方法
  /*
  var isInAngle = false;

    if(sweepAngle>Decimal.zero){
      if(startAngle <= centerToMouseAngle && centerToMouseAngle <= endAngle){
        isInAngle = true;
      }
    }
    else{
      if(endAngle <= centerToMouseAngle && centerToMouseAngle <= startAngle){
        isInAngle = true;
      }
    }

    if(!isInAngle){
      return false;
    }
  * */
  /*
  如果弧线是跨越过了 0,0 -> 0,>0(3点)方向的线,那么就会出现问题
  计算时,3点方向为0,顺时针旋转到9点的时候为π,旋转回到3点的时候为2π
  如果一个弧线,从1点到5点,判断条件不可以为: 1点<=鼠标角度<=5点
  而是使用: 1点<=鼠标角度<=2π 或者 0<=鼠标角度<=5点 区间的点都是有效的,如不在这个区间,就是无效的
  所以改进后的逻辑应该为
  先判断是否跨越3点线(0,2π)
  如果通过一般的方式没有判断到圆弧角度内,那么就判断是否跨越了3点线(0,2π)
  如果旋转角度是顺时针的,从起点加上旋转角度,如果大于2π,就是跨越了3点线
  如果旋转角度是逆时针的,从起点减去旋转角度,如果小于0,就是跨越了3点线,因为旋转角度这个时候本身就是负数,所以就是判断startAngle+sweepAngle是否小于0
  如果跨越了3点线,那么就要拆分成两段来判断,一段是从起点到3点线的,一段是从3点线到终点的
   */
}
