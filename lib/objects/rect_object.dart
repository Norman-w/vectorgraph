import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vectorgraph/viewer/rect_painter.dart';

import 'space_object.dart';

class RectObject extends Rect with SpaceObject{
  RectObject.fromCenter({required super.center, required super.width, required super.height}) : super.fromCenter();
  RectObject.fromLTWH(double left, double top, double width, double height) : super.fromLTWH(left, top, width, height);
  RectObject.fromCircle({required super.center, required super.radius}) : super.fromCircle();
  RectObject.fromPoints(Offset a, Offset b) : super.fromPoints(a, b);
  RectObject.fromLTRB(double left, double top, double right, double bottom) : super.fromLTRB(left, top, right, bottom);

  @override
  Rect get bounds => this;

  @override
  Widget getWidget(
      Size viewPortSize,
      Offset viewPortOffset,
      double viewPortScale,
      Color color) {
    var newWidth = width * viewPortScale;
    var newHeight = height * viewPortScale;
    var oldWidth = width;
    var oldHeight = height;
    var xAdded = (newWidth - oldWidth) / 2;
    var yAdded = (newHeight - oldHeight) / 2;
    var newLeft = left + viewPortOffset.dx + viewPortSize.width/2 - xAdded;
    var newTop = top + viewPortOffset.dy + viewPortSize.height/2  -yAdded;
    var realViewRect = Rect.fromLTWH(
        newLeft,
        newTop,
        newWidth,
        newHeight
    );
    return CustomPaint(
      painter: RectPainter(realViewRect, color),
    );
  }
}