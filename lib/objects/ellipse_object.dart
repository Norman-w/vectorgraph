import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/model/geometry/rect/RectEX.dart';
import 'package:vectorgraph/model/geometry/vectors/vector2d.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../model/geometry/planes/ellipse.dart';
import 'space_object.dart';

class EllipseObject extends Ellipse with SpaceObject,APlaneObject{
  final PointEX _position;
  EllipseObject(this._position, Decimal radiusX, Decimal radiusY) {
    super.radiusX = radiusX;
    super.radiusY = radiusY;
  }
  @override
  EllipseObject copyWith(){
    return EllipseObject(_position, radiusX, radiusY);
  }

  @override
  bool isWorldPointOnEdgeLines(PointEX pointEX, Decimal deviation){
    // pointEX = PointEX(Decimal.fromInt(100),Decimal.fromInt(100));
    //先把世界坐标转换成本地坐标
    var local = pointEX - _position;
    // print('本地坐标: $local');
    //获取本地坐标的向量
    var vector = local.toVector2D();
    // print('本地坐标的向量: $vector');
    //获得本地坐标的角度
    var angle = radiansToDegrees(vector.getAngle());
    // print('本地坐标的角度: $angle');
    //获取椭圆边线上该角度的点坐标
    var pointOnEdgeByAngle = getOnEdgePointByAngle(angle);
    // print('椭圆上该角度点坐标: $pointOnEdgeByAngle');
    //获取转换到的本地坐标点到 椭圆上该角度点的距离
    var distance = pointOnEdgeByAngle.toVector2D().distance(vector);
    // print('转换到的本地坐标点到 椭圆上该角度点的距离: $distance');
    return distance < deviation;
  }
  @override
  PointEX get position => _position;

  @override
  RectEX get selfBounds => bounds;

  @override
  RectEX get worldBounds => bounds.shift(_position.x, _position.y);

  @override
  bool isWorldPointIn(PointEX pointEX) {
    // return false;
    return !worldBounds.contains(pointEX)?false:isPointIn(pointEX, Decimal.one);
  }

  bool isPointIn(PointEX pointEX, Decimal deviation){
    // pointEX = PointEX(Decimal.fromInt(5),Decimal.fromInt(5));
    //先把世界坐标转换成本地坐标
    var local = pointEX - _position;
    // print('本地坐标: $local');
    //获取本地坐标的向量
    var vector = local.toVector2D();
    // print('本地坐标的向量: $vector');
    //获得本地坐标的角度
    var angle = radiansToDegrees(vector.getAngle());
    // print('本地坐标的角度: $angle');
    //获取椭圆变现上该角度的点坐标
    var pointOnEdgeByAngle = getOnEdgePointByAngle(angle);
    // print('椭圆上该角度点坐标: $pointOnEdgeByAngle');
    //椭圆上该角度点坐标到圆心的距离
    var pointOnEdgeByAngleDistance = pointOnEdgeByAngle.toVector2D().distance(Vector2D.zero);
    // print('椭圆上该角度点坐标到圆心的距离: $pointOnEdgeByAngleDistance');

    return vector.distance(Vector2D.zero) < pointOnEdgeByAngleDistance - deviation;
  }
}
