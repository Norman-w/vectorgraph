import 'package:vectorgraph/space/space_layer.dart';
import '../objects/bounded_rect_object.dart';
import '../utils/num_utils.dart';

void addBoundedRectAndPoint2SpaceLayer(SpaceLayer layer) {
  BoundedRectObject boundedRectObject =
  BoundedRectObject.fromLTWHEachRadius(
    Decimal.fromInt(100),
    Decimal.fromInt(100),
    Decimal.fromInt(100),
    Decimal.fromInt(50),
    Decimal.fromInt(10),
    Decimal.fromInt(10),
    Decimal.fromInt(10),
    Decimal.fromInt(10)
  );
  layer.addBoundedRect(boundedRectObject);
}
