import 'dart:ui';

import 'package:vectorgraph/model/geometry/lines/line_segment.dart';

import '../../../utils/num_utils.dart';
import '../SizeEX.dart';
import '../points/point_ex.dart';

class RectEX {
  //region 字段
  Decimal left;
  Decimal top;
  Decimal right;
  Decimal bottom;
  //endregion

  //region 属性
  Decimal get width => right - left;
  Decimal get height => bottom - top;
  PointEX get rightBottom => PointEX(right, bottom);
  Decimal get centerX => left + (right - left) / Decimal.two;
  Decimal get centerY => top + (bottom - top) / Decimal.two;
  PointEX get center => PointEX(centerX, centerY);
  PointEX get topRight => PointEX(right, top);
  PointEX get leftTop => PointEX(left, top);
  PointEX get topLeft => PointEX(left, top);
  PointEX get bottomRight => PointEX(right, bottom);
  PointEX get bottomLeft => PointEX(left, bottom);
  ///获取边缘的四条边
  List<LineSegment> get edgeLineSegments{
    return [
      LineSegment(leftTop, topRight),
      LineSegment(topRight, rightBottom),
      LineSegment(rightBottom, bottomLeft),
      LineSegment(bottomLeft, leftTop),
    ];
  }
  SizeEX get size => SizeEX(width, height);
  set width(Decimal value) => right = left + value;
  set height(Decimal value) => bottom = top + value;
  set leftTop(PointEX value) {
    left = value.x;
    top = value.y;
  }

  set rightBottom(PointEX value) {
    right = value.x;
    bottom = value.y;
  }
  set topRight(PointEX value) {
    right = value.x;
    top = value.y;
  }
  set topLeft(PointEX value) {
    left = value.x;
    top = value.y;
  }
  set bottomRight(PointEX value) {
    right = value.x;
    bottom = value.y;
  }
  set bottomLeft(PointEX value) {
    left = value.x;
    bottom = value.y;
  }
  //endregion

  //region 工厂函数
  RectEX.fromLTRB(
      Decimal left,
      Decimal top,
      Decimal right,
      Decimal bottom,
      ) : this(left, top, right, bottom);
  RectEX.fromCenter({required PointEX center, required Decimal width, required Decimal height})
      : left = center.x - width / Decimal.two,
        top = center.y - height / Decimal.two, bottom = center.y + height / Decimal.two,
        right = center.x + width / Decimal.two
  ;
  RectEX.fromCircle({required PointEX center, required Decimal radius})
      : left = center.x - radius,
        top = center.y - radius,
        right = center.x + radius,
        bottom = center.y + radius;
  RectEX.fromLTWH(Decimal left, Decimal top, Decimal width, Decimal height)
      : this(
    left,
    top,
    left + width,
    top + height,
  );
  bool get isEmpty => width <= Decimal.zero || height <= Decimal.zero;

  RectEX.fromPoints(PointEX a, PointEX b)
      : this(
    decimalMin(a.x, b.x),
    decimalMin(a.y, b.y),
    decimalMax(a.x, b.x),
    decimalMax(a.y, b.y),
  );
  //endregion

  //region 构造函数
  RectEX(this.left, this.top, this.right, this.bottom);
  //endregion

  //region 导出
  Rect toRect() {
    return Rect.fromLTRB(left.toDouble(), top.toDouble(), right.toDouble(), bottom.toDouble());
  }
  //endregion

  //region 重载
  @override
  String toString() {
    return 'RectEX{left: $left, top: $top, right: $right, bottom: $bottom}';
  }
  //endregion

  //region static
  static final zero = RectEX.fromLTWH(Decimal.zero, Decimal.zero, Decimal.zero, Decimal.zero);
  //endregion
}
extension RectEXFunctions on RectEX {
  RectEX expand (Decimal delta) {
    return RectEX(
      left - delta,
      top - delta,
      right + delta,
      bottom + delta,
    );
  }

  RectEX shift(Decimal dx, Decimal dy) {
    return RectEX(
      left + dx,
      top + dy,
      right + dx,
      bottom + dy,
    );
  }

  RectEX inflate(Decimal delta) {
    return RectEX(
      left - delta,
      top - delta,
      right + delta,
      bottom + delta,
    );
  }

  RectEX deflate(Decimal delta) {
    return RectEX(
      left + delta,
      top + delta,
      right - delta,
      bottom - delta,
    );
  }

  RectEX intersect(RectEX other) {
    return RectEX(
      decimalMax(left, other.left),
      decimalMax(top, other.top),
      decimalMin(right, other.right),
      decimalMin(bottom, other.bottom),
    );
  }

  RectEX union(RectEX other) {
    return RectEX(
      decimalMin(left, other.left),
      decimalMin(top, other.top),
      decimalMax(right, other.right),
      decimalMax(bottom, other.bottom),
    );
  }

  bool contains(PointEX point) {
    return left <= point.x &&
        point.x < right &&
        top <= point.y &&
        point.y < bottom;
  }

  bool containsRect(RectEX other) {
    return left <= other.left &&
        right >= other.right &&
        top <= other.top &&
        bottom >= other.bottom;
  }

  bool intersects(RectEX other) {
    return left < other.right &&
        right > other.left &&
        top < other.bottom &&
        bottom > other.top;
  }

  bool overlaps(RectEX other) {
    return left < other.right &&
        right > other.left &&
        top < other.bottom &&
        bottom > other.top;
    // final thisLeft = left;
    // final thisRight = right;
    // final thisTop = top;
    // final thisBottom = bottom;
    //
    // final otherLeft = other.left;
    // final otherRight = other.right;
    // final otherTop = other.top;
    // final otherBottom = other.bottom;
    //
    // final xOverlap = !(thisLeft >= otherRight || otherLeft >= thisRight);
    // final yOverlap = !(thisTop >= otherBottom || otherTop >= thisBottom);
    //
    // return xOverlap && yOverlap;
  }
}
