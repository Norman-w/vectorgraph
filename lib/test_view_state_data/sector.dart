import '../model/geometry/rect/RectEX.dart';
import '../objects/sector_object.dart';
import '../space/space_layer.dart';
import '../utils/num_utils.dart';
import 'dart:math';

void addTestSectorList2SpaceLayer(SpaceLayer layer) {
  SectorObject sectorObject = SectorObject.fromCanvas(
    RectEX.fromLTWH(Decimal.fromInt(-400), Decimal.fromInt(-300),
        Decimal.fromInt(200), Decimal.fromInt(100)),
    Decimal.zero,
    Decimal.fromInt(180) * decimalPerDegree,
    Decimal.fromInt(135) * decimalPerDegree,
  );
  layer.addSector(sectorObject);

  //region 添加随机的扇形
  for (int i = 0; i < 1000; i++) {
    //大小在50-400之间
    var width = Random().nextInt(350) + 50;
    var height = Random().nextInt(350) + 50;
    //位置从 -20000到20000之间
    var x = Random().nextInt(40000) - 20000;
    var y = Random().nextInt(20000) - 10000;
    //角度从0到360之间
    var startAngle = Random().nextInt(360);
    var sweepAngle = Random().nextInt(360);
    try {
      sectorObject = SectorObject.fromCanvas(
        RectEX.fromLTWH(
            Decimal.fromInt(x), Decimal.fromInt(y), Decimal.fromInt(width), Decimal.fromInt(height)),
        Decimal.zero,
        Decimal.fromInt(startAngle) * decimalPerDegree,
        Decimal.fromInt(sweepAngle) * decimalPerDegree,
      );
    } catch (e) {
      print(e);
      continue;
    }
    layer.addSector(sectorObject);
  }

  //endregion
}
