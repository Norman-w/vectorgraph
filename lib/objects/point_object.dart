import 'dart:ui';

import 'package:flutter/material.dart';
import '../viewer/points_painter.dart';

import '../model/geometry/points/point_ex.dart';
import 'space_object.dart';

class PointObject extends PointEX with SpaceObject{
  double radius;
  PointObject(super.x, super.y, {this.radius = 1});
  @override
  Rect get bounds => Rect.fromCircle(center: Offset(x, y), radius: radius);
  // @override
  // Widget getWidget(Size viewPortSize, Offset viewPortOffset, double viewPortScale) {
  //   var newX = x * viewPortScale + viewPortOffset.dx + viewPortSize.width/2;
  //   var newY = y * viewPortScale + viewPortOffset.dy + viewPortSize.height/2;
  //       var newPoint = Offset(newX, newY);
  //   return CustomPaint(
  //     painter: PointPainter(newPoint, color,radius * viewPortScale),
  //   );
  // }
}