import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vectorgraph/viewer/rect_painter.dart';
import 'package:vectorgraph/viewer/space_layer.dart';
import 'package:window_manager/window_manager.dart';

import 'viewer/canva.dart';
import 'viewer/paper.dart';
import 'viewer/space.dart';
import 'viewer/view_port.dart';
//import layer class


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

  runApp(MyApp());
}

Space initSpace(){
  var space = Space();
  var layer = SpaceLayer(0);



  var paper = Paper(
    name: "paper1",
    width: 1000,
    height: 1000,
    color: Colors.white,
  );

  space.addPaper(paper);

  space.layers.add(layer);
    return space;
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //初始化空间以进行渲染
    var space = initSpace();
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
              ViewPort(space),
              //测试绘制一些矩形
              RectPaint(
                [
                  Rect.fromLTWH(30, 30, 100, 100),
                  Rect.fromLTWH(100, 100, 100, 100),
                  Rect.fromLTWH(200, 200, 100, 100),
                ],
                Colors.black,
              ),
            ],
          )
        )
    );
  }
}