import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vectorgraph/geometry/lines/line_segment.dart';

import '../geometry/points/point_ex.dart';


class Canva extends StatefulWidget {
  const Canva({Key? key}) : super(key: key);

  @override
  createState() => _CanvaState();
}



class _CanvaState extends State<Canva> {

  Offset? mouseDownPosition;
  Offset? mouseMoveToPosition;
  var log = '';
  bool showGrids = false;
  List<LineSegment> lines = [];
  String currentSelectTool = '';
  List<LineSegment> intersectedLines = [];



  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onExit: (event) {
        },
        onEnter: (event) {
        },
        onHover: (event) {
          var mousePoint = PointEX(event.position.dx, event.position.dy);
          intersectedLines = [];
          lines.forEach((element) {
            if(
            element.isInBoundingBox(mousePoint)
            &&
            element.isPointOnLine(mousePoint,deviation: 4)
            )
            {
              print('有交点啦!!!!');
              intersectedLines.add(element);
            }
          });
          setState(() {
            // log = mousePoint.toString() + ' ' + intersectedLines.length.toString()+
            //     (lines.length > 0 ? lines[0].toString() : '');
            //相交的线段数
            log = intersectedLines.length.toString();
          });
        },
      child: Listener(
        onPointerDown: (event) {
          setState(() {
            log = 'onPointerDown' + event.position.toString();
            mouseDownPosition = event.position;
            showGrids = true;
          });
        },
        onPointerMove: (event) {

          setState(() {
            log = 'onPointerDown' + event.position.toString();
            mouseMoveToPosition = event.position;
            showGrids = true;
          });
        },
        onPointerUp: (event) {
          if(currentSelectTool == 'line')
            {
              setState(() {
                log = 'onPointerUp' + event.position.toString();

                showGrids = false;
                //add a line to lines list
                if(mouseDownPosition!= null && mouseMoveToPosition!= null) {
                  lines.add(LineSegment(
                    //convert mouse down and move position to params
                      PointEX(mouseDownPosition!.dx, mouseDownPosition!.dy),
                      PointEX(mouseMoveToPosition!.dx, mouseMoveToPosition!.dy
                      )));
                }
              });
            }
          setState(() {
            mouseDownPosition = null;
            mouseMoveToPosition = null;
          });
        },
          child:
              Stack(
                children: [
                  //show a box on left width set to 100

                  CustomPaint(
                    painter: CanvasPainter(),
                    child:  Align(
                      alignment: Alignment.topCenter,
                      child: Text(log),
                    ),
                  ),
                    CustomPaint(
                      size: Size.infinite,
                      painter: GridsPainter(20),
                    ),
                  //show lines using line painter
                  ...lines.map((e) => CustomPaint(
                    size: Size.infinite,
                    painter: LinePainter(
                        Offset(e.start.x  as double , e.start.y as double),
                        Offset(e.end.x as double, e.end.y as double),
                      color: intersectedLines.indexOf(e) == 0 ? Colors.white : Colors.black,
                    ),
                  )),
                  //show drawing line
                  if(currentSelectTool ==
                  'line')
                    CustomPaint(
                      size: Size.infinite,
                      painter: LinePainter(
                          mouseDownPosition,
                          mouseMoveToPosition,
                          color: Colors.red
                      ),
                    ),

                  Container(
                    width: 50,
                    color: Colors.black26,
                    //child is a column that contains icon buttons
                    child:
                      Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Column(
                          children: [
                            //add a pointer button
                            IconButton(
                              icon:
                              //rotate icon angle -45
                              Transform.rotate(
                                angle: 45 * pi / 180,
                                child: Icon(Icons.arrow_back,
                                  color: currentSelectTool == 'pointer' ?
                                  Colors.white : Colors.black,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  currentSelectTool = 'pointer';
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.mouse_outlined,
                              color: currentSelectTool == 'line' ?
                              Colors.white : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  currentSelectTool = 'line';
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.highlight_remove_rounded,
                                  color: currentSelectTool == 'eraser' ?
                                  Colors.white : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  currentSelectTool = 'eraser';
                                });
                              },
                            ),
                          ],
                        ),
                      )
                  ),
                ],
              )
      )
    );
  }
}

class CanvasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //region 填充背景
    var paint = Paint()
      ..color = Color.fromARGB(255, 160, 166, 166)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      //size to rect
      Rect.fromLTWH(0, 0, size.width, size.height),
        paint);
    //endregion
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LinePainter extends CustomPainter {

  final Offset? start;
  final Offset? end;
  Color color;

  LinePainter(this.start, this.end, {this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    if(start == null || end == null) {
      return;
    }
    var paint = Paint()
    //smooth
      ..strokeCap = StrokeCap.round
    ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawLine(start!, end!, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class GridsPainter extends CustomPainter {
  int perGridSize;
  GridsPainter(this.perGridSize);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 0.1
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < size.width; i += perGridSize) {
      canvas.drawLine(Offset(i.toDouble(), 0), Offset(i.toDouble(), size.height), paint);
    }
    for (var i = 0; i < size.height; i += perGridSize) {
      canvas.drawLine(Offset(0, i.toDouble()), Offset(size.width, i.toDouble()), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}