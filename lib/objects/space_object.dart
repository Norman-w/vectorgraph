import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin SpaceObject{
  double x = 0;
  double y = 0;
  Rect get bounds;
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