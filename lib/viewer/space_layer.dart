//space中包含多个层,层中再包含图元和组,图元由点和线等组成.组就是图元的集合

import 'dart:ui';

class SpaceLayer{
  String name;
  int zIndex;
  //dynamic objects list
  final objects = <Object>[];
  SpaceLayer(this.zIndex, {this.name = ''});
  void addRect(Rect rect){
    objects.add(rect);
  }
  //get all rects
  List<Rect> get rects => objects.whereType<Rect>().toList();
}