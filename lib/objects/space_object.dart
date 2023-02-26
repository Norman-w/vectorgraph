import 'dart:ui';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/geometry/rect/RectEX.dart';

mixin SpaceObject{
  Decimal x = Decimal.zero;
  Decimal y = Decimal.zero;
  RectEX get bounds;
  bool isInteractive = false;
  SpaceObject copyWith();
}

class SpaceObjectController extends StateNotifier<SpaceObject>{
  bool _isInteractive = false;
  SpaceObjectController(super.state, this._isInteractive);
  get isInteractive => _isInteractive;
  void updateIsInteractive(bool newIsInteractive){
    _isInteractive = newIsInteractive;
    state = state.copyWith()
      ..isInteractive = newIsInteractive;
  }
}