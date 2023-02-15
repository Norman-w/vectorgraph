import 'dart:ui';

import 'package:flutter/material.dart';

mixin SpaceObject{
  double x = 0;
  double y = 0;
  Rect get bounds;
}