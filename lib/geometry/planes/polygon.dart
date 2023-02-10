import 'dart:math';

import 'package:flutter/material.dart';

import '../lines/line_segment.dart';
import '../points/point_ex.dart';
import '../../utils.dart';

class Polygon{
  Polygon(this.points);
  List<PointEX> points;
  bool containsEndPoint(PointEX point){
    for(var p in points){
      if(point.x == p.x && point.y == p.y) {
        return true;
      }
    }
    return false;
  }
  bool isPointIn(PointEX point) {
    return Polygon.isPointInPolygon(point, points);
  }
  bool isPointXYIn(double x, double y)
  {
    return isPointIn(PointEX(x, y));
  }
  bool isContains(Polygon polygon){
    for(var p in polygon.points){
      if(!isPointIn(p)){
        return false;
      }
    }
    return true;
  }
  static bool isPointInPolygon(PointEX point, List<PointEX> pts)
  {
    int N = pts.length;
    //如果点位于多边形的顶点或边上，也算做点在多边形内，直接返回true
    bool boundOrVertex = true;
    //cross points count of x
    int intersectCount = 0;
    //浮点类型计算时候与0比较时候的容差
    double precision = 2e-10;
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
      if (p.x < min(p1.x, p2.x) || p.x > max(p1.x, p2.x)) {
        p1 = p2;
        //next ray left point
        continue;
      }
      //ray is crossing over by the algorithm (common part of)
      if (p.x > min(p1.x, p2.x) && p.x < max(p1.x, p2.x)) {
        //x is before of ray
        if (p.y <= max(p1.y, p2.y)) {
          //overlies on a horizontal ray
          if (p1.x == p2.x && p.y >= min(p1.y, p2.y)) {
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
            double xinters = (p.x - p1.x) * (p2.y - p1.y) / (p2.x - p1.x) + p1.y;
            //overlies on a ray
            if (fabs(p.y - xinters) < precision) {
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
          if (p.x >= min(p1.x, p3.x) && p.x <= max(p1.x, p3.x)) {
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
  ///移动当前的对象并创建一个新实例
  void offset(double x,double y)
  {
    // var newPath = PolygonalPath(size:size,count:count);
    // for(var p in newPath.points)
    //   {
    //     p = p + Point(x,y);
    //   }
    for(var i=0;i<points.length;i++){
      points[i].x += x;
      points[i].y += y;
    }
  }

  Path getPath()
  {
    var path = Path();
    path.addPolygon(points.map((e) => Offset(e.x,e.y)).toList(), true);
    return path;
  }

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
}