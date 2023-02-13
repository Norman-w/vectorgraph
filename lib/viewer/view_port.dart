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
  double rectWidth = 200;
  double rectLeft = 80;
  double rectHeight = 150;
  double rectTop = 91.5;
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 20), (timer) {
      setState(() {
        rectWidth = rectWidth *1.001;
        rectHeight = rectHeight *1.001;
        rectLeft = rectLeft * 1.0011;
        rectTop = rectTop * 1.0015;
        // print(rectTop);
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
            Rect.fromLTWH(rectLeft, rectTop, rectWidth, rectHeight),
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





