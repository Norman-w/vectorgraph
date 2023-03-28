import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:vectorgraph/objects/circle_object.dart';
import 'package:vectorgraph/objects/ellipse_object.dart';
import 'package:vectorgraph/objects/equilateral_polygon_object.dart';
import 'package:vectorgraph/objects/point_object.dart';
import 'package:vectorgraph/objects/polygon_object.dart';
import 'package:vectorgraph/objects/rect_object.dart';
import 'package:vectorgraph/objects/regular_polygonal_star.dart';


import '../objects/arc_object.dart';
import '../objects/bezier_object.dart';
import '../objects/line_object.dart';
import 'ruler.dart';
import '../view_state.dart';
import 'widget_of_object/arc_object_widget.dart';
import 'widget_of_object/circle_object_widget.dart';
import 'widget_of_object/ellipse_object_widget.dart';
import 'widget_of_object/bezier_object_widget.dart';
import 'widget_of_object/equilateral_polygon_object_widget.dart';
import 'widget_of_object/line_object_widget.dart';
import 'widget_of_object/point_object_widget.dart';
import 'widget_of_object/polygon_object_widget.dart';
import 'widget_of_object/ragular_polygonal_star_widget.dart';
import 'widget_of_object/rect_object_widget.dart';

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
    var center = state.objectSpaceViewingRect.center.toOffset();
    var width = state.objectSpaceViewingRect.width.toDouble();
    var height = state.objectSpaceViewingRect.height.toDouble();
    Rect rulerRect = Rect.fromCenter(center: center, width: width, height: height);


    var allObjectInViewPort = state.allObjectInViewPort;
    var allObjectInViewPortWidget = allObjectInViewPort.map((e) {
      if(e.runtimeType == RectObject){
        var rect = e as RectObject;
        return RectObjectWidget(rectObject: rect,
          viewPortPixelSize: state.viewPortSize,
          viewPortOffset: state.viewSpaceViewPortOffset,
          viewPortScale: state.viewPortScale,
        );
      }
      else if(e.runtimeType == PointObject){
        PointObject point = e as PointObject;
        return PointObjectWidget(pointObject: point,
          viewPortPixelSize: state.viewPortSize,
          viewPortOffset: state.viewSpaceViewPortOffset,
          viewPortScale: state.viewPortScale,
          // normalColor: Colors.deepOrange,
        );
      }
      else if(e.runtimeType == LineObject){
        LineObject line = e as LineObject;
        return LineObjectWidget(lineObject: line,
          viewPortPixelSize: state.viewPortSize,
          viewPortOffset: state.viewSpaceViewPortOffset,
          viewPortScale: state.viewPortScale,
          // normalColor: Colors.deepOrange,
        );
      }
      else if(e.runtimeType == BezierObject){
        BezierObject bezier = e as BezierObject;
        return BezierObjectWidget(bezierObject: bezier,
          viewPortPixelSize: state.viewPortSize,
          viewPortOffset: state.viewSpaceViewPortOffset,
          viewPortScale: state.viewPortScale,
          // normalColor: Colors.deepOrange,
        );
      }
      else if(e.runtimeType == PolygonObject){
        PolygonObject polygonObject = e as PolygonObject;
        return PolygonObjectWidget(polygonObject: polygonObject,
          viewPortPixelSize: state.viewPortSize,
          viewPortOffset: state.viewSpaceViewPortOffset,
          viewPortScale: state.viewPortScale,
          // normalColor: Colors.deepOrange,
        );
      }
      else if(e.runtimeType == EquilateralPolygonObject){
        EquilateralPolygonObject polygonObject = e as EquilateralPolygonObject;
        return EquilateralPolygonObjectWidget(equilateralPolygonObject: polygonObject,
          viewPortPixelSize: state.viewPortSize,
          viewPortOffset: state.viewSpaceViewPortOffset,
          viewPortScale: state.viewPortScale,
          // normalColor: Colors.deepOrange,
        );
      }
      else if(e.runtimeType == RegularPolygonalStarObject){
        RegularPolygonalStarObject star = e as RegularPolygonalStarObject;
        return RegularPolygonalStarWidget(polygonObject: star,
          viewPortPixelSize: state.viewPortSize,
          viewPortOffset: state.viewSpaceViewPortOffset,
          viewPortScale: state.viewPortScale,
          // normalColor: Colors.deepOrange,
        );
      }
      else if(e.runtimeType == CircleObject){
        CircleObject circle = e as CircleObject;
        return CircleObjectWidget(circleObject: circle,
          viewPortPixelSize: state.viewPortSize,
          viewPortOffset: state.viewSpaceViewPortOffset,
          viewPortScale: state.viewPortScale,
        );
      }
      else if(e.runtimeType == EllipseObject){
        EllipseObject ellipse = e as EllipseObject;
        return EllipseObjectWidget(ellipseObject: ellipse,
          viewPortPixelSize: state.viewPortSize,
          viewPortOffset: state.viewSpaceViewPortOffset,
          viewPortScale: state.viewPortScale,
        );
      }
      else if(e.runtimeType == ArcObject){
        ArcObject arc = e as ArcObject;
        return ArcObjectWidget(arcObject: arc,
          viewPortPixelSize: state.viewPortSize,
          viewPortOffset: state.viewSpaceViewPortOffset,
          viewPortScale: state.viewPortScale,
        );
      }
      return Container();
    }).toList();

    return Stack(
      children: [
        //绘制所有物件(通过物件转换成widget)
        ...allObjectInViewPortWidget,
        SizedBox(
            width: state.viewPortSize.width,
            height: state.viewPortSize.height,
            child: Ruler(
                rulerRect
            )
        ),
      ],
    );
  }
}
