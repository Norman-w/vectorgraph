import 'dart:math';

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

  //随机生成一些圆角矩形添加到图层中
  for (int i = 0; i < 1000; i++) {
    //大小在50-400之间
    Decimal width = Decimal.fromInt(Random().nextInt(350) + 50);
    Decimal height = Decimal.fromInt(Random().nextInt(350) + 50);
    //位置从 -20000到20000之间
    Decimal x = Decimal.fromInt(Random().nextInt(40000) - 20000);
    Decimal y = Decimal.fromInt(Random().nextInt(20000) - 10000);
    //圆角半径从0到50之间
    Decimal topLeftRadius = Decimal.fromInt(Random().nextInt(50));
    Decimal topRightRadius = Decimal.fromInt(Random().nextInt(50));
    Decimal bottomLeftRadius = Decimal.fromInt(Random().nextInt(50));
    Decimal bottomRightRadius = Decimal.fromInt(Random().nextInt(50));
    try {
      boundedRectObject = BoundedRectObject.fromLTWHEachRadius(
          x, y, width, height, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius);
    } catch (e) {
      print(e);
      continue;
    }
    layer.addBoundedRect(boundedRectObject);
  }
}
