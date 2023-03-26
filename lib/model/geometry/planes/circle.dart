import 'package:vectorgraph/utils/num_utils.dart';
import '../points/point_ex.dart';
import '../rect/RectEX.dart';
/// 圆形
class Circle{
  Decimal _radius;
  ///半径 半径
  Decimal get radius => _radius;
  set radius(Decimal v){
    bounds = RectEX.fromCircle(center: PointEX.zero, radius: v);
    _radius = v;
  }
  ///外围
  RectEX bounds;
  Circle():bounds = RectEX.zero, _radius = Decimal.one;
}