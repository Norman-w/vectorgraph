import 'package:flutter/material.dart';
import 'package:vectorgraph/utils/num_utils.dart';
import '../lines/line_segment.dart';
import '../points/point_ex.dart';
import '../rect/RectEX.dart';

class Polygon{
  ///构造函数,由点集合创建一个多边形
  Polygon(this.points);
  List<PointEX> points;
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

  RectEX get bounds {
    Decimal top = Decimal.infinite,left = Decimal.infinite,right = Decimal.negativeInfinity,bottom = Decimal.negativeInfinity;
    for(var i=0;i<points.length;i++){
      var current = points[i];
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
    return RectEX.fromLTRB(left, top, right, bottom);
  }
}