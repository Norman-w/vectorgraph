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
  double rectWidth = 1;
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        rectWidth = rectWidth *1.01;
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
            Rect.fromLTWH(10, 0, rectWidth, 0),
          )
        )
      ],
    );
  }
}





