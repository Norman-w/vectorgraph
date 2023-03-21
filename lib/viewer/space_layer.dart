//space中包含多个层,层中再包含图元和组,图元由点和线等组成.组就是图元的集合

import 'package:vectorgraph/objects/line_object.dart';
import 'package:vectorgraph/objects/point_object.dart';
import '../model/geometry/rect/RectEX.dart';
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
  void addPoint(PointObject point){
    objects.add(point);
  }
  //get all rects
  // List<Rect> get rectangles => objects.whereType<Rect>().toList();

  List<SpaceObject> getInBounds(RectEX bounds){
    // print('获取范围内的对象,范围是: ${bounds}');
    var b = RectEX.fromLTWH(bounds.left, bounds.top, bounds.width, bounds.height);
    // print(b);
    return objects.where((element) {
      // print('bound is : ${element.bounds}');
      var eb = RectEX.fromLTWH(element.bounds.left, element.bounds.top, element.bounds.width, element.bounds.height);
      var contains = b.overlaps(eb);
      // print(contains );
      return contains;
      // return element.bounds.overlaps(bounds);
    }).toList();
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