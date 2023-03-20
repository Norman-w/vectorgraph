import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/geometry/rect/RectEX.dart';
import '../model/geometry/points/point_ex.dart';
import '../utils/num_utils.dart';
import '../utils/utils.dart';
import '../viewer/points_painter.dart';
import '../viewer/space.dart';
import 'space_object.dart';

class PointObject extends PointEX with SpaceObject{
  late Decimal radius;
  PointObject(super.x, super.y, {Decimal? radius}){
    this.radius = radius ?? Decimal.fromInt(1);
  }
  @override
  RectEX get bounds => RectEX.fromCircle(center: PointEX(x, y), radius: radius);
  @override
  PointObject copyWith({Decimal? x, Decimal? y, Decimal? radius}){
    return PointObject(x ?? this.x, y ?? this.y, radius: radius ?? this.radius);
  }
}

class PointObjectNotifier extends StateNotifier<PointObject>{
  bool _isInteractive = false;
  PointObjectNotifier(super.state, this._isInteractive);
  get isInteractive => _isInteractive;
  void updateIsInteractive(bool newIsInteractive){
    _isInteractive = newIsInteractive;
    state = state.copyWith()
      ..isInteractive = newIsInteractive;
  }
}

final pointObjectProvider =
StateNotifierProvider.family<PointObjectNotifier, PointObject, PointObject>(
        (ref, point) => PointObjectNotifier(point, false));



class PointObjectWidget extends ConsumerWidget{
  final PointObject pointObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  const PointObjectWidget(
  {
    required this.pointObject,
    required this.viewPortScale,
    required this.viewPortOffset,
    required this.viewPortPixelSize, Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color color = ref.watch(pointObjectProvider(pointObject)).isInteractive?
        Colors.white: getRandomColor();
    Offset point = Space.spacePointPos2ViewPortPointPos(
        pointObject, viewPortOffset,viewPortScale, viewPortPixelSize);
    var newRadius = pointObject.radius * viewPortScale;
    return CustomPaint(
      painter: PointPainter(point, color, newRadius.toDouble()),
    );
  }
}