import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/viewer/painter_of_object/bounded_rect_painter.dart';
import '../../objects/bounded_rect_object.dart';
import '../../objects/notifier_and_provider_of_object.dart';
import '../../space/space.dart';
import '../../utils/num_utils.dart';

class BoundedRectObjectWidget extends ConsumerWidget{
  final BoundedRectObject boundedRectObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;// = Colors.blue;
  const BoundedRectObjectWidget({super.key,
    required this.boundedRectObject,
    required this.viewPortScale,
    required this.viewPortOffset,
    required this.viewPortPixelSize,
    this.normalColor = Colors.black, this.hoverColor = Colors.white, this.focusColor = Colors.lightGreen,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var aPlaneObject = ref.watch(planeObjectsProvider(boundedRectObject));
    var color = aPlaneObject.isFocus? focusColor: aPlaneObject.isInteractive? hoverColor: normalColor;
    var originBoundRectLeftTop = Space.spacePointPos2ViewPortPointPos(
        boundedRectObject.leftTop, viewPortOffset,viewPortScale, viewPortPixelSize);
    var originBoundRectRightBottom = Space.spacePointPos2ViewPortPointPos(
        boundedRectObject.rightBottom, viewPortOffset,viewPortScale, viewPortPixelSize);
    var topLeftArcRadiusX = 0.0;
    var topLeftArcRadiusY = 0.0;
    var topRightArcRadiusX = 0.0;
    var topRightArcRadiusY = 0.0;
    var bottomRightArcRadiusX = 0.0;
    var bottomRightArcRadiusY = 0.0;
    var bottomLeftArcRadiusX = 0.0;
    var bottomLeftArcRadiusY = 0.0;
    if(boundedRectObject.leftTopSector != null){
      topLeftArcRadiusX = (boundedRectObject.leftTopSector!.arc.rx * viewPortScale).toDouble();
      topLeftArcRadiusY = (boundedRectObject.leftTopSector!.arc.ry * viewPortScale).toDouble();
    }
    if(boundedRectObject.rightTopSector != null){
      topRightArcRadiusX = (boundedRectObject.rightTopSector!.arc.rx * viewPortScale).toDouble();
      topRightArcRadiusY = (boundedRectObject.rightTopSector!.arc.ry * viewPortScale).toDouble();
    }
    if(boundedRectObject.rightBottomSector != null){
      bottomRightArcRadiusX = (boundedRectObject.rightBottomSector!.arc.rx * viewPortScale).toDouble();
      bottomRightArcRadiusY = (boundedRectObject.rightBottomSector!.arc.ry * viewPortScale).toDouble();
    }
    if(boundedRectObject.leftBottomSector != null){
      bottomLeftArcRadiusX = (boundedRectObject.leftBottomSector!.arc.rx * viewPortScale).toDouble();
      bottomLeftArcRadiusY = (boundedRectObject.leftBottomSector!.arc.ry * viewPortScale).toDouble();
    }
    var painter = BoundedRectPainter(
        Rect.fromPoints(originBoundRectLeftTop, originBoundRectRightBottom),
        topLeftArcRadiusX, topLeftArcRadiusY,
        topRightArcRadiusX, topRightArcRadiusY,
        bottomRightArcRadiusX, bottomRightArcRadiusY,
        bottomLeftArcRadiusX, bottomLeftArcRadiusY,
        color);
    return CustomPaint(
      painter: painter
    );
  }
}