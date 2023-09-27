import 'dart:math';

import '../model/geometry/points/point_ex.dart';
import '../objects/regular_polygonal_star.dart';
import '../space/space_layer.dart';
import '../utils/num_utils.dart';

void addRegularPolygonalStarList2SpaceLayer(SpaceLayer layer) {
  for (int i = 0; i < 1000; i++) {
    var size = Decimal.fromInt(Random().nextInt(270) + 30);
    var count = Random().nextInt(8) + 3;
    var x = Decimal.fromInt(Random().nextInt(40000) - 20000);
    var y = Decimal.fromInt(Random().nextInt(20000) - 10000);
    var point = PointEX(x, y);
    RegularPolygonalStarObject regularPolygonalStarObject =
        RegularPolygonalStarObject(point, count, size, null);
    layer.addRegularPolygonalStart(regularPolygonalStarObject);
  }
}
