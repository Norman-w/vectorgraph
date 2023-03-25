import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/objects/space_object.dart';


//region 点
class PointObjectNotifier extends StateNotifier<APointObject>{
  bool _isInteractive = false;
  PointObjectNotifier(super.state, this._isInteractive);
  get isInteractive => _isInteractive;
  void updateIsInteractive(bool newIsInteractive){
    _isInteractive = newIsInteractive;
    state = state.copyWith()
      ..isInteractive = newIsInteractive;
  }
}

final pointObjectsProvider =
StateNotifierProvider.family<PointObjectNotifier, APointObject, APointObject>(
        (ref, point) => PointObjectNotifier(point, false));
//endregion

//region 线
class LineObjectNotifier extends StateNotifier<ALineObject>{
  bool _isInteractive = false;
  LineObjectNotifier(super.state, this._isInteractive);
  get isInteractive => _isInteractive;
  void updateIsInteractive(bool newIsInteractive){
    _isInteractive = newIsInteractive;
    state = state.copyWith()
      ..isInteractive = newIsInteractive;
  }
}

final lineObjectsProvider =
StateNotifierProvider.family<LineObjectNotifier, ALineObject, ALineObject>(
        (ref, rect) => LineObjectNotifier(rect, false));
//endregion

//region 面
class PlaneObjectNotifier extends StateNotifier<APlaneObject>{
  // bool _isInteractive = false;
  PlaneObjectNotifier(super.state);
  // get isInteractive => _isInteractive;
  // void updateIsInteractive(bool newIsInteractive){
  //   // _isInteractive = newIsInteractive;
  //   state = state.copyWith()
  //     ..isInteractive = newIsInteractive;
  // }
  // void updateIsFocus(bool newIsFocus){
  //   state = state.copyWith()
  //     ..isFocus = newIsFocus;
  // }
  ///更新交互状态信息,都写到一个函数里面了.
  void updateInteractiveInfo(bool isInteractive, bool isFocus){
    state = state.copyWith()
        ..isFocus = isFocus
        ..isInteractive = isInteractive;
  }
}

final planeObjectsProvider =
StateNotifierProvider.family<PlaneObjectNotifier, APlaneObject, APlaneObject>(
        (ref, rect) => PlaneObjectNotifier(rect));
//endregion