import 'dart:ui';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewer/points_painter.dart';

import '../model/geometry/points/point_ex.dart';
import 'space_object.dart';

class PointObject extends PointEX with SpaceObject{
  late Decimal radius;
  PointObject(super.x, super.y, {Decimal? radius}){
    this.radius = radius ?? Decimal.fromInt(1);
  }
  @override
  Rect get bounds => Rect.fromCircle(center: Offset(x, y), radius: radius);
  @override
  PointObject copyWith({Decimal? x, Decimal? y, Decimal? radius}){
    return PointObject(x ?? this.x, y ?? this.y, radius: radius ?? this.radius);
  }
}

class PointObjectNotifier extends StateNotifier<PointObject>{
  bool _isInteractive = false;
  PointObjectNotifier(super.state, this._isInteractive);
  get isInteractive => _isInteractive;
  void updateIsInteractive(bool newIsInteractive){
    _isInteractive = newIsInteractive;
    state = state.copyWith()
      ..isInteractive = newIsInteractive;
  }
}

final pointObjectProvider =
StateNotifierProvider.family<PointObjectNotifier, PointObject, PointObject>(
        (ref, point) => PointObjectNotifier(point, false));