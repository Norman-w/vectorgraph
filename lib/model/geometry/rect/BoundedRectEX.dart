/*
圆角矩形,由四个弧线和四条直线组成的圆角矩形
目前只使用固定半径的四分之一圆来作为圆角,如果需要更复杂的圆角,后续可以考虑为各个圆角分别设置x,y半径
* */


import '../../../utils/num_utils.dart';
import 'RectEX.dart';

class BoundedRectEX extends RectEX {
  //region 字段
  Decimal leftTopRadius;
  Decimal rightTopRadius;
  Decimal leftBottomRadius;
  Decimal rightBottomRadius;
  Decimal? commonRadius;
  //endregion

  //region 属性
  ///获取边缘的弧度,如果没有弧度,或者四个弧度不一样,则返回null
  Decimal? get radius => commonRadius;
  set radius(Decimal? value) {
    if (value == null) {
      commonRadius = null;
      return;
    }
    if (value <= Decimal.zero) {
      throw Exception('radius must be positive');
    }
    commonRadius = value;
  }
  //endregion

  //region 构造函数
  ///构造函数,给定矩形的左上角坐标,宽度,高度,以及四个角的弧度
  BoundedRectEX.fromLTWHEachRadius(
      Decimal left,
      Decimal top,
      Decimal width,
      Decimal height,
      this.leftTopRadius,
      this.rightTopRadius,
      this.leftBottomRadius,
      this.rightBottomRadius)
      : super.fromLTWH(left, top, width, height);

  ///构造函数,给定矩形的左上角坐标,宽度,高度,以及四个角的统一弧度
  BoundedRectEX.fromLTWHRadius(
      Decimal left,
      Decimal top,
      Decimal width,
      Decimal height,
      Decimal radius)
      : leftBottomRadius = radius,
        leftTopRadius = radius,
        rightBottomRadius = radius,
        rightTopRadius = radius,
        super.fromLTWH(left, top, width, height);
  ///构造函数,给定矩形的左上角坐标,宽度,高度,不设置弧度,构造完以后可以使用..radius = xxx来设置弧度
  BoundedRectEX.fromLTWH(
      Decimal left,
      Decimal top,
      Decimal width,
      Decimal height)
      : leftBottomRadius = Decimal.zero,
        leftTopRadius = Decimal.zero,
        rightBottomRadius = Decimal.zero,
        rightTopRadius = Decimal.zero,
        super.fromLTWH(left, top, width, height);
  //endregion
}

