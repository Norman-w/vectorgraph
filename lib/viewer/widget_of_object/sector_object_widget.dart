import 'package:flutter/material.dart' hide TextPainter;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/viewer/painter_of_object/sector_painter.dart';
import '../../objects/sector_object.dart';
import '../../objects/notifier_and_provider_of_object.dart';
import '../../space/space.dart';
import '../../utils/num_utils.dart';
import '../painter_of_object/line_painter.dart';
import '../painter_of_object/points_painter.dart';
import '../painter_of_object/rect_painter.dart';

var times =0;

class SectorObjectWidget extends ConsumerWidget{
  ///弧线对象
  final SectorObject sectorObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;
  ///是否显示弧线所在椭圆的圆心
  final bool showSectorOwnEllipseCenter;
  ///是否显示弧线所在椭圆的外切矩形
  final bool showSectorOwnEllipseBoundRect;
  ///是否显示弧线所在椭圆的外切矩形的屏幕上的矩形块儿
  final bool showBoundsBound;
  ///是否显示起点到终点的直线
  final bool showSectorStartToEndLine;
  ///是否显示有旋转和无旋转的圆弧所在椭圆的360个点
  final bool showSector360Points;

  const SectorObjectWidget(
      { Key? key,
        required this.sectorObject,
        required this.viewPortScale,
        required this.viewPortOffset,
        required this.viewPortPixelSize,
        this.normalColor = Colors.black,
        this.hoverColor = Colors.white,
        this.focusColor = Colors.red,
        this.showSectorOwnEllipseCenter = true,
        this.showSectorOwnEllipseBoundRect = true,
        this.showSectorStartToEndLine = true,
        this.showSector360Points = true,
        this.showBoundsBound = true,
      }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(planeObjectsProvider(sectorObject));
    var color = state.isInteractive ? hoverColor : normalColor;
    Offset center = Space.spacePointPos2ViewPortPointPos(
        sectorObject.position, viewPortOffset, viewPortScale, viewPortPixelSize);
    Offset startPoint = Space.spacePointPos2ViewPortPointPos(
        sectorObject.position - sectorObject.startPoint, viewPortOffset, viewPortScale, viewPortPixelSize);
    Offset endPoint = Space.spacePointPos2ViewPortPointPos(
        sectorObject.position - sectorObject.endPoint, viewPortOffset, viewPortScale, viewPortPixelSize);
    var painter = SectorPainter(
      sectorObject.rotationRadians.toDouble(),
      Rect.fromCenter(
          center: center,
          width: (sectorObject.rx * viewPortScale).toDouble() * 2,
          height: (sectorObject.ry * viewPortScale).doubleValue * 2),
      sectorObject.startAngle.toDouble(),
      sectorObject.sweepAngle.toDouble(),
      startPoint,
      endPoint,
      true,
      color,
      showSectorOwnEllipseCenter,
      showSectorOwnEllipseBoundRect,
    );

    //视图空间中的bounds
    Rect viewPortBounds = Rect.fromCenter(
        center: center,
        width: (sectorObject.bounds.width * viewPortScale).toDouble(),
        height: (sectorObject.bounds.height * viewPortScale).doubleValue);
    return
      Stack(
        children: [
          CustomPaint(
            painter: sectorObject.valid ? painter
            //如果无法找到有效的弧线,使用红色的直线展示以进行提示
                : LinePainter(
                Space.spacePointPos2ViewPortPointPos(
                    sectorObject.startPoint, viewPortOffset, viewPortScale,
                    viewPortPixelSize),
                Space.spacePointPos2ViewPortPointPos(
                    sectorObject.endPoint, viewPortOffset, viewPortScale,
                    viewPortPixelSize),
                Colors.red),
          ),
          //显示圆弧所在的椭圆的圆心
          if(showSectorOwnEllipseCenter)
            CustomPaint(
              painter: PointsPainter(
                  [Space.spacePointPos2ViewPortPointPos(
                      sectorObject.position, viewPortOffset, viewPortScale,
                      viewPortPixelSize)],
                  Colors.lightGreen, 1),
            ),
          //圆弧内切的矩形的所在世界视图的最外框
          if(showBoundsBound)
          CustomPaint(
            painter: RectPainter(
                viewPortBounds,
                Colors.blueGrey),
          ),
        ],
      );
  }
}