import 'package:flutter/material.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../lines/line_segment.dart';
import '../points/point_ex.dart';
import '../rect/RectEX.dart';

class Polygon{
  // var _center = PointEX.zero;
  var _bounds = RectEX.zero;
  factory Polygon.fromPoints(List<PointEX> points){
    return Polygon()..points = points;
  }
  ///构造函数,由点集合创建一个多边形
  Polygon();
  List<PointEX> _points = [];
  List<PointEX> get points => _points;
  set points(List<PointEX> value) {
    //如果多边形的点数小于3,则不是一个多边形
    if(value.length<3){
      print('多边形的点数小于3,不是一个多边形, 点集合是:$value');
    }
    Decimal top = Decimal.infinite,left = Decimal.infinite,right = Decimal.negativeInfinity,bottom = Decimal.negativeInfinity;
    for(var i=0;i<value.length;i++){
      var current = value[i];
      if(current.y<top){
        top = current.y;
      }
      if(current.y>bottom){
        bottom = current.y;
      }
      if(current.x<left){
        left = current.x;
      }
      if(current.x>right){
        right = current.x;
      }
    }
    _bounds = RectEX.fromLTRB(left, top, right, bottom);
    _points = value;

    //region 计算中心点
    // try {
    //   var total = Decimal.fromInt(points.length);
    //   Decimal X = Decimal.zero, Y = Decimal.zero, Z = Decimal.zero;
    //   //遍历
    //   for (var p in points) {
    //     Decimal lat, lon, x, y, z;
    //     lat = p.y * decimalPi / Decimal.halfCircle;
    //     lon = p.x * decimalPi / Decimal.halfCircle;
    //     x = decimalCos(lat) * decimalCos(lon);
    //     y = decimalCos(lat) * decimalSin(lon);
    //     z = decimalSin(lat);
    //     X += x;
    //     Y += y;
    //     Z += z;
    //   }
    //   X = X / total;
    //   Y = Y / total;
    //   Z = Z / total;
    //   Decimal Lon = decimalAtan2(Y, X);
    //   Decimal Hyp = decimalSqrt(X * X + Y * Y);
    //   Decimal Lat = decimalAtan2(Z, Hyp);
    //   // return PointEX(Lon * Decimal.halfCircle / decimalPi, Lat * Decimal.halfCircle / decimalPi);
    //   _center = PointEX(Lon * Decimal.halfCircle / decimalPi, Lat * Decimal.halfCircle / decimalPi);
    // } catch (e) {
    //   print(e);
    // }
    //endregion
  }
  ///判断当前多边形是否有一个顶点是所给定的入参
  bool containsEndPoint(PointEX point){
    for(var p in points){
      if(point.x == p.x && point.y == p.y) {
        return true;
      }
    }
    return false;
  }
  ///判断点是否在当前这个多边形中
  bool isPointIn(PointEX point) {
    return Polygon.isPointInPolygon(point, points);
  }
  ///判断x,y标记的坐标是否在这个多边形中
  bool isPointXYIn(Decimal x, Decimal y)
  {
    return isPointIn(PointEX(x, y));
  }
  ///判断当前的多边形是否包含另外一个多边形
  bool isContains(Polygon polygon){
    for(var p in polygon.points){
      if(!isPointIn(p)){
        return false;
      }
    }
    return true;
  }
  ///一个多边形由pts所指的的所有点围成,判断point是否在这个多边形中
  static bool isPointInPolygon(PointEX point, List<PointEX> pts)
  {
    int N = pts.length;
    //如果点位于多边形的顶点或边上，也算做点在多边形内，直接返回true
    bool boundOrVertex = true;
    //cross points count of x
    int intersectCount = 0;
    //浮点类型计算时候与0比较时候的容差
    Decimal precision = Decimal.parse((2e-10).toString());
    //neighbour bound vertices
    PointEX p1, p2;
    //当前点
    PointEX p = point;
    //left vertex
    p1 = pts[0];
    //check all rays
    for (int i = 1; i <= N; ++i) {
      if (p.equals(p1)) {
        //p is an vertex
        return boundOrVertex;
      }
      //right vertex
      p2 = pts[i % N];
      //ray is outside of our interests
      if (p.x < decimalMin(p1.x, p2.x) || p.x > decimalMax(p1.x, p2.x)) {
        p1 = p2;
        //next ray left point
        continue;
      }
      //ray is crossing over by the algorithm (common part of)
      if (p.x > decimalMin(p1.x, p2.x) && p.x < decimalMax(p1.x, p2.x)) {
        //x is before of ray
        if (p.y <= decimalMax(p1.y, p2.y)) {
          //overlies on a horizontal ray
          if (p1.x == p2.x && p.y >= decimalMin(p1.y, p2.y)) {
            return boundOrVertex;
          }
          //ray is vertical
          if (p1.y == p2.y) {
            //overlies on a vertical ray
            if (p1.y == p.y) {
              return boundOrVertex;
              //before ray
            } else {
              ++intersectCount;
            }
          } else {
            //cross point on the left side
            //cross point of y
            Decimal xinters = (p.x - p1.x) * (p2.y - p1.y) / (p2.x - p1.x) + p1.y;
            //overlies on a ray
            if ((p.y - xinters).abs() < precision) {
              return boundOrVertex;
            }
            //before ray
            if (p.y < xinters) {
              ++intersectCount;
            }
          }
        }
      } else {
        //special case when ray is crossing through the vertex
        //p crossing over p2
        if (p.x == p2.x && p.y <= p2.y) {
          //next vertex
          PointEX p3 = pts[(i + 1) % N];
          //p.x lies between p1.x & p3.x
          if (p.x >= decimalMin(p1.x, p3.x) && p.x <= decimalMax(p1.x, p3.x)) {
            ++intersectCount;
          } else {
            intersectCount += 2;
          }
        }
      }
      //next ray left point
      p1 = p2;
    }
    //偶数在多边形外
    if (intersectCount % 2 == 0) {
      return false;
    } else {
      //奇数在多边形内
      return true;
    }
  }
  ///移动当前的对象
  void offset(Decimal x,Decimal y)
  {
    for(var i=0;i<points.length;i++){
      points[i].x += x;
      points[i].y += y;
    }
  }

  ///转换成视图格式的Path(不包含变换,只是格式转换)
  Path getPath()
  {
    var path = Path();
    path.addPolygon(points.map((e) => Offset(e.x.toDouble(),e.y.toDouble())).toList(), true);
    return path;
  }
  ///获取围成多边形的线段列表
  List<LineSegment> getLineSegments()
  {
    var list = <LineSegment>[];
    for(var i=0;i<points.length;i++)
    {
      var p1 = points[i];
      var p2 = points[(i+1)%points.length];
      list.add(LineSegment(p1,p2));
    }
    return list;
  }

  // PointEX get center{
  //   return _center;
  // }

  RectEX get bounds {
    return _bounds;
  }
}