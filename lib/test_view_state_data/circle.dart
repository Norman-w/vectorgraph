import 'dart:math';

import '../model/geometry/points/point_ex.dart';
import '../objects/circle_object.dart';
import '../space/space_layer.dart';
import '../utils/num_utils.dart';

void addCircleList2SpaceLayer(SpaceLayer layer) {
  for (int i = 0; i < 1000; i++) {
    var radius = Decimal.fromInt(Random().nextInt(70) + 30);
    var x = Decimal.fromInt(Random().nextInt(40000) - 20000);
    var y = Decimal.fromInt(Random().nextInt(20000) - 10000);
    var point = PointEX(x, y);
    CircleObject circleObject = CircleObject(point, radius);
    layer.addCircle(circleObject);
  }
}
