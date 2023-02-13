import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vectorgraph/viewer/rect_painter.dart';
import 'package:window_manager/window_manager.dart';

import 'viewer/canva.dart';
import 'viewer/view_port.dart';

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              //先绘制背景
              Container(
                decoration:
                BoxDecoration(
                  color: Colors.grey[700],
                  border: Border.all(color: Colors.grey[350]!),
                ),
              ),
              //在上面绘制视口
              ViewPort(),
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