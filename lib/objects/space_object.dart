import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/geometry/rect/RectEX.dart';
import '../utils/num_utils.dart';

mixin SpaceObject{
  Decimal x = Decimal.zero;
  Decimal y = Decimal.zero;
  RectEX get bounds;
  bool isInteractive = false;
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