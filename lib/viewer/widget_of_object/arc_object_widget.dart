import 'package:flutter/material.dart' hide TextPainter;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vectorgraph/model/geometry/points/point_ex.dart';
import 'package:vectorgraph/viewer/painter_of_object/arc_painter.dart';
import '../../objects/arc_object.dart';
import '../../objects/notifier_and_provider_of_object.dart';
import '../../space/space.dart';
import '../../utils/num_utils.dart';
import '../painter_of_object/line_painter.dart';
import '../painter_of_object/points_painter.dart';
import '../painter_of_object/rect_painter.dart';

var times =0;

class ArcObjectWidget extends ConsumerWidget{
  ///弧线对象
  final ArcObject arcObject;
  final Decimal viewPortScale;
  final Offset viewPortOffset;
  final Size viewPortPixelSize;
  final Color normalColor;// = Colors.white60;
  final Color hoverColor;// = Colors.white;
  final Color focusColor;
  ///是否显示弧线所在椭圆的圆心
  final bool showArcOwnEllipseCenter;
  ///是否显示弧线所在椭圆的外切矩形
  final bool showArcOwnEllipseBoundRect;
  ///是否显示弧线所在椭圆的外切矩形的屏幕上的矩形块儿
  final bool showBoundsBound;
  ///是否显示起点到终点的直线
  final bool showArcStartToEndLine;
  ///是否显示有旋转和无旋转的圆弧所在椭圆的360个点
  final bool showArc360Points;

  const ArcObjectWidget(
      { Key? key,
        required this.arcObject,
        required this.viewPortScale,
        required this.viewPortOffset,
        required this.viewPortPixelSize,
        this.normalColor = Colors.black,
        this.hoverColor = Colors.white,
        this.focusColor = Colors.red,
        this.showArcOwnEllipseCenter = false,
        this.showArcOwnEllipseBoundRect = false,
        this.showArcStartToEndLine = false,
        this.showArc360Points = false,
        this.showBoundsBound = false,
      }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(lineObjectsProvider(arcObject));
    var color = state.isInteractive ? hoverColor : normalColor;
    Offset center = Space.spacePointPos2ViewPortPointPos(
        arcObject.position, viewPortOffset, viewPortScale, viewPortPixelSize);
    var painter = ArcPainter(
      arcObject.rotationRadians.toDouble(),
      Rect.fromCenter(
          center: center,
          width: (arcObject.rx * viewPortScale).toDouble() * 2,
          height: (arcObject.ry * viewPortScale).doubleValue * 2),
      arcObject.startAngle.toDouble(),
      arcObject.sweepAngle.toDouble(),
      true,
      color,
      showArcOwnEllipseCenter,
      showArcOwnEllipseBoundRect,
    );

    //视图空间中的bounds
    Rect viewPortBounds = Rect.fromCenter(
        center: center,
        width: (arcObject.bounds.width * viewPortScale).toDouble(),
        height: (arcObject.bounds.height * viewPortScale).doubleValue);

    //region 显示带及不带旋转的 圆弧所在的椭圆上的点集合
    //圆弧上的所有点
    var edgePoints = arcObject.pointsOnEdge;
    var edgePointsViewPort = edgePoints.map((e) => Space.spacePointPos2ViewPortPointPos(
        e, viewPortOffset, viewPortScale, viewPortPixelSize)).toList();
    // var edgePointsViewPort = [];

    //圆弧上的所有点 没有旋转过的
    var edgePointsNoRotation = arcObject.pointsOnEdgeNoRotation;
    var edgePointsNoRotationViewPort = edgePointsNoRotation.map((e) => Space.spacePointPos2ViewPortPointPos(
        e, viewPortOffset, viewPortScale, viewPortPixelSize)).toList();
    //endregion

    return
      Stack(
        children: [
          // //用绿色5个大小的源绘制起点,用红色5个大小的源绘制终点
          // CustomPaint(
          //   painter: PointsPainter(
          //       [Space.spacePointPos2ViewPortPointPos(
          //           arcObject.startPoint, viewPortOffset, viewPortScale,
          //           viewPortPixelSize)],
          //       Colors.green, 5),
          // ),
          // CustomPaint(
          //   painter: PointsPainter(
          //       [Space.spacePointPos2ViewPortPointPos(
          //           arcObject.endPoint, viewPortOffset, viewPortScale,
          //           viewPortPixelSize)],
          //       Colors.red, 5),
          // ),

          CustomPaint(
            painter: arcObject.valid ? painter
            //如果无法找到有效的弧线,使用红色的直线展示以进行提示
                : LinePainter(
                Space.spacePointPos2ViewPortPointPos(
                    arcObject.startPoint, viewPortOffset, viewPortScale,
                    viewPortPixelSize),
                Space.spacePointPos2ViewPortPointPos(
                    arcObject.endPoint, viewPortOffset, viewPortScale,
                    viewPortPixelSize),
                Colors.red),
          ),
          //显示起点到终点的直线
          if(showArcStartToEndLine)
            CustomPaint(
              painter: LinePainter(
                  Space.spacePointPos2ViewPortPointPos(
                      arcObject.startPoint, viewPortOffset, viewPortScale,
                      viewPortPixelSize),
                  Space.spacePointPos2ViewPortPointPos(
                      arcObject.endPoint, viewPortOffset, viewPortScale,
                      viewPortPixelSize),
                  Colors.lightBlue),
            ),
          //显示圆弧所在的椭圆的圆心
          if(showArcOwnEllipseCenter)
            CustomPaint(
              painter: PointsPainter(
                  [Space.spacePointPos2ViewPortPointPos(
                      arcObject.position, viewPortOffset, viewPortScale,
                      viewPortPixelSize)],
                  Colors.lightGreen, 1),
            ),
          // 显示带及不带旋转的 圆弧所在的椭圆上的点集合
          if(showArcOwnEllipseBoundRect)
          CustomPaint(
            painter: PointsPainter(
                [...edgePointsViewPort,...edgePointsNoRotationViewPort],
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