import 'package:flutter/material.dart';
import 'package:vectorgraph/objects/point_object.dart';
import 'package:vectorgraph/viewer/painting_board.dart';
import '../utils/widget.dart';
import 'package:vectorgraph/viewer/space_layer.dart';

import 'objects/rect_object.dart';
import 'viewer/paper.dart';
import 'viewer/space.dart';
import 'viewer/viewState.dart';
import 'viewer/view_port.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // // 必须加上这一行。
  // await windowManager.ensureInitialized();
  //
  // WindowOptions windowOptions = WindowOptions(
  //   fullScreen: true,
  //   // size: Size(800, 600),
  //   center: true,
  //   backgroundColor: Colors.transparent,
  //   skipTaskbar: false,
  //   titleBarStyle: TitleBarStyle.hidden,
  // );
  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.show();
  //   await windowManager.focus();
  // });

  runApp(const ProviderScope(child:MyApp()));
}

void initSpace(){
  var space = Space();
  var layer = SpaceLayer(0);



  var paper = Paper(
    name: "paper1",
    width: 400,
    height: 300,
    color: Colors.lightGreen,
  )..left = 180..top = 150;


  // var rect1 = RectEX.fromLTWH(20, 30, 20, 20);
  // var rect2 = RectEX.fromLTWH(50, 60, 15, 20);
  // var rect3 = RectEX.fromLTWH(70, 80, 20, 12);
  // var rect4 = RectEX.fromLTWH(85, 105, 30, 25);

  // layer.addRect(rect1);
  // layer.addRect(rect2);
  // layer.addRect(rect3);
  // layer.addRect(rect4);
  layer.addRect(
      RectObject.fromCenter(center: const Offset(0,0), width: 100, height: 100)
  );
  layer.addRect(
      RectObject.fromCenter(center: const Offset(0,0), width: 400, height: 300)
  );
  
  layer.addPoint(
      PointObject(0, 0)
  );

  space.addPaper(paper);

  space.layers.add(layer);

  ViewState.space = space;
}

List<Offset> smoothPoints(List<Offset> points, int level) {
  List<Offset> result = [];
  for (int i = 0; i < points.length - 1; i++) {
    Offset p1 = points[i];
    Offset p2 = points[i + 1];
    double dx = (p2.dx - p1.dx) / level;
    double dy = (p2.dy - p1.dy) / level;
    for (int j = 0; j < level; j++) {
      result.add(Offset(p1.dx + dx * j, p1.dy + dy * j));
    }
  }
  return result;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const int nodeCount = 50;
    double maxHeight = 400;
    const int yOffset = 400;
    // const int smoothLevel = 20;
    var bound = context.globalPaintBounds ?? Rect.zero;
    double perNodeWidth = bound.width / nodeCount;
    List<Offset> randomPoints = [];
    for (int i = 0; i <= nodeCount; i++) {
      maxHeight /= 1.02;
        randomPoints.add(Offset(
            i * perNodeWidth,
            Random().nextDouble() * maxHeight + yOffset));
    }
    // print(randomPoints.length);

    var path = Path();
    //path cubicTo each random point
    path.moveTo(randomPoints[0].dx, randomPoints[0].dy);
    for (int i = 1; i < randomPoints.length; i++) {
      path.cubicTo(
        //     #region nice curve
        //     randomPoints[i - 1].dx + perNodeWidth/0.8,
        //     randomPoints[i - 1].dy,
        //     randomPoints[i].dx - perNodeWidth/1.5,
        //     #endregion
          randomPoints[i - 1].dx + perNodeWidth/2,
          randomPoints[i - 1].dy,
          randomPoints[i].dx - perNodeWidth/2,
          randomPoints[i].dy,
          randomPoints[i].dx,
          randomPoints[i].dy);
    }

    //初始化空间以进行渲染
    initSpace();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
        Scaffold(
          body:
          Stack(
            children: [
              //之前的一个测试,可以直接用鼠标拖动绘制直线的例子,有背景网格
              //Canva(),
              //先绘制背景
              Container(
                decoration:
                BoxDecoration(
                  color: Colors.grey[700],
                  border: Border.all(color: Colors.grey[350]!),
                ),
              ),
              //在上面绘制视口
              const ViewPort(),
              const PaintingBoard(),
              //测试绘制一些矩形
              // RectPaint(
              //   [
              //     Rect.fromLTWH(30, 30, 100, 100),
              //     Rect.fromLTWH(100, 100, 100, 100),
              //     Rect.fromLTWH(200, 200, 100, 100),
              //   ],
              //   Colors.black,
              // ),
              // PointsPaint(
              //   randomPoints,
              //   Colors.tealAccent,
              //   10.0,
              //   showPositionText: true,
              // ),
              //
              // PointsPaint(
              //     // randomPoints,
              //   smoothPoints(randomPoints, smoothLevel),
              //   Colors.deepOrangeAccent,
              //   2.0,
              // ),
              // PathPaint(
              //   //move to each random point
              //   path,
              //   Colors.amber,
              //   3.0,
              // ),
            ],
          )
        )
    );
  }
}