
import 'dart:ui';

import 'space.dart';
import '../objects/space_object.dart';

class ViewState {
  //创建单例
  factory ViewState() => _getInstance();

  static ViewState get instance => _getInstance();
  static ViewState? _instance;

  ViewState._internal() {
    // 初始化
  }

  static ViewState _getInstance() {
    _instance ??= ViewState._internal();
    return _instance!;
  }

  static double currentScale = 1.0;
  static Offset currentOffset = Offset.zero;

  static Space space = Space();

  static Rect? bound;
  static Size viewPortPixelSize = Size.zero;
  static Size validViewPortSizeOfSpace = Size.zero;
  static List<SpaceObject> allObjectInViewPort = [];
}