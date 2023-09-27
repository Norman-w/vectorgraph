import '../model/geometry/points/point_ex.dart';
import '../objects/bezier_object.dart';
import '../space/space_layer.dart';
import '../utils/num_utils.dart';

void addBezierList2SpaceLayer(SpaceLayer layer) {
  //直接给出起始点和终止点,自动调整控制点,只适合像简单思维导图的结构分支线使用.
  //思维导图节点之间的连线就不适用了.因为bounds现在是矩形,且仅仅是从左上到右下,左下到右上等世界空间 水平垂直 放置的矩形的对角点之间的连线.
  try {
    layer.addBezier(BezierObject(
      PointEX(Decimal.fromInt(0), Decimal.fromInt(0)),
      PointEX(Decimal.fromInt(200), Decimal.fromInt(150)),
    ));

    layer.addBezier(BezierObject(
      PointEX(Decimal.fromInt(0), Decimal.fromInt(0)),
      PointEX(Decimal.fromInt(-200), Decimal.fromInt(150)),
    ));

    layer.addBezier(BezierObject(
      PointEX(Decimal.fromInt(100), Decimal.fromInt(0)),
      PointEX(Decimal.fromInt(300), Decimal.fromInt(-150)),
    ));
  } catch (e) {
    print('添加贝塞尔曲线发生错误');
    print(e);
  }
}
