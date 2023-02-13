import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vectorgraph/viewer/ruler.dart';
class ViewPort extends StatefulWidget {
  const ViewPort({Key? key}) : super(key: key);
  @override
  createState() => _ViewPortState();
}
class _ViewPortState extends State<ViewPort>
{
  double currentScale =0.5;
  Offset currentOffset = Offset.zero;
  double rectWidth = 100;
  double rectLeft = 29.57429;
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 2000), (timer) {
      setState(() {
        // rectWidth = rectWidth *1.01;
        rectLeft = rectLeft * 1.001;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child:Ruler(
            Rect.fromLTWH(rectLeft, 0, rectWidth, 0),
          )
        ),
        Align(
          alignment: Alignment.center,
          child: Text(rectLeft.toStringAsFixed(5)),
        )
      ],
    );
  }
}





