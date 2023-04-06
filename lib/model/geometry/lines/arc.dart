import 'package:flutter/material.dart';
import 'package:vectorgraph/model/geometry/vectors/vector2d.dart';
import '../../../utils/num_utils.dart';
import '../points/point_ex.dart';
import '../rect/RectEX.dart';
import 'dart:math';
//圆弧基于椭圆,椭圆基于矩形,所以_rx和_ry分别就等于矩形的宽和高的一半(由于svg使用的是直径,所以从svg中获取的值需要除以2)
class Arc{

  @override
  String toString() {
    //输出全部参数,每个参数添加\r\n换行
    return 'Arc{\r\n'
        '_startPoint: $_startPoint,\r\n'
        '_rx: $_rx,\r\n'
        '_ry: $_ry,\r\n'
        '_rotationDegrees: $_rotationDegrees,\r\n'
        '_laf: $_laf,\r\n'
        '_sf: $_sf,\r\n'
        '_endPoint: $_endPoint,\r\n'
        '_rotationRadians: $_rotationRadians,\r\n'
        '_arcOwnEllipseBoundRect: $_arcOwnEllipseBoundRect,\r\n'
        '_startAngle: $_startAngle,\r\n'
        '_sweepAngle: $_sweepAngle,\r\n'
        '_valid: $_valid,\r\n'
        '}';
  }

  //region SVG和CANVAS共有的属性
  ///定义圆弧椭圆的两个半轴
  final Decimal _rx;
  final Decimal _ry;
  ///定义圆弧椭圆旋转角度,以角度为单位(xr%360)
  final Decimal _rotationDegrees;
  ///laf sf 由于符合两点间的圆弧有4条，laf 决定取大角弧（1）还是小角弧（0） ， sf决定取顺时针弧（1）还是逆时针弧线（0）；
  bool _laf;
  bool _sf;

  bool _valid;
  //endregion


  //region SVG弧线的特有属性
  ///定义弧线的起始点
  PointEX _startPoint;
  ///定义弧线的终点
  PointEX _endPoint;
  ///定义圆弧椭圆旋转角度,以弧度为单位(pi/180*角度)
  final Decimal _rotationRadians;
  //endregion

  //region CANVAS弧线特有的属性
  // ///位置,默认就是0起点,圆弧所在的矩形的中心的点
  // final PointEX _arcOwnRectPosition;
  ///圆弧所在的椭圆的内切矩形
  RectEX _arcOwnEllipseBoundRect;
  ///起始角
  Decimal _startAngle;
  ///扫描角
  Decimal _sweepAngle;
  //endregion

  ///构造函数
  // Arc(this._position, this._rx, this._ry, this._xr, this._laf, this._sf, this._endPoint){
  //   _bounds = RectEX.fromPoints(_position, _endPoint);
  // }
  ///使用svg的参数初始化一个弧线
  Arc.fromSVG(this._startPoint, this._rx,this._ry, this._rotationDegrees, this._laf, this._sf, this._endPoint)
  :
        _arcOwnEllipseBoundRect = RectEX.zero ,
        _startAngle = Decimal.zero,
        _sweepAngle = Decimal.zero,
        _rotationRadians = _rotationDegrees* decimalPerDegree,
        _valid = true
  {
    var canvasInfo = _getArcInfoBySvgParams(
      _startPoint.x.toDouble(),_startPoint.y.toDouble(),
      _rx.toDouble(),_ry.toDouble(),
        (_rotationDegrees * decimalPerDegree).toDouble(),
      _laf,_sf,
      _endPoint.x.toDouble(),
      _endPoint.y.toDouble(),
    );
    // return;
   if(!canvasInfo.valid)
      {
        _valid = false;
        return;
      }
    // print("是: ${_arcOwnEllipseBoundRect}, 起始角:${_startAngle} , 结束角度:${_sweepAngle}");
    _arcOwnEllipseBoundRect = RectEX.fromCenter(center: canvasInfo.rect.center.toPointEX(), width: _rx, height: _ry);
    _startAngle = canvasInfo.startAngle.toDecimal();
    _sweepAngle = canvasInfo.sweepAngle.toDecimal();
    
    // print("是: ${_arcOwnEllipseBoundRect.center}, 起始角:${_startAngle} , 结束角度:${_sweepAngle}");

    _calcBounds();
  }

