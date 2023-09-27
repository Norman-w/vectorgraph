import '../model/geometry/rect/RectEX.dart';
import '../objects/sector_object.dart';
import '../space/space_layer.dart';
import '../utils/num_utils.dart';

void addTestSectorList2SpaceLayer(SpaceLayer layer) {
  SectorObject sectorObject = SectorObject.fromCanvas(
    RectEX.fromLTWH(Decimal.fromInt(-400), Decimal.fromInt(-300),
        Decimal.fromInt(200), Decimal.fromInt(100)),
    Decimal.zero,
    Decimal.fromInt(180) * decimalPerDegree,
    Decimal.fromInt(135) * decimalPerDegree,
  );
  layer.addSector(sectorObject);
}
