import 'package:vectorgraph/space/space_layer.dart';
import '../model/geometry/points/point_ex.dart';
import '../objects/point_object.dart';
import '../objects/rect_object.dart';
import '../utils/num_utils.dart';

void addTestRectAndPoint2SpaceLayer(SpaceLayer layer) {
  RectObject rectObject = RectObject.fromCenter(
      center: PointEX(Decimal.zero, Decimal.zero),
      width: Decimal.fromInt(100),
      height: Decimal.fromInt(100));
  rectObject.position = PointEX(Decimal.fromInt(100), Decimal.fromInt(100));
  layer.addRect(rectObject);

  layer.addRect(RectObject.fromCenter(
      center: PointEX(Decimal.zero, Decimal.zero),
      width: Decimal.fromInt(400),
      height: Decimal.fromInt(300)));

  PointObject pointObject =
      PointObject(Decimal.parse('50'), Decimal.parse("50"))
        ..radius = Decimal.fromInt(20);
  layer.addPoint(pointObject);

  layer.addPoint(
      PointObject(Decimal.zero, Decimal.ten)..radius = Decimal.fromInt(2));

  layer.addPoint(PointObject(Decimal.fromInt(50), Decimal.zero)
    ..radius = Decimal.fromInt(4));
}