  ///使用canvas的参数初始化一个弧线
  Arc.fromCanvas(this._arcOwnEllipseBoundRect, this._rotationRadians, this._startAngle, this._sweepAngle)
  :_startPoint = PointEX.zero,
        _endPoint = PointEX.zero,
        _laf = false,
        _sf = false,
        _rx=_arcOwnEllipseBoundRect.width/Decimal.two,
        _ry=_arcOwnEllipseBoundRect.height/Decimal.two,
        _rotationDegrees = _rotationRadians / decimalPerDegree,
        _valid = true
  {
    SvgArcInfo svg = fromCenterToEndpoint(
        _arcOwnEllipseBoundRect.center.x.toDouble(),
        _arcOwnEllipseBoundRect.center.y.toDouble(),
        _rx.toDouble(),
        _ry.toDouble(),
        _rotationRadians.toDouble(),
        _startAngle.toDouble(),
        _sweepAngle.toDouble()
    );
    _startPoint = svg.startPoint.toPointEX();
    _endPoint = svg.endPoint.toPointEX();
    // _startPoint = svg.startPoint.toPointEX();
    // _endPoint = svg.endPoint.toPointEX();
    _laf = svg.largeArcFlag;
    _sf = svg.sweepFlag;

    _calcBounds();
  }
  //region 获取旋转以后的bound
  void _calcBounds(){
    var newLeftTop = _arcOwnEllipseBoundRect.leftTop.toVector2D().rotateZ(_rotationRadians).toPointEX();
    var newRightTop = _arcOwnEllipseBoundRect.topRight.toVector2D().rotateZ(_rotationRadians).toPointEX();
    var newLeftBottom = _arcOwnEllipseBoundRect.bottomLeft.toVector2D().rotateZ(_rotationRadians).toPointEX();
    var newRightBottom = _arcOwnEllipseBoundRect.rightBottom.toVector2D().rotateZ(_rotationRadians).toPointEX();
    //新矩形包含上面的所有点,计算上下左右
    var newLeft = decimalMin(decimalMin(newLeftTop.x, newRightTop.x), decimalMin(newLeftBottom.x, newRightBottom.x));
    var newTop = decimalMin(decimalMin(newLeftTop.y, newRightTop.y), decimalMin(newLeftBottom.y, newRightBottom.y));
    var newRight = decimalMax(decimalMax(newLeftTop.x, newRightTop.x), decimalMax(newLeftBottom.x, newRightBottom.x));
    var newBottom = decimalMax(decimalMax(newLeftTop.y, newRightTop.y), decimalMax(newLeftBottom.y, newRightBottom.y));

    //得出_bounds
    _bounds = RectEX.fromLTRB(newLeft, newTop, newRight, newBottom);
    // print('新的bounds: $_bounds');
  }
  //endregion

  RectEX _bounds = RectEX.zero;
  PointEX get startPoint => _startPoint;
  RectEX get bounds => _bounds;
  PointEX get position => _arcOwnEllipseBoundRect.center;
  Decimal get rx => _rx;
  Decimal get ry => _ry;
  Decimal get rotationRadians => _rotationRadians;
  Decimal get rotationDegrees => _rotationDegrees;
  // Decimal get xr => _rotationRadians;
  bool get laf => _laf;
  bool get sf => _sf;
  PointEX get endPoint => _endPoint;
  Decimal get startAngle => _startAngle;
  Decimal get sweepAngle => _sweepAngle;

  //检查弧线是否有效.如果是给定的内切矩形和角度等参数中得不到起点到终点上的那条弧线,则表示为无效,前端应该绘制为一条起点到终点的直线.
  bool get valid => _valid;

