import 'package:flutter/material.dart';
class LinesPaint extends StatelessWidget {
  final List<Offset> linesPoints;
  final Color color;
  const LinesPaint(this.linesPoints, this.color, {super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinesPainter(linesPoints, color),
    );
  }
}
class LinesPainter extends CustomPainter {
  final List<Offset> linesPoints;
  final Color color;
  LinesPainter(this.linesPoints, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    if(linesPoints.length%2!=0){
      // debugPrint("点数应该是双数");
    }
    for(var i=0;i<linesPoints.length-1; i+=1){
      var start = linesPoints[i];
      var end = linesPoints[i+1];
      canvas.drawLine(start, end, paint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class LinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;
  LinePainter(this.start, this.end, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawLine(start,end, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class LinePaint extends StatelessWidget {
  final Offset start;
  final Offset end;
  final Color color;
  const LinePaint(this.start, this.end, this.color, {super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinePainter(start,end, color),
    );
  }
}