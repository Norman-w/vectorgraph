import 'package:vectorgraph/space/space_layer.dart';
import '../model/geometry/points/point_ex.dart';
import '../objects/line_object.dart';
import '../utils/num_utils.dart';

void addTestLineList2SpaceLayer(SpaceLayer layer) {
  layer.addLine(LineObject(
    PointEX(Decimal.fromInt(-200), Decimal.fromInt(-150)),
    PointEX(Decimal.fromInt(-50), Decimal.fromInt(-50)),
  ));
  layer.addLine(LineObject(
    PointEX(Decimal.fromInt(200), Decimal.fromInt(-150)),
    PointEX(Decimal.fromInt(50), Decimal.fromInt(-50)),
  ));
}
