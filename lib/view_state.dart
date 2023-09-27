import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/test_view_state_data/arc.dart';
import 'package:vectorgraph/test_view_state_data/bounded_rect.dart';
import 'package:vectorgraph/test_view_state_data/line.dart';
import 'package:vectorgraph/test_view_state_data/rect_and_point.dart';
import 'package:vectorgraph/test_view_state_data/sector.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import 'package:vectorgraph/viewer/paper.dart';
import 'model/geometry/rect/RectEX.dart';
import 'space/space.dart';
import 'objects/space_object.dart';
import 'space/space_layer.dart';
import 'test_view_state_data/bezier.dart';
import 'test_view_state_data/circle.dart';
import 'test_view_state_data/ellipse.dart';
import 'test_view_state_data/equilateralPolygon.dart';
import 'test_view_state_data/polygon.dart';
import 'test_view_state_data/regularPolygonalStar.dart';

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
  var layer10 = SpaceLayer(10);
  var layer11 = SpaceLayer(11);

  var paper = Paper(
    name: "paper1",
    width: 400,
    height: 300,
    color: Colors.lightGreen,
  )
    ..left = 180
    ..top = 150;

  //region 第一层矩形和点
  addTestRectAndPoint2SpaceLayer(layer1);
  //endregion

  //region 第二层 线段
  addTestLineList2SpaceLayer(layer2);
  //endregion

  //region 第三层 简易的贝塞尔曲线
  addBezierList2SpaceLayer(layer3);
  //endregion

  //region 第四层 多边形
  addPolygonList2SpaceLayer(layer4);
  //endregion

  //region 第五层 规则多边形
  addEquilateralPolygonList2SpaceLayer(layer5);
  //endregion

  //region 第六层,正多角星
  addRegularPolygonalStarList2SpaceLayer(layer6);
  //endregion

  //region 第七层,圆形
  addCircleList2SpaceLayer(layer7);
  //endregion

  //region 第八层,椭圆和验证椭圆的点
  addEllipseList2SpaceLayer(layer8);
  //endregion

  //region 第九层,圆弧
  addTestArcList2SpaceLayer(layer9);
  //endregion

  //region 第十层,扇形
  addTestSectorList2SpaceLayer(layer10);
  //endregion

  //region 第十一层,圆角矩形
  addBoundedRectAndPoint2SpaceLayer(layer11);

  space.addPaper(paper);
  //
  space.layers.add(layer1);
  space.layers.add(layer2);
  space.layers.add(layer3);
  space.layers.add(layer4);
  space.layers.add(layer5);
  space.layers.add(layer6);
  space.layers.add(layer7);
  space.layers.add(layer8);
  space.layers.add(layer9);
  space.layers.add(layer10);
  space.layers.add(layer11);

  return space;
}
