import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/geometry/points/point_ex.dart';
import '../model/geometry/rect/RectEX.dart';
import '../utils/num_utils.dart';

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

class SpaceObjectController extends StateNotifier<SpaceObject>{
  bool _isInteractive = false;
  SpaceObjectController(super.state, this._isInteractive);
  get isInteractive => _isInteractive;
  void updateIsInteractive(bool newIsInteractive){
    _isInteractive = newIsInteractive;
    state = state.copyWith()
      ..isInteractive = newIsInteractive;
  }
}