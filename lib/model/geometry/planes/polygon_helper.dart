/**
 * 多边形的帮助类.用于检测多边形之间的关系:
 * A包含B
 * A被B包含
 * A和B相等
 * A和B相交
 * A切于B(只有一个点和B的一条线相交)
 * A被B切(B只有一个点和A相交)
 * A挂于B(A的短边和B的长边重叠)
 * A挂B(A的长边下挂有短的B边)
 * A和B共边(A有一个边和B的边一样)
 * A和B形似(所有相邻线的比例序列相同)
 */


import 'dart:ui';
import 'dart:math';

import '../points/point_ex.dart';
import 'polygon.dart';

///两个图形之间的包含关系.
enum InclusionEnum
{
  ///未知
  unknown,
  ///包含后者
  contains,
  ///在后者之中
  inside,
  ///相同
  equal,
  ///相交
  cross,
  ///形似(目前是没有旋转的情况下)
  similar,
  ///相离,就是没有接触
  disjoint,
}
///两个图形之间的相接关系,不包含交叉的情况.交叉可以根据InclusionEnum=cross来判断,然后可以返回交叉的边数
enum TouchEnum
{
  ///未知
  unknown,
  ///点和点相交
  point2point,
  ///前者的边和后者的点相交,也就是 后切于前
  point2side,
  ///前者的点和后者的边相交,也就是 前切于后
  side2point,
  ///两者的边有重叠的地方,并且前者包含后者的边
  sideContainsSide,
  ///两者的边有重叠的地方,并且前者在后者中
  sideInsideSide,
  ///两者的边有重叠的地方,并且前者和后者的边相同,也就是共边
  shareSide,
}


var INFINITY = double.infinity;
var ESP = 1e-5;

///两个多边形之间的关系
class Relative
{
  late InclusionEnum inclusion = InclusionEnum.unknown;
  late TouchEnum touch = TouchEnum.unknown;

  @override
  String toString() {
    var msg = "";
    switch(inclusion)
    {
      case InclusionEnum.unknown:
        return "未知包含关系";
        break;
      case InclusionEnum.contains:
        msg+= '前者包含后者';
        break;
      case InclusionEnum.inside:
        msg+= '前者在后者中';
        break;
      case InclusionEnum.equal:
        msg+= '相等';
        break;
      case InclusionEnum.cross:
        msg+= '两个多边形相交';
        break;
      case InclusionEnum.similar:
        msg+= '两者形状相似';
        break;
      case InclusionEnum.disjoint:
        msg+= '两者没有交集';
        break;
    }

    switch(touch){
      case TouchEnum.unknown:
        msg+= '';
        break;
      case TouchEnum.point2point:
        msg+= '\r\n点和点相接';
        break;
      case TouchEnum.point2side:
        msg+= '\r\n前者的点接到后者的边上';
        break;
      case TouchEnum.side2point:
        msg+= '\r\n前者的边接到后者的点上';
        break;
      case TouchEnum.sideContainsSide:
        msg+= '\r\n前者的边包含后者的边';
        break;
      case TouchEnum.sideInsideSide:
        msg+= '\r\n前者的边在后者的边内';
        break;
      case TouchEnum.shareSide:
        msg+= '\r\n两者有相同的边';
        break;
    }
    msg += '\r\n';
    return msg;
  }
}



extension PolygonPathRelativeWith on Polygon
{
  Relative getRelativeWith(Polygon other)
  {
    Relative ret = Relative();
    //region 判断是否相等
    var allPointSame = true;
    //如果点数相等
    if(points.length == other.points.length){
      //如果所有点都相等,那就是相同
      for(var selfPoint in points){
        if(other.containsEndPoint(selfPoint) == false) {
          allPointSame = false;
        }
      }
      //如果不是所有的点都相等,那可能只是边一样而已.
    }
    //如果所有点都相同那就是相等.
    if(allPointSame) {
      ret.inclusion = InclusionEnum.equal;
    }
    //否则就有很多种情况了.
    else {
      var inside = true;
      // var selfPath = getPath();
      for(var selfPoint in points)
        {
          var selfPointIsInOtherPoly = Polygon.isPointInPolygon(selfPoint, other.points);
          if(selfPointIsInOtherPoly == false)
            {
              inside = false;
            }
        }
      if(inside) {
        ret.inclusion = InclusionEnum.inside;
        return ret;
      }
      var contains = true;
      for(var otherPoint in other.points){
        var c = Polygon.isPointInPolygon(otherPoint, points);
        if(!c){contains = false;}
      }
      if(contains) {
        ret.inclusion = InclusionEnum.contains;
        return ret;
      }
    }
    //endregion
    return ret;
  }
  Path toPath(){
    Path path = Path();
    path.addPolygon(points.map((e) => Offset(e.x,e.y)).toList(), true);
    return path;
  }
}

// // 判断点在多边形内 这个方法对我还说并不好用 只能检测到点是否在直线上.
// bool InPolygon(Polygon polygon, Point point) {
//   int n = polygon.points.length;
//   int count = 0;
//   var line = LineSegment();
//   line.pt1 = point;
//   line.pt2.y = point.y;
//   line.pt2.x = -INFINITY;
//   for (int i = 0; i < n; i++) {
//     // 得到多边形的一条边
//     var side = LineSegment();
//     side.pt1 = polygon.points[i];
//     side.pt2 = polygon.points[(i + 1) % n];
//     if (IsOnline(point, side)) {
//       return true;
//     }
//     // 如果side平行x轴则不作考虑
//     if (fabs(side.pt1.y - side.pt2.y) < ESP) {
//       continue;
//     }
//     if (IsOnline(side.pt1, line)) {
//       if (side.pt1.y > side.pt2.y) count++;
//     } else if (IsOnline(side.pt2, line)) {
//       if (side.pt2.y > side.pt1.y) count++;
//     } else if (Intersect(line, side)) {
//       count++;
//     }
//   }
//   if (count % 2 == 1) {
//     return false;
//   }
//   else {
//     return true;
//   }
// }

