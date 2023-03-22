import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:vectorgraph/objects/equilateral_polygon_object.dart';
import 'package:vectorgraph/objects/point_object.dart';
import 'package:vectorgraph/objects/polygon_object.dart';
import 'package:vectorgraph/objects/rect_object.dart';
import 'package:vectorgraph/objects/regular_polygonal_star.dart';


import '../model/geometry/points/point_ex.dart';
import '../objects/bezier_object.dart';
import '../objects/line_object.dart';
import 'ruler.dart';
import '../view_state.dart';

class ViewPort extends ConsumerWidget {
  const ViewPort({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // RectEX rect1 = RectEX(Decimal.zero,Decimal.zero, Decimal.ten, Decimal.ten);
    // RectEX rect2 = RectEX(Decimal.fromInt(9), Decimal.fromInt(8),Decimal.fromInt(15),Decimal.fromInt(9));
    //
    // bool ii = rect1.overlaps(rect2);
    // print('矩形1是否和矩形2相交? $ii');

    var state = ref.watch(viewStateProvider);
    var center = (-PointEX.fromOffset(state.currentOffset) / state.currentScale).toOffset();
    var width = state.validViewPortSizeOfSpace.width.toDouble();
    var height = state.validViewPortSizeOfSpace.height.toDouble();
    Rect rulerRect = Rect.fromCenter(center: center, width: width, height: height);


    var allObjectInViewPort = state.allObjectInViewPort;
    var allObjectInViewPortWidget = allObjectInViewPort.map((e) {
      if(e.runtimeType == RectObject){
        var rect = e as RectObject;
        return RectObjectWidget(rectObject: rect,
          viewPortPixelSize: state.viewPortPixelSize,
          viewPortOffset: state.currentOffset,
          viewPortScale: state.currentScale,
        );
      }
      else if(e.runtimeType == PointObject){
        PointObject point = e as PointObject;
        return PointObjectWidget(pointObject: point,
          viewPortPixelSize: state.viewPortPixelSize,
          viewPortOffset: state.currentOffset,
          viewPortScale: state.currentScale,
          // normalColor: Colors.deepOrange,
        );
      }
      else if(e.runtimeType == LineObject){
        LineObject line = e as LineObject;
        return LineObjectWidget(lineObject: line,
          viewPortPixelSize: state.viewPortPixelSize,
          viewPortOffset: state.currentOffset,
          viewPortScale: state.currentScale,
          // normalColor: Colors.deepOrange,
        );
      }
      else if(e.runtimeType == BezierObject){
        BezierObject bezier = e as BezierObject;
        return BezierObjectWidget(bezierObject: bezier,
          viewPortPixelSize: state.viewPortPixelSize,
          viewPortOffset: state.currentOffset,
          viewPortScale: state.currentScale,
          // normalColor: Colors.deepOrange,
        );
      }
      else if(e.runtimeType == PolygonObject){
        PolygonObject polygonObject = e as PolygonObject;
        return PolygonObjectWidget(polygonObject: polygonObject,
          viewPortPixelSize: state.viewPortPixelSize,
          viewPortOffset: state.currentOffset,
          viewPortScale: state.currentScale,
          // normalColor: Colors.deepOrange,
        );
      }
      else if(e.runtimeType == EquilateralPolygonObject){
        EquilateralPolygonObject polygonObject = e as EquilateralPolygonObject;
        return EquilateralPolygonObjectWidget(equilateralPolygonObject: polygonObject,
          viewPortPixelSize: state.viewPortPixelSize,
          viewPortOffset: state.currentOffset,
          viewPortScale: state.currentScale,
          // normalColor: Colors.deepOrange,
        );
      }
      else if(e.runtimeType == RegularPolygonalStarObject){
        RegularPolygonalStarObject star = e as RegularPolygonalStarObject;
        return RegularPolygonalStarWidget(polygonObject: star,
          viewPortPixelSize: state.viewPortPixelSize,
          viewPortOffset: state.currentOffset,
          viewPortScale: state.currentScale,
          // normalColor: Colors.deepOrange,
        );
      }
      return Container();
    }).toList();

    return Stack(
      children: [
        //绘制所有物件(通过物件转换成widget)
        ...allObjectInViewPortWidget,
        SizedBox(
            width: state.viewPortPixelSize.width,
            height: state.viewPortPixelSize.height,
            child: Ruler(
                rulerRect
            )
        ),
      ],
    );
  }
}