  //region 自己写的,按照w3的标准.都没有问题了
  ///使用svg格式参数获取一个圆弧
  CanvasArcInfo _getArcInfoBySvgParams(
      double startX, double startY,
      double rx, double ry,
      double xAxisRotation,
      bool largeArcFlag,
      bool sweepFlag,
      endX, endY) {
    CanvasArcInfo ret = CanvasArcInfo();

    //region 1. Compute (x1′, y1′)
    var matrix1 = Matrix4.zero()
      ..setEntry(0, 0, cos(xAxisRotation))
      ..setEntry(0, 1, sin(xAxisRotation))
      ..setEntry(1, 0, -sin(xAxisRotation))
      ..setEntry(1, 1, cos(xAxisRotation));

    var matrix2 = Matrix4.zero()
      ..setEntry(0, 0, (startX - endX) / 2)
      ..setEntry(1, 0, (startY - endY) / 2);

    var matrixX1Y1 = matrix1.multiplied(matrix2);

    var x1_ = matrixX1Y1.entry(0, 0);
    var y1_ = matrixX1Y1.entry(1, 0);
    //endregion

    //region 2. Compute (cx′, cy′)
    var rx2 = pow(rx, 2); var ry2 = pow(ry, 2); var x1_2 = pow(x1_, 2); var y1_2 = pow(y1_, 2);

    var a = pow(rx, 2) * pow(ry, 2) - pow(rx, 2) * pow(y1_, 2) - pow(ry, 2) * pow(x1_, 2);
    var b = rx2 * y1_2 + ry2 * x1_2;

    double c = 0;
    if (largeArcFlag == sweepFlag) {
      c = -sqrt(a / b);
    } else {
      c = sqrt(a / b);
    }

    var d = rx*y1_;
    var e = d/ry;

    var f = ry*x1_;
    var g = -(f/rx);

    var cx_ = c * e;
    var cy_ = c * g;
    //endregion

    //region 3. Compute (cx, cy) from (cx′, cy′)
    var matrixStep3_1 = Matrix4.zero()
      ..setEntry(0, 0, cos(xAxisRotation))
      ..setEntry(0, 1, -sin(xAxisRotation))
      ..setEntry(1, 0, sin(xAxisRotation))
      ..setEntry(1, 1, cos(xAxisRotation));

    var matrixStep3_2 = Matrix4.zero()
      ..setEntry(0, 0, cx_)
      ..setEntry(1, 0, cy_);

    var matrixStep3 = matrixStep3_1.multiplied(matrixStep3_2);

    var cx = matrixStep3.entry(0, 0) + ((startX + endX) / 2);
    var cy = matrixStep3.entry(1, 0) + ((startY + endY) / 2);


    //valid check
    if(cx.isNaN || cy.isNaN){
      ret.valid = false;
      return ret;
    }
    ret.valid = true;
    ret.rect = Rect.fromCenter(center: Offset(cx, cy), width: rx*2, height: ry*2);
    //endregion

    //region 4. Compute θ1 and Δθ
    double ux = 1;
    double uy = 0;
    var vx = (x1_ - cx_) / rx;
    var vy = (y1_ - cy_) / ry;

    var theta1 = getAngle(ux,uy,vx,vy);

    double ux1 = (x1_ - cx_) / rx;
    double uy1 = (y1_ - cy_) / ry;

    double vx1 = (-x1_ - cx_) / rx;
    double vy1 = (-y1_ - cy_) / ry;

    var deltaTheta = getAngle(ux1,uy1,vx1,vy1);

    // where Δθ is fixed in the range −360° < Δθ < 360° such that:
    //
    // if fS = 0, then Δθ < 0,
    //
    // else if fS = 1, then Δθ > 0.
    if (sweepFlag && deltaTheta < 0) {
      deltaTheta += 2 * pi;
    } else if (!sweepFlag && deltaTheta > 0) {
      deltaTheta -= 2 * pi;
    }
    // In other words, if fS = 0 and the right side of (eq. 5.6) is greater than 0, then subtract 360°, whereas if fS = 1 and the right side of (eq. 5.6) is less than 0, then add 360°. In all other cases leave it as is.
    //endregion

    ret.startAngle = theta1;
    ret.sweepAngle = deltaTheta;

    return ret;
  }
  //已知两向量,求两向量夹角
  double getAngle(double ux, double uy, double vx, double vy)
  {
    double dot = ux * vx + uy * vy;
    double det = ux * vy - uy * vx;
    double angle = atan2(det, dot);
    return angle;
  }

  // 将角度转换为弧度
  double degreesToRadians(double deg) {
    return deg / 180 * pi;
  }

  // 将弧度转换为角度
  double radiansToDegrees(double rad) {
    return rad / pi * 180;
  }
  //endregion

  //Conversion from center to endpoint parameterization
  //https://www.w3.org/TR/SVG/implnote.html#ArcConversionEndpointToCenter
  SvgArcInfo fromCenterToEndpoint(
      double cx,
      double cy,
      double rx,
      double ry,
      double phi,
      double theta1,
      double deltaTheta){
    var cosPhi = cos(phi);
    var sinPhi = sin(phi);
    var cosTheta1 = cos(theta1);
    var sinTheta1 = sin(theta1);
    var matrix1 = Matrix4.zero()
      ..setEntry(0, 0, cosPhi)..setEntry(0, 1, -sinPhi)..setEntry(
          1, 0, sinPhi)..setEntry(1, 1, cosPhi);
    var matrix2 = Matrix4.zero()
      ..setEntry(0, 0, rx * cosTheta1)..setEntry(1, 0, ry * sinTheta1);
    var x1 = matrix1.multiplied(matrix2).entry(0, 0) + cx;
    var y1 = matrix1.multiplied(matrix2).entry(1, 0) + cy;

    var cosTheta1PlusDeltaTheta = cos(theta1 + deltaTheta);
    var sinTheta1PlusDeltaTheta = sin(theta1 + deltaTheta);
    var matrix3 = Matrix4.zero()
      ..setEntry(0, 0, cosPhi)..setEntry(0, 1, -sinPhi)..setEntry(
          1, 0, sinPhi)..setEntry(1, 1, cosPhi);
    var matrix4 = Matrix4.zero()
  ..setEntry(0, 0, rx * cosTheta1PlusDeltaTheta)..setEntry(
          1, 0, ry * sinTheta1PlusDeltaTheta);
    var x2 = matrix3.multiplied(matrix4).entry(0, 0) + cx;
    var y2 = matrix3.multiplied(matrix4).entry(1, 0) + cy;

    var fa = deltaTheta.abs() > pi ? true : false;
    var fs = deltaTheta > 0 ? true : false;
    var ret = SvgArcInfo();
    ret.startPoint = Offset(x1, y1);
    ret.endPoint = Offset(x2, y2);
    ret.largeArcFlag = fa;
    ret.sweepFlag = fs;
    return ret;
  }
  //region 备选方案

