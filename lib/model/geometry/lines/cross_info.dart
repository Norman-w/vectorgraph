import '../points/point_ex.dart';
import 'line_segment.dart';

class CrossInfo {
  bool isCross = false;
  PointEX? crossPoint;
  double? startPointToCrossPointDistance;
  double? endPointToCrossPointDistance;

  CrossInfo(this.isCross,
      {
        this.crossPoint,
        this.startPointToCrossPointDistance,
        this.endPointToCrossPointDistance
      });
  @override
  String toString() {
    return "CrossInfo{isCross: $isCross\r\ncrossPoint: $crossPoint\r\nstartPointToCrossPointDistance: $startPointToCrossPointDistance\r\nendPointToCrossPointDistance: $endPointToCrossPointDistance}";
  }
}

//可以检测到是否相交,但是检测到的交点不准确,交点到起点的距离和交点到终点的距离不准确
// CrossInfo getTwoLineSegmentsCrossInfo(LineSegment lineA, LineSegment lineB){
//   var vector1 = lineA.getVector();
//   var vector2 = lineB.getVector();
//   var vector3 = lineA.start - lineB.start;
//   var cross1 = vector1.x * vector2.y - vector1.y * vector2.x;
//   var cross2 = vector1.x * vector3.y - vector1.y * vector3.x;
//   if(cross1 == 0){
//     return CrossInfo(false);
//   }
//   var r = cross2 / cross1;
//   if(r < 0 || r > 1){
//     return CrossInfo(false);
//   }
//   var cross3 = vector2.x * vector3.y - vector2.y * vector3.x;
//   var s = cross3 / cross1;
//   if(s < 0 || s > 1){
//     return CrossInfo(false);
//   }
//   var crossPoint = PointEX(lineB.start.x + vector2.x * s, lineB.start.y + vector2.y * s);
//   return CrossInfo(true,
//       // crossPoint: crossPoint,
//       // startPointToCrossPointDistance: lineA.getStartPointToDistance(crossPoint),
//       // endPointToCrossPointDistance: lineA.getEndPointToDistance(crossPoint)
//   );
// }


// /**
//  * 顺序无关，ab,cd为线段
//  * @param {*} a 线段ab起点坐标
//  * @param {*} b 线段ab终点坐标
//  * @param {*} c 线段cd起点坐标
//  * @param {*} d 线段ab终点坐标
//  */
// function segmentsIntr(a, b, c, d) {
//   // 三角形abc 面积的2倍
//   const area_abc = (a.x - c.x) * (b.y - c.y) - (a.y - c.y) * (b.x - c.x);
//
//   // 三角形abd 面积的2倍
//   const area_abd = (a.x - d.x) * (b.y - d.y) - (a.y - d.y) * (b.x - d.x);
//
//   // 面积符号相同则两点在线段同侧,不相交 (对点在线段上的情况,本例当作不相交处理（==0则对点）);
//   // 对点也当作相交则 > 0 即可
//   if (area_abc * area_abd > 0) {
//     return false;
//   }
//
//   // 三角形cda 面积的2倍
//   const area_cda = (c.x - a.x) * (d.y - a.y) - (c.y - a.y) * (d.x - a.x);
//   // 三角形cdb 面积的2倍
//   // 注意: 这里有一个小优化.不需要再用公式计算面积,而是通过已知的三个面积加减得出.
//   const area_cdb = area_cda + area_abc - area_abd;
//   if (area_cda * area_cdb > 0) {
//     return false;
//   }
//
//   // 计算交点坐标
//   const t = area_cda / (area_abd - area_abc);
//   // eslint-disable-next-line one-var
//   const dx = t * (b.x - a.x),
//       dy = t * (b.y - a.y);
//   // const x = Math.trunc(a.x + dx);
//   const x = +(a.x + dx).toFixed(2);
//   const y = +(a.y + dy).toFixed(2);
//   return { x, y };
// }
//convert segmentsIntr to dart
CrossInfo getTwoLineSegmentsCrossInfo(LineSegment lineA, LineSegment lineB) {
  var a = lineA.start;
  var b = lineA.end;
  var c = lineB.start;
  var d = lineB.end;
  // 三角形abc 面积的2倍
  final area_abc = (a.x - c.x) * (b.y - c.y) - (a.y - c.y) * (b.x - c.x);

  // 三角形abd 面积的2倍
  final area_abd = (a.x - d.x) * (b.y - d.y) - (a.y - d.y) * (b.x - d.x);

  // 面积符号相同则两点在线段同侧,不相交 (对点在线段上的情况,本例当作不相交处理（==0则对点）);
  // 对点也当作相交则 > 0 即可
  if (area_abc * area_abd > 0) {
    return CrossInfo(false);
  }

  // 三角形cda 面积的2倍
  final area_cda = (c.x - a.x) * (d.y - a.y) - (c.y - a.y) * (d.x - a.x);
  // 三角形cdb 面积的2倍
  // 注意: 这里有一个小优化.不需要再用公式计算面积,而是通过已知的三个面积加减得出.
  final area_cdb = area_cda + area_abc - area_abd;
  if (area_cda * area_cdb > 0) {
    return CrossInfo(false);
  }

  // 计算交点坐标
  final t = area_cda / (area_abd - area_abc);
  // eslint-disable-next-line one-var
  final dx = t * (b.x - a.x);
  final dy = t * (b.y - a.y);
  // const x = Math.trunc(a.x + dx);
  final x = (a.x + dx).toDouble();
  final y = (a.y + dy).toDouble();
  return CrossInfo(true,
      crossPoint: PointEX(x, y),
      startPointToCrossPointDistance: lineA.start.distanceTo(PointEX(x, y)),
      endPointToCrossPointDistance: lineA.end.distanceTo(PointEX(x, y))
  );
}