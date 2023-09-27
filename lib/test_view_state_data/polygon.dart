import '../model/geometry/points/point_ex.dart';
import '../objects/polygon_object.dart';
import '../space/space_layer.dart';
import '../utils/num_utils.dart';

void addPolygonList2SpaceLayer(SpaceLayer layer) {
  PolygonObject polygonObject =
      PolygonObject(PointEX(Decimal.fromInt(100), Decimal.fromInt(0)), [
    PointEX(Decimal.fromInt(-80), Decimal.fromInt(-80)),
    PointEX(Decimal.fromInt(0), Decimal.fromInt(-100)),
    PointEX(Decimal.fromInt(80), Decimal.fromInt(-80)),
    PointEX(Decimal.fromInt(100), Decimal.fromInt(80)),
    PointEX(Decimal.fromInt(-100), Decimal.fromInt(80)),
  ]);
  layer.addPolygon(polygonObject);
}
