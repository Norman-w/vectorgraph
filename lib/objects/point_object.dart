import 'dart:ui';

import '../model/geometry/points/point_ex.dart';
import 'space_object.dart';

class PointObject extends PointEX with SpaceObject{
  PointObject(super.x, super.y);
  @override
  Rect get bounds => Rect.fromCircle(center: Offset(x, y), radius: 0);
}