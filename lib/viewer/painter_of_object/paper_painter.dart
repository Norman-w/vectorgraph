import 'dart:ui';

import 'package:flutter/material.dart';

import '../paper.dart';
import 'rect_painter.dart';

class PaperPainter extends RectPainter{
  final Paper paper;
  PaperPainter(super.rects, super.color, this.paper);
  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    //绘制边框
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawRect(paper.rect, paint);
  }
}