import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'canvas/canva.dart';

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
      home: Canva(),
    );
  }
}