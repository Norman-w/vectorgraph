import 'dart:ui';

import '../../../utils/num_utils.dart';
import '../points/point_ex.dart';

class RectEX {
  Decimal left;
  Decimal top;
  Decimal right;
  Decimal bottom;
  Rect toRect() {
    return Rect.fromLTRB(left.toDouble(), top.toDouble(), right.toDouble(), bottom.toDouble());
  }

  static final zero = RectEX.fromLTWH(Decimal.zero, Decimal.zero, Decimal.zero, Decimal.zero);


  RectEX.fromCenter({required PointEX center, required Decimal width, required Decimal height})
      : left = center.x - width / decimal2,
        top = center.y - height / decimal2, bottom = center.y + height / decimal2,
        right = center.x + width / decimal2
  ;
  RectEX.fromCircle({required PointEX center, required Decimal radius})
      : left = center.x - radius,
        top = center.y - radius,
        right = center.x + radius,
        bottom = center.y + radius;


  Decimal get centerX => left + (right - left) / decimal2;
  Decimal get centerY => top + (bottom - top) / decimal2;

  PointEX get center => PointEX(centerX, centerY);

  RectEX(this.left, this.top, this.right, this.bottom);

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

  Decimal get width => right - left;
  Decimal get height => bottom - top;

  set width(Decimal value) => right = left + value;
  set height(Decimal value) => bottom = top + value;

  set leftTop(PointEX value) {
    left = value.x;
    top = value.y;
  }

  PointEX get leftTop => PointEX(left, top);

  set rightBottom(PointEX value) {
    right = value.x;
    bottom = value.y;
  }

  PointEX get rightBottom => PointEX(right, bottom);

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
  RectEX.fromLTRB(
      Decimal left,
      Decimal top,
      Decimal right,
      Decimal bottom,
      ) : this(left, top, right, bottom);
}
extension RectEXFunctions on RectEX {
  bool overlaps(RectEX other) {
    final thisLeft = left;
    final thisRight = right;
    final thisTop = top;
    final thisBottom = bottom;

    final otherLeft = other.left;
    final otherRight = other.right;
    final otherTop = other.top;
    final otherBottom = other.bottom;

    final xOverlap = !(thisLeft >= otherRight || otherLeft >= thisRight);
    final yOverlap = !(thisTop >= otherBottom || otherTop >= thisBottom);

    return xOverlap && yOverlap;
  }
}
