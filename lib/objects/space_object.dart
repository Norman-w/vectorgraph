import '../model/geometry/points/point_ex.dart';
import '../model/geometry/rect/RectEX.dart';
import '../utils/num_utils.dart';

/// 如果
/// class PointObject extends PointEX with SpaceObject,APointObject{
/// 则mixin APointObject implements SpaceObject{
/// 中不需要实现
/// @override
/// bool isInteractive = false;
///
/// 否则想要class PointObject extends PointEX with APointObject{
/// 的话,就需要在APointObject中实现
/// @override
/// bool isInteractive = false;

mixin SpaceObject{
  ///获取对象的世界坐标
  PointEX get position;
  ///获取对象的自身坐标中的矩形
  RectEX get selfBounds;
  ///获取对象的世界坐标中的矩形
  RectEX get worldBounds;
  ///获取对象是否在交互中
  bool isInteractive = false;
  ///拷贝对象方法
  SpaceObject copyWith();
}

mixin APointObject implements SpaceObject{
  ///给定的点是否在我的范围内(由于点有大小,所以实际上意思是,给定的点是否在我这个点的圆内)
  bool isPointOn(PointEX pointEX, Decimal deviation);
  @override
  APointObject copyWith();
}
mixin ALineObject implements SpaceObject{
  ///给定的点是否和我相交,是否在我的线或者线集合(贝塞尔曲线或者其他曲线实际上是线集合)上
  bool isPointOn(PointEX pointEX, Decimal deviation);
  @override
  ALineObject copyWith();
}
mixin APlaneObject implements SpaceObject{
  ///给定的点是否在我的边线上
  bool isPointOnEdgeLines(PointEX pointEX, Decimal deviation);
  ///给定的点是否在我内部
  bool isPointIn(PointEX pointEX);
  @override
  APlaneObject copyWith();
  ///当前是否被聚焦
  bool isFocus = false;
}
//
// class SpaceObjectController extends StateNotifier<SpaceObject>{
//   bool _isInteractive = false;
//   SpaceObjectController(super.state, this._isInteractive);
//   get isInteractive => _isInteractive;
//   void updateIsInteractive(bool newIsInteractive){
//     _isInteractive = newIsInteractive;
//     state = state.copyWith()
//       ..isInteractive = newIsInteractive;
//   }
// }