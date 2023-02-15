import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:vectorgraph/viewer/rect_painter.dart';

import 'space_object.dart';

class RectEX extends Rect with SpaceObject{
  RectEX.fromCenter({required super.center, required super.width, required super.height}) : super.fromCenter();
  RectEX.fromLTWH(double left, double top, double width, double height) : super.fromLTWH(left, top, width, height);
  RectEX.fromCircle({required super.center, required super.radius}) : super.fromCircle();
  RectEX.fromPoints(Offset a, Offset b) : super.fromPoints(a, b);
  RectEX.fromLTRB(double left, double top, double right, double bottom) : super.fromLTRB(left, top, right, bottom);

  @override
  Rect get bounds => this;
}