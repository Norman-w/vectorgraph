import 'dart:math';

import '../model/geometry/points/point_ex.dart';
import '../objects/equilateral_polygon_object.dart';
import '../space/space_layer.dart';
import '../utils/num_utils.dart';

void addEquilateralPolygonList2SpaceLayer(SpaceLayer layer) {
  EquilateralPolygonObject equilateralPolygonObject = EquilateralPolygonObject(
      PointEX(Decimal.fromInt(-300), Decimal.fromInt(0)),
      size: Decimal.fromInt(200),
      count: 3);
  layer.addEquilateralPolygon(equilateralPolygonObject);

  EquilateralPolygonObject circlePolygonObject = EquilateralPolygonObject(
      PointEX(Decimal.fromInt(-300), Decimal.fromInt(0)),
      size: Decimal.fromInt(200),
      count: 15);

  layer.addEquilateralPolygon(circlePolygonObject);

  EquilateralPolygonObject rectPolygonObject = EquilateralPolygonObject(
      PointEX(Decimal.fromInt(300), Decimal.fromInt(0)),
      size: Decimal.fromInt(200),
      count: 4);

  layer.addEquilateralPolygon(rectPolygonObject);

  EquilateralPolygonObject rect8PolygonObject = EquilateralPolygonObject(
      PointEX(Decimal.fromInt(300), Decimal.fromInt(0)),
      size: Decimal.fromInt(200),
      count: 8);

  layer.addEquilateralPolygon(rect8PolygonObject);

  EquilateralPolygonObject rect5PolygonObject = EquilateralPolygonObject(
      PointEX(Decimal.fromInt(0), Decimal.fromInt(300)),
      size: Decimal.fromInt(200),
      count: 5);

  layer.addEquilateralPolygon(rect5PolygonObject);

  //使用随机大小30-300, 随机边数3-10的多边形 在 x=-2000~+2000, y=-1000~+1000的范围内随机生成多边形并添加到layer5
  for (int i = 0; i < 1000; i++) {
    var size = Decimal.fromInt(Random().nextInt(270) + 30);
    var count = Random().nextInt(8) + 3;
    var x = Decimal.fromInt(Random().nextInt(40000) - 20000);
    var y = Decimal.fromInt(Random().nextInt(20000) - 10000);
    var point = PointEX(x, y);
    EquilateralPolygonObject polygonObject =
        EquilateralPolygonObject(point, size: size, count: count);
    layer.addEquilateralPolygon(polygonObject);
  }
  //endregion
}