  //region 从canvas到svg的转换?
// /// <summary>
// /// OpenXml Arc 转为SVG Arc 字符串
// /// </summary>
// /// <param name="stringPath">路径字符串</param>
// /// <param name="wR">Emu椭圆半长轴</param>
// /// <param name="hR">Emu椭圆半短轴</param>
// /// <param name="stAng">Emu起始角</param>
// /// <param name="swAng">Emu摆动角</param>
// /// <param name="currentPoint">当前坐标</param>
// /// <returns></returns>
// String OpenXmlArcToArcStr(String stringPath, double wR, double hR, double stAng, double swAng, Point currentPoint)
// {
//   const String comma = ",";
//
//   //将Openxml的角度转为真实的角度
//   var fi1 = new Angle((int)stAng).ToRadiansValue();
// var Δθ = new Angle((int)swAng).ToRadiansValue();
// //旋转角
// var jia = 60d;
// //是否是大弧
// var isLargeArcFlag = Math.Abs(Δθ) > Math.PI;
// //是否是顺时针
// var isClockwise = Δθ > 0;
//
//
// //修复当椭圆弧线进行360°时，起始点和终点一样，会导致弧线变成点，因此-1°才进行计算
// if (System.Math.Abs(Δθ) == 2 * System.Math.PI)
// {
// Δθ = Δθ - Δθ / 360;
// }
//
//   var rx = new Emu(wR).ToPixel().Value;
//   var ry = new Emu(hR).ToPixel().Value;
//
//   //获取终点坐标
//   var pt = GetArcArbitraryPoint(rx, ry, Δθ, fi1, jia, currentPoint);
//
//   currentPoint = pt;
//
//   // 格式如下
//   // A rx ry x-axis-rotation large-arc-flag sweep-flag x y
//   // 这里 large-arc-flag 是 1 和 0 表示
//   stringPath.Append("A")
//       .Append(rx) //rx
//       .Append(comma)
//       .Append(ry) //ry
//       .Append(comma)
//       .Append(jia) // x-axis-rotation
//       .Append(comma)
//       .Append(isLargeArcFlag ? "1" : "0") //large-arc-flag
//     .Append(comma)
//       .Append(isClockwise ? "1" : "0") // sweep-flag
//     .Append(comma)
//     .Append(pt.X)
//     .Append(comma)
//       .Append(pt.Y)
//       .Append(' ');
// return stringPath.ToString();
//
// }
//
//
// /// <summary>
// /// OpenXml Arc 转为SVG Arc 字符串
// /// </summary>
// /// <param name="stringPath">路径字符串</param>
// /// <param name="rx">椭圆半长轴</param>
// /// <param name="ry">椭圆半短轴</param>
// /// <param name="jia">旋转角</param>
// /// <param name="stAng">起始角</param>
// /// <param name="swAng">摆动角</param>
// /// <param name="currentPoint">当前坐标</param>
// /// <returns></returns>
// private string SvgArcToArcStr(StringBuilder stringPath, double rx, double ry, double jia, double stAng, double swAng, Point currentPoint)
// {
// const string comma = ",";
//
// var fi1 = stAng / 180 * Math.PI;
// var Δθ = swAng / 180 * Math.PI;
// //是否是大弧
// var isLargeArcFlag = Math.Abs(Δθ) > Math.PI;
// //是否是顺时针
// var isClockwise = Δθ > 0;
//
//
// //修复当椭圆弧线进行360°时，起始点和终点一样，会导致弧线变成点，因此-1°才进行计算
// if (System.Math.Abs(Δθ) == 2 * System.Math.PI)
// {
// Δθ = Δθ - Δθ / 360;
// }
//
// //获取终点坐标
// var pt = GetArcArbitraryPoint(rx, ry, Δθ, fi1, jia, currentPoint);
//
// currentPoint = pt;
//
// // 格式如下
// // A rx ry x-axis-rotation large-arc-flag sweep-flag x y
// // 这里 large-arc-flag 是 1 和 0 表示
// stringPath.Append("A")
//     .Append(rx) //rx
//     .Append(comma)
//     .Append(ry) //ry
//     .Append(comma)
//     .Append(jia) // x-axis-rotation
//     .Append(comma)
//     .Append(isLargeArcFlag ? "1" : "0") //large-arc-flag
//     .Append(comma)
//     .Append(isClockwise ? "1" : "0") // sweep-flag
//     .Append(comma)
//     .Append(pt.X)
//     .Append(comma)
//     .Append(pt.Y)
//     .Append(' ');
// return stringPath.ToString();
//
// }
//
// /// <summary>
// /// 获取椭圆任意一点坐标(终点)
// /// </summary>
// /// <param name="rx">椭圆半长轴</param>
// /// <param name="ry">椭圆半短轴</param>
// /// <param name="Δθ">摆动角度(起始角的摆动角度，也就是起始角+摆动角=结束角)</param>
// /// <param name="fi1">起始角</param>
// /// <param name="jia">旋转角</param>
// /// <param name="currentPoint">起点</param>
// /// <returns></returns>
// private static Point GetArcArbitraryPoint(double rx, double ry, double Δθ, double fi1, double jia, Point currentPoint)
// {
// //开始点的椭圆任意一点的二维矩阵方程式
// var matrixX1Y1 = new Matrix { M11 = currentPoint.X, M21 = currentPoint.Y };
//
// var matrix1 = new Matrix { M11 = Math.Cos(jia), M12 = -Math.Sin(jia), M21 = Math.Sin(jia), M22 = Math.Cos(jia) };
// var matrix2 = new Matrix { M11 = rx * Math.Cos(fi1), M21 = ry * Math.Sin(fi1) };
// var multiplyMatrix1Matrix2 = Matrix.Multiply(matrix1, matrix2);
// var matrixCxCy = new Matrix { M11 = matrixX1Y1.M11 - multiplyMatrix1Matrix2.M11, M21 = matrixX1Y1.M21 - multiplyMatrix1Matrix2.M21 };
//
// //终点的椭圆任意一点的二维矩阵方程式
// var matrix3 = new Matrix { M11 = rx * Math.Cos(fi1 + Δθ), M21 = ry * Math.Sin(fi1 + Δθ) };
// var multiplyMatrix1Matrix3 = Matrix.Multiply(matrix1, matrix3);
// var matrixX2Y2 = new Matrix { M11 = multiplyMatrix1Matrix3.M11 + matrixCxCy.M11, M21 = multiplyMatrix1Matrix3.M21 + matrixCxCy.M21 };
//
// return new Point(matrixX2Y2.M11, matrixX2Y2.M21);
// }
//
// private void ButtonBase_OnClick(object sender, RoutedEventArgs e)
// {
// if (this.Path.Data is not null)
// {
// var pathGeometry = PathGeometry.CreateFromGeometry(this.Path.Data);
// var pathFigure = pathGeometry.Figures[0];
//
// if (pathFigure.Segments[0] is ArcSegment arcSegment)
// {
// var x1 = pathFigure.StartPoint.X;
// var y1 = pathFigure.StartPoint.Y;
// var rx = arcSegment.Size.Width;
// var ry = arcSegment.Size.Height;
// var jia = arcSegment.RotationAngle;
// var fA = arcSegment.IsLargeArc ? 1 : 0;
// var fs = arcSegment.SweepDirection is SweepDirection.Clockwise ? 1 : 0;
// var x2 = arcSegment.Point.X;
// var y2 = arcSegment.Point.Y;
//
//
// var (startAngle, swAngle) = GetArcStartAngAndSwAng(x1, y1, x2, y2, fA, fs, rx, ry, jia);
// var arcCenterPoint = GetArcCenterPoint(x1, y1, x2, y2, fA, fs, rx, ry, jia);
// StringBuilder stringPath = new StringBuilder();
// stringPath.Append($"M {x1} {y1}");
// var openXmlArcToArcStrNew = SvgArcToArcStr(stringPath, rx, ry, jia, startAngle, swAngle, pathFigure.StartPoint);
// this.NewPath.Data = Geometry.Parse(openXmlArcToArcStrNew);
// }
//
// }
// }
  //endregion
  // //从这个网站的代码改编的
  // //https://blog.csdn.net/xiaozhu2hao/article/details/49097417?locationNum=3
  // //角度和旋转但是好像计算的并不准呢,但是这个能匹配到两个中心点的
  // Arc2D computeArc(double x0, double y0,
  //     double rx, double ry,
  //     double angle,
  //     bool largeArcFlag,
  //     bool sweepFlag,
  //     double x, double y) {
  //   //
  //   // Elliptical arc implementation based on the SVG specification notes
  //   //
  //
  //   // Compute the half distance between the current and the final point
  //   double dx2 = (x0 - x) / 2.0;
  //   double dy2 = (y0 - y) / 2.0;
  //   // Convert angle from degrees to radians
  //   angle = degreesToRadians(angle % 360.0);
  //   double cosAngle = cos(angle);
  //   double sinAngle = sin(angle);
  //
  //   //
  //   // Step 1 : Compute (x1, y1)
  //   //
  //   double x1 = (cosAngle * dx2 + sinAngle * dy2);
  //   double y1 = (-sinAngle * dx2 + cosAngle * dy2);
  //   // Ensure radii are large enough
  //   rx = rx.abs();
  //   ry = ry.abs();
  //   double Prx = rx * rx;
  //   double Pry = ry * ry;
  //   double Px1 = x1 * x1;
  //   double Py1 = y1 * y1;
  //   // check that radii are large enough
  //   double radiiCheck = Px1/Prx + Py1/Pry;
  //   if (radiiCheck > 1) {
  //     rx = sqrt(radiiCheck) * rx;
  //     ry = sqrt(radiiCheck) * ry;
  //     Prx = rx * rx;
  //     Pry = ry * ry;
  //   }
  //
  //   //
  //   // Step 2 : Compute (cx1, cy1)
  //   //
  //   double sign = (largeArcFlag == sweepFlag) ? -1 : 1;
  //   double sq = ((Prx*Pry)-(Prx*Py1)-(Pry*Px1)) / ((Prx*Py1)+(Pry*Px1));
  //   sq = (sq < 0) ? 0 : sq;
  //   double coef = (sign * sqrt(sq));
  //   double cx1 = coef * ((rx * y1) / ry);
  //   double cy1 = coef * -((ry * x1) / rx);
  //
  //   //
  //   // Step 3 : Compute (cx, cy) from (cx1, cy1)
  //   //
  //   double sx2 = (x0 + x) / 2.0;
  //   double sy2 = (y0 + y) / 2.0;
  //   double cx = sx2 + (cosAngle * cx1 - sinAngle * cy1);
  //   double cy = sy2 + (sinAngle * cx1 + cosAngle * cy1);
  //
  //   //
  //   // Step 4 : Compute the angleStart (angle1) and the angleExtent (dangle)
  //   //
  //   double ux = (x1 - cx1) / rx;
  //   double uy = (y1 - cy1) / ry;
  //   double vx = (-x1 - cx1) / rx;
  //   double vy = (-y1 - cy1) / ry;
  //   double p, n;
  //   // Compute the angle start
  //   n = sqrt((ux * ux) + (uy * uy));
  //   p = ux; // (1 * ux) + (0 * uy)
  //   sign = (uy < 0) ? -1.0 : 1.0;
  //   double angleStart = radiansToDegrees(sign * acos(p / n));
  //
  //   // Compute the angle extent
  //   n = sqrt((ux * ux + uy * uy) * (vx * vx + vy * vy));
  //   p = ux * vx + uy * vy;
  //   sign = (ux * vy - uy * vx < 0) ? -1.0 : 1.0;
  //   double angleExtent = radiansToDegrees(sign * acos(p / n));
  //   if(!sweepFlag && angleExtent > 0) {
  //     angleExtent -= 360;
  //   } else if (sweepFlag && angleExtent < 0) {
  //     angleExtent += 360;
  //   }
  //   angleExtent %= 360;
  //   angleStart %= 360;
  //
  //   //
  //   // We can now build the resulting Arc2D in double precision
  //   //
  //   Arc2D arc = Arc2D();
  //   arc.x = cx - rx;
  //   arc.y = cy - ry;
  //   arc.width = rx * 2.0;
  //   arc.height = ry * 2.0;
  //   // arc.start = -angleStart;
  //   // arc.extent = -angleExtent;
  //   arc.start = degreesToRadians(angleStart);
  //   arc.extent = degreesToRadians(angleExtent);
  //
  //   return arc;
  // }
  //
  //
  // /**
  //     Perform the endpoint to center arc parameter conversion as detailed in the SVG 1.1 spec.
  //     F.6.5 Conversion from endpoint to center parameterization
  //
  //     @param r must be a ref in case it needs to be scaled up, as per the SVG spec
  //  */
  //
  // //从这个网站获取来的代码进行的改编https://mortoray.com/rendering-an-svg-elliptical-arc-as-bezier-curves/
  // // 跟自己写的那个抄写w3的结果一样,但是他可能对Nan这样的数处理的好一点
  // DecimalArc2D endpointToCenterArcParams( PointEX p1, PointEX p2,
  //     Vector2D r_,
  // // ref float2 r_,
  // Decimal xAngle,
  // bool flagA, bool flagS,
  // // out float2 c,
  // // out float2 angles
  // )
  // {
  //   // Vector2D r_ = Vector2D.zero;
  //   Vector2D c = Vector2D.zero;
  //   Vector2D angles = Vector2D.zero;
  //   Decimal rX = r_.x.abs();
  //   Decimal rY = r_.y.abs();
  //
  //   // print('p1:$p1 p2:$p2 rX:$rX rY:$rY xAngle:$xAngle flagA:$flagA flagS:$flagS');
  //
  // //(F.6.5.1)
  // Decimal dx2 = (p1.x - p2.x) / Decimal.two;
  //   Decimal dy2 = (p1.y - p2.y) / Decimal.two;
  //   Decimal x1p = decimalCos(xAngle)*dx2 + decimalSin(xAngle)*dy2;
  //   Decimal y1p = -decimalSin(xAngle)*dx2 + decimalCos(xAngle)*dy2;
  //
  //   // print('dx2:$dx2 dy2:$dy2 x1p:$x1p y1p:$y1p');
  //
  // //(F.6.5.2)
  //   Decimal rxs = rX * rX;
  //   Decimal rys = rY * rY;
  //   Decimal x1ps = x1p * x1p;
  //   Decimal y1ps = y1p * y1p;
  //   // print("rxs:$rxs rys:$rys x1ps:$x1ps y1ps:$y1ps");
  // // check if the radius is too small `pq < 0`, when `dq > rxs * rys` (see below)
  // // cr is the ratio (dq : rxs * rys)
  //   Decimal cr = x1ps/rxs + y1ps/rys;
  // if (cr > Decimal.one) {
  // //scale up rX,rY equally so cr == 1
  // var s = decimalSqrt(cr);
  // rX = s * rX;
  // rY = s * rY;
  // rxs = rX * rX;
  // rys = rY * rY;
  // }
  //   Decimal dq = (rxs * y1ps + rys * x1ps);
  //   Decimal pq = (rxs*rys - dq) / dq;
  //   Decimal q = decimalSqrt( decimalMax(Decimal.zero,pq) ); //use Max to account for float precision
  //   // print("cr:$cr dq:$dq pq:$pq q:$q");
  // if (flagA == flagS)
  // q = -q;
  //   Decimal cxp = q * rX * y1p / rY;
  //   Decimal cyp = - q * rY * x1p / rX;
  //
  // //(F.6.5.3)
  //   Decimal cx = decimalCos(xAngle)*cxp - decimalSin(xAngle)*cyp + (p1.x + p2.x)/Decimal.two;
  //   Decimal cy = decimalSin(xAngle)*cxp + decimalCos(xAngle)*cyp + (p1.y + p2.y)/Decimal.two;
  //
  // //(F.6.5.5)
  //   Decimal theta = svgAngle( Decimal.one,Decimal.zero, (x1p-cxp) / rX, (y1p - cyp)/rY );
  // //(F.6.5.6)
  //   Decimal delta = svgAngle(
  // (x1p - cxp)/rX, (y1p - cyp)/rY,
  // (-x1p - cxp)/rX, (-y1p-cyp)/rY);
  // delta = delta.mod(decimalPi * Decimal.two);
  // if (!flagS)
  // delta -= Decimal.two * decimalPi;
  //
  // r_ = Vector2D(rX,rY);
  // c = Vector2D(cx,cy);
  // angles = Vector2D(theta, delta);
  //   DecimalArc2D ret = DecimalArc2D();
  //   ret.x = c.x;
  //   ret.y = c.y;
  //   ret.start = angles.x;
  //   ret.extent= angles.y;
  //   return ret;
  // }
  //
  // Decimal svgAngle( Decimal ux, Decimal uy, Decimal vx, Decimal vy )
  // {
  //   // print('ux:$ux, uy:$uy, vx:$vx, vy:$vy');
  // var u = Vector2D(ux, uy);
  // var v = Vector2D(vx, vy);
  // //(F.6.5.4)
  // var dot = u.dot(v);
  // var len = u.length * v.length;
  // var ang = decimalACos( decimalClamp(dot / len,Decimal.fromInt(-1),Decimal.one)); //floating point precision, slightly over values appear
  // if ( (u.x*v.y - u.y*v.x) < Decimal.zero) {
  //   ang = -ang;
  // }
  // return ang;
  // }
  //
  //
  // //从这个网站获取到的,https://gist.github.com/balint42/fdb1d7d2e16fe11ac785
  // //0度时,计算的圆心,起始角都正确,扫描角貌似不正确,代码是:
  // //   /**
  // //    * @brief convSvgEllipseParams calculates the center point and the start angle
  // //    * and end angle of an ellipse from the obscure SVG parameters of an
  // //    * elliptic arc. It returns an array with two points, the center
  // //    * point and a point with the start and end angles.
  // //    * The term "point" means a JS object { x:number1, y:number2 }
  // //    *
  // //    * @author Balint Morvai <balint@morvai.de>
  // //    * @license http://en.wikipedia.org/wiki/MIT_License MIT License
  // //    * @param ps starting point
  // //    * @param pe end point
  // //    * @param rh horizontal radius
  // //    * @param rv vertical radius
  // //    * @param rot rotation in degree
  // //    * @param fa large arc flag
  // //    * @param fs sweep flag
  // //    * @return array
  // //    */
  // //   var convSvgEllipseParams = function(ps, pe, rh, rv, rot, fa, fs) {
  // //   // function for calculating angle between two vectors
  // //   var angle = function(u, v) {
  // //   var sign = ((u.x * v.y - u.y * v.x) > 0) ? 1 : -1;
  // //   return sign * Math.acos(
  // //   (u.x * v.x + u.y * v.y) /
  // //   (Math.sqrt(u.x*u.x + u.y*u.y) * Math.sqrt(u.x*u.x + u.y*u.y))
  // //   );
  // // }
  // // // sanitize input
  // // rot = rot % 360;
  // // rh = Math.abs(rh);
  // // rv = Math.abs(rv);
  // // // do calculation
  // // var cosRot = Math.cos(rot);
  // // var sinRot = Math.sin(rot);
  // // var x = cosRot * (ps.x - pe.x) / 2 + sinRot * (ps.y - pe.y) / 2;
  // // var y = -1 * sinRot * (ps.x - pe.x) / 2 + cosRot * (ps.y - pe.y) / 2;
  // // var rh2 = rh * rh; var rv2 = rv * rv; var x2 = x * x; var y2 = y * y;
  // // var fr = ((fa == fs) ? -1 : 1) * Math.sqrt(
  // // (rh2 * (rv2 - y2) - rv2 * x2) /
  // // (rh2 * y2 + rv2 * x2)
  // // );
  // // var xt = fr * rh * y / rv;
  // // var yt = -1 * fr * rv * x / rh;
  // // var cx = cosRot * xt - sinRot * yt + (ps.x + pe.x) / 2;
  // // var cy = sinRot * xt + cosRot * yt + (ps.y + pe.y) / 2;
  // // var vt = { x:(x-xt)/rh, y:(y-yt)/rv };
  // // var phi1 = angle({ x:1, y:0 }, vt);
  // // var phiD = angle(vt, { x:(-x-xt)/rh, y:(-y-yt)/rv }) % 360;
  // // var phi2 = phi1 + phiD;
  // //
  // // return [{ x:cx, y:cy }, { x:phi1, y:phi2 }];
  // // }

  //endregion
}
// class DecimalArc2D{
//   Decimal x = Decimal.zero;
//   Decimal y = Decimal.zero;
//   Decimal width = Decimal.zero;
//   Decimal height = Decimal.zero;
//   Decimal start = Decimal.zero;
//   Decimal extent = Decimal.zero;
//   @override
//   String toString() {
//     return "DecimalArc2D ::: x:$x, y$y, width:$width, height:$height, start$start, sweep:$extent";
//   }
// }
// class Arc2D{
//   late double x;
//   late double y;
//   late double width;
//   late double height;
//   late double start;
//   late double extent;
//   @override
//   String toString() {
//     return "Arc2d ::: x:$x, y$y, width:$width, height:$height, start$start, sweep:$extent";
//   }
// }



class CanvasArcInfo{
  late Rect rect;
  late double startAngle;
  late double sweepAngle;
  late bool valid;
  @override
  toString() {
    return 'Rect: $rect, 起始角度: $startAngle, 旋转角: $sweepAngle';
  }
}

class SvgArcInfo{
  late Offset startPoint;
  late Offset endPoint;
  late bool largeArcFlag;
  late bool sweepFlag;
}





