// import 'dart:async';
// import 'dart:math';
//
// import 'package:flutter/material.dart' hide TextPainter;
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:vectorgraph/utils/widget.dart';
// import 'package:vectorgraph/viewer/painter_of_object/arc_painter.dart';
// import 'package:vectorgraph/viewer/painter_of_object/line_painter.dart';
// import '../../model/geometry/planes/ellipse.dart';
// import '../../model/geometry/points/point_ex.dart';
// import '../../model/geometry/vectors/vector2d.dart';
// import '../../objects/arc_object.dart';
// import '../../space/space.dart';
// import '../../utils/num_utils.dart';
// import '../painter_of_object/points_painter.dart';
// import '../painter_of_object/text_painter.dart';
//
// var times =0;
//
// class ArcObjectWidget extends ConsumerStatefulWidget{
//   final ArcObject arcObject;
//   final Decimal viewPortScale;
//   final Offset viewPortOffset;
//   final Size viewPortPixelSize;
//   final Color normalColor;// = Colors.white60;
//   final Color hoverColor;// = Colors.white;
//   final Color focusColor;
//
//   const ArcObjectWidget({ Key? key, required this.arcObject, required this.viewPortScale, required this.viewPortOffset, required this.viewPortPixelSize, this.normalColor = Colors.white60, this.hoverColor = Colors.white, this.focusColor = Colors.red}) : super(key: key);
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() {
//     return _ArcObjectWidgetState();
//   }
// }
// class _ArcObjectWidgetState extends ConsumerState<ArcObjectWidget> with SingleTickerProviderStateMixin{
//   //起始位置
//   double startX = 400;
//   double startY = 300;
//
//   //结束位置
//   double endX = 500;
//   double endY = 400;
//
//   //椭圆的长短轴
//   double rx = 200;
//   double ry = 100;
//
//   int rotationAngle = 0;
//
//   List<Offset> points = [];
//
//   @override
//   void initState() {
//     //延迟每100毫秒旋转1度
//     Timer.periodic(Duration(milliseconds: 10), (timer) {
//       setState(() {
//         rotationAngle += 1;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var rr  =widget.arcObject.getArcInfoBySvgParams(startX,startY,rx,ry,
//         rotationAngle * pi/180
//         ,true,true, endX,endY);
//     // print("弧线信息：${rr.toString()}");
//     // print("起始角度：${rr.startAngle * 180 / pi}");
//     // print("扫描角度：${rr.sweepAngle * 180 / pi}");
//     //endregion
//
//     //小弧 rr
//     var painter = ArcPainter(
//         rotationAngle * pi/180,
//         Rect.fromCenter(center: rr.centerPoint, width: rx*2, height: ry*2),
//         rr.startAngle,
//         rr.sweepAngle,
//         true,
//         Colors.blue, true,true);
//     //绘制1度查看一下起始点位置
//     var painter2 = ArcPainter(
//         rotationAngle * pi/180,
//         Rect.fromCenter(center: rr.centerPoint, width: rx*2, height: ry*2),
//         rr.startAngle,
//         pi/180*1,
//         false,
//         Colors.red,true,true);
//
//     //一个交叉十字线表述45度
//     var lineColor = Color.fromARGB(55, 22, 255, 23);
//     var painter3 = LinePainter(Offset(startX,startY), Offset(startX-100,startY-100), lineColor);
//     var painter4 = LinePainter(Offset(startX,startY), Offset(startX+100,startY-100), lineColor);
//     var painter5 = LinePainter(Offset(startX,startY), Offset(startX+100,startY+100), lineColor);
//     var painter6 = LinePainter(Offset(startX,startY), Offset(startX-100,startY+100), lineColor);
//
//     //椭圆上的坐标点集合
//     var ellipse = Ellipse()
//       ..radiusX = Decimal.fromDouble(rx/2)
//       ..radiusY = Decimal.fromDouble(ry/2);
//     // List<Offset> points = [];
//     if(points.length>1000)
//       {
//         points.clear();
//       }
//     points.add(rr.centerPoint);
//     // for(var i=start2;i<(start2+sweep2);i++){
//     //   var p = ellipse.getOnEdgePointByAngle(Decimal.fromInt(i)).toOffset() +
//     //       Offset(startX,startY);
//     //   points.add(p);
//     // }
//
//     var pointPainter1 = PointsPainter(points, Color.fromARGB(255, 13, 251, 198), 2);
//
//
//
//
//
//     return Stack(
//       children: [
//         CustomPaint(
//           painter: TextPainter(Offset(100,120),rr.centerPoint.toString()
//               + "\r\n" + (rotationAngle%360).toString()
//               , Colors.red, 12),
//         ),
//         CustomPaint(
//           painter: painter,
//           // size: context.globalPaintBounds !=null?context.globalPaintBounds!.size:Size.zero,
//         ),
//         // CustomPaint(
//         //   painter: painter2,
//         // ),
//         CustomPaint(
//           painter: painter3,
//         ),
//         CustomPaint(
//           painter: pointPainter1,
//         ),
//         CustomPaint(
//           painter: painter4,
//         ),
//         CustomPaint(
//           painter: painter5,
//         ),
//         CustomPaint(
//           painter: painter6,
//         ),
//       ],
//     );
//   }
// }
// //
// // class ArcObjectWidget0 extends ConsumerWidget{
// //   final ArcObject arcObject;
// //   final Decimal viewPortScale;
// //   final Offset viewPortOffset;
// //   final Size viewPortPixelSize;
// //   final Color normalColor;// = Colors.white60;
// //   final Color hoverColor;// = Colors.white;
// //   final Color focusColor;// = Colors.blue;
// //   const ArcObjectWidget({super.key,
// //     required this.arcObject,
// //     required this.viewPortScale,
// //     required this.viewPortOffset,
// //     required this.viewPortPixelSize,
// //     this.normalColor = Colors.black, this.hoverColor = Colors.white, this.focusColor = Colors.lightGreen,
// //   });
// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     var startPointInView =
// //     Space.spacePointPos2ViewPortPointPos(arcObject.position, viewPortOffset, viewPortScale, viewPortPixelSize);
// //     var endPointInView =
// //     Space.spacePointPos2ViewPortPointPos(arcObject.endPoint, viewPortOffset, viewPortScale, viewPortPixelSize);
// //
// //     //起始位置
// //     double startX = 400;
// //     double startY = 300;
// //
// //     //结束位置
// //     double endX = 450;
// //     double endY = 350;
// //
// //     //椭圆的长短轴
// //     double rx = 100;
// //     double ry = 50;
// //
// //     double rotationZ = 0;
// //
// //     //region 测试使用圆心函数
// //     //通过参考w3上的svg圆弧原理公式,重新修正了该函数后,得到了正确的解,之前参考的C#代码有错误.
// //     //目前可以正确获取到圆心坐标,推导相关的SketchUP图命名为:svg和canvas圆弧推导.skp.已存储在坚果云中.
// //     var rr  =arcObject.getArcInfoBySvgParams(startX,startY,rx,ry,
// //         rotationZ
// //         ,true,true, endX,endY);
// //     print("弧线信息：${rr.toString()}");
// //     print("起始角度：${rr.startAngle * 180 / pi}");
// //     print("扫描角度：${rr.sweepAngle * 180 / pi}");
// //     //endregion
// //
// //     var rr2 = arcObject.computeArc(startX, startY, rx, ry, rotationZ, true, true, endX, endY);
// //
// //     print(rr2);
// //
// //     //小弧 rr3
// //     var rr3 = arcObject.endpointToCenterArcParams(
// //         PointEX(startX.toDecimal(),startY.toDecimal()),
// //         PointEX(endX.toDecimal(),endY.toDecimal()),
// //         Vector2D(rx.toDecimal(),ry.toDecimal()),
// //         Decimal.fromDouble(rotationZ)* decimalPi/Decimal.fromInt(180),
// //         true, true);
// //
// //     print(rr3);
// //     // var painter = ArcPainter(
// //     //   // Rect.fromCenter(center: Offset(rr2.x,rr2.y), width: rr2.width, height: rr2.height),
// //     //   Rect.fromLTWH(rr3.x.toDouble(), rr3.y.toDouble(), rx*2, ry*2),
// //     //     rr3.start.toDouble(),
// //     //     rr3.extent.toDouble(),
// //     //       true,
// //     //       Colors.blue);
// //
// //     //小弧 rr2
// //     // var painter = ArcPainter(
// //     //     // arcInfo.centerPoint + Offset(400,800),
// //     //     // Rect.fromCenter(center: rr.centerPoint, width: rx*2, height: ry*2),
// //     //   Rect.fromLTWH(rr2.x,rr2.y, rr2.width, rr2.height),
// //     //     // decimalPerDegree.toDouble() * start ,
// //     //     rr2.start,
// //     //     // decimalPerDegree.toDouble() * sweep,
// //     //     rr2.extent,
// //     //     // (times++%20) * (rr.sweepAngle/20),
// //     //     // decimalPerDegree.toDouble() * 30,
// //     //     true,
// //     //     Colors.blue);
// //
// //     //小弧 rr
// //     var painter = ArcPainter(
// //       // arcInfo.centerPoint + Offset(400,800),
// //       Rect.fromCenter(center: rr.centerPoint, width: rx*2, height: ry*2),
// //         // decimalPerDegree.toDouble() * start ,
// //         rr.startAngle,
// //         // decimalPerDegree.toDouble() * sweep,
// //         rr.sweepAngle,
// //         // (times++%20) * (rr.sweepAngle/20),
// //         // decimalPerDegree.toDouble() * 30,
// //         true,
// //         Colors.blue);
// //     //大弧
// //     var painter2 = ArcPainter(
// //       // arcInfo.centerPoint + Offset(400,800),
// //         Rect.fromCenter(center: rr.centerPoint, width: rx, height: ry),
// //         // decimalPerDegree.toDouble() * start2 ,
// //         rr.startAngle + rr.sweepAngle,
// //         // decimalPerDegree.toDouble() * sweep2,
// //         pi - rr.sweepAngle,
// //         // decimalPerDegree.toDouble() * 30,
// //         true,
// //         Colors.red);
// //
// //     //一个交叉十字线表述45度
// //     var lineColor = Color.fromARGB(55, 22, 255, 23);
// //     var painter3 = LinePainter(Offset(startX,startY), Offset(startX-100,startY-100), lineColor);
// //     var painter4 = LinePainter(Offset(startX,startY), Offset(startX+100,startY-100), lineColor);
// //     var painter5 = LinePainter(Offset(startX,startY), Offset(startX+100,startY+100), lineColor);
// //     var painter6 = LinePainter(Offset(startX,startY), Offset(startX-100,startY+100), lineColor);
// //
// //     //椭圆上的坐标点集合
// //     var ellipse = Ellipse()
// //     ..radiusX = Decimal.fromDouble(rx/2)
// //     ..radiusY = Decimal.fromDouble(ry/2);
// //     List<Offset> points = [];
// //     // for(var i=start2;i<(start2+sweep2);i++){
// //     //   var p = ellipse.getOnEdgePointByAngle(Decimal.fromInt(i)).toOffset() +
// //     //       Offset(startX,startY);
// //     //   points.add(p);
// //     // }
// //
// //     var pointPainter1 = PointsPainter(points, Color.fromARGB(44, 13, 251, 198), 3);
// //
// //
// //
// //
// //
// //
// //     return Stack(
// //       children: [
// //         CustomPaint(
// //           painter: painter,
// //         ),
// //         // CustomPaint(
// //         //   painter: painter2,
// //         // ),
// //         CustomPaint(
// //           painter: painter3,
// //         ),
// //         CustomPaint(
// //           painter: pointPainter1,
// //         ),
// //         CustomPaint(
// //           painter: painter4,
// //         ),
// //         CustomPaint(
// //           painter: painter5,
// //         ),
// //         CustomPaint(
// //           painter: painter6,
// //         ),
// //       ],
// //     );
// //   }
// // }