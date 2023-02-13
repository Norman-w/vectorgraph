import 'package:flutter/material.dart';

/**
 * 纸张.
 * 可以理解为限定输出的区域.超出这个区域的可以绘制,但是不能打印出来.理解成一个参照就可以.实际上
 * 在编辑矢量图或者是各种结构图,草图,流程图,思维导图等都是以这个大小来参考而非绝对限制.
 */

class Paper{
  String name;
  double width;
  double height;
  Color color;
  Paper({required this.name,required this.width,required this.height,required this.color});
}

class PaperWidget extends StatefulWidget {
  final Paper paper;
  final Widget child;
  PaperWidget({Key? key,required this.paper,required this.child}) : super(key: key);
  @override
  _PaperWidgetState createState() => _PaperWidgetState();
}

class _PaperWidgetState extends State<PaperWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.paper.width,
      height: widget.paper.height,
      child: widget.child,
      //show border
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black,width: 1)
      ),
    );
  }
}