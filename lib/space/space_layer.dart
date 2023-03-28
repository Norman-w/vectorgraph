//space中包含多个层,层中再包含图元和组,图元由点和线等组成.组就是图元的集合

import 'package:vectorgraph/objects/equilateral_polygon_object.dart';
import 'package:vectorgraph/objects/line_object.dart';
import 'package:vectorgraph/objects/point_object.dart';
import 'package:vectorgraph/objects/polygon_object.dart';
import 'package:vectorgraph/objects/regular_polygonal_star.dart';
import '../model/geometry/rect/RectEX.dart';
import '../objects/bezier_object.dart';
import '../objects/circle_object.dart';
import '../objects/ellipse_object.dart';
import '../objects/rect_object.dart';
import '../objects/space_object.dart';

class SpaceLayer{
  String name;
  int zIndex;
  //dynamic objects list
  final objects = <SpaceObject>[];
  SpaceLayer(this.zIndex, {this.name = ''});
  void addRect(RectObject rect){
    objects.add(rect);
  }
  void addLine(LineObject line){
    objects.add(line);
  }
  void addBezier(BezierObject bezier){
    objects.add(bezier);
  }
  void addPoint(PointObject point){
    objects.add(point);
  }
  void addPolygon(PolygonObject polygonObject){
    objects.add(polygonObject);
  }
  void addEquilateralPolygon(EquilateralPolygonObject equilateralPolygonObject){
    objects.add(equilateralPolygonObject);
  }
  void addRegularPolygonalStart(RegularPolygonalStarObject regularPolygonalStarObject){
    objects.add(regularPolygonalStarObject);
  }
  void addCircle(CircleObject circleObject){
    objects.add(circleObject);
  }
  void addEllipse(EllipseObject ellipseObject){
    objects.add(ellipseObject);
  }
  //get all rects
  // List<Rect> get rectangles => objects.whereType<Rect>().toList();

  List<SpaceObject> getInBounds(RectEX bounds){
    if(bounds.isEmpty){return [];}
    var b = RectEX.fromLTWH(bounds.left, bounds.top, bounds.width, bounds.height);
    var ret = objects.where((element) {
      var eb = RectEX.fromLTWH(
          element.worldBounds.left,
          element.worldBounds.top,
          element.worldBounds.width,
          element.worldBounds.height);
      var contains = b.overlaps(eb);
      return contains;
      // return element.bounds.overlaps(bounds);
    }).toList();
    return ret;
   //region 或许这样的精度也可以
    // return objects.where((element) {
    //   var contains = element.bounds.overlaps(bounds);
    //   if(!contains){
    //     print('not contains 元素 ${element.bounds} 外围 ${bounds}');
    //   }
    //   return contains;
    // }
    // ).toList();
    //endregion
  }
}