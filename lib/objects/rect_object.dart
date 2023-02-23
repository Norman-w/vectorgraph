import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/viewer/rect_painter.dart';

import '../model/geometry/lines/line_segment.dart';
import 'space_object.dart';

class RectObject extends Rect with SpaceObject{
  RectObject.fromCenter({required super.center, required super.width, required super.height}) : super.fromCenter();
  RectObject.fromLTWH(double left, double top, double width, double height) : super.fromLTWH(left, top, width, height);
  RectObject.fromCircle({required super.center, required super.radius}) : super.fromCircle();
  RectObject.fromPoints(Offset a, Offset b) : super.fromPoints(a, b);
  RectObject.fromLTRB(double left, double top, double right, double bottom) : super.fromLTRB(left, top, right, bottom);

  @override
  Rect get bounds => this;
  List<LineSegment> _lines = [];
  List<LineSegment> get lines {
    if(_lines.isEmpty && !isEmpty){
      //init lines
      var p1 = PointEX(left, top);
      var p2 = PointEX(right, top);
      var p3 = PointEX(right, bottom);
      var p4 = PointEX(left, bottom);
      _lines = [
        LineSegment(p1,p2),
        LineSegment(p2,p3),
        LineSegment(p3,p4),
        LineSegment(p4,p1),
      ];
    }
    return _lines;
  }
  ///检测点是否在矩形的边缘上.
  bool isPointOnSides(PointEX point){
    var list = lines;
    for(var l in list){
      if(l.isPointOnLine(point)) {
        return true;
      }
    }
    return false;
  }
  @override
  RectObject copyWith({Offset? center, double? width, double? height, double? radius, double? left, double? top, double? right, double? bottom}){
    return RectObject.fromLTWH(left ?? this.left, top ?? this.top, width ?? this.width, height ?? this.height);
  }
}
class RectObjectNotifier extends StateNotifier<RectObject>{
  bool _isInteractive = false;
  RectObjectNotifier(super.state, this._isInteractive);
  get isInteractive => _isInteractive;
  void updateIsInteractive(bool newIsInteractive){
    _isInteractive = newIsInteractive;
    state = state.copyWith()
      ..isInteractive = newIsInteractive;
  }
}

final rectObjectsProvider =
StateNotifierProvider.family<RectObjectNotifier, RectObject, RectObject>(
        (ref, rect) => RectObjectNotifier(rect, false));