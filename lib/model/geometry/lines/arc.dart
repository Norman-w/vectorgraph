import 'package:flutter/material.dart';
import 'package:vectorgraph/model/geometry/vectors/vector2d.dart';

import '../../../utils/num_utils.dart';
import '../points/point_ex.dart';
import '../rect/RectEX.dart';
import 'dart:math';
//圆弧基于椭圆,椭圆基于矩形,所以_rx和_ry分别就等于矩形的宽和高的一半(由于svg使用的是直径,所以从svg中获取的值需要除以2)
class Arc{
  ///位置,默认就是0起点
  final PointEX _position;

  ///定义圆弧椭圆的两个半轴
  final Decimal _rx;
  final Decimal _ry;
  ///定义圆弧椭圆旋转角度
  final Decimal _xr;
  ///laf sf 由于符合两点间的圆弧有4条，laf 决定取大角弧（1）还是小角弧（0） ， sf决定取顺时针弧（1）还是逆时针弧线（0）；
  final bool _laf;
  final bool _sf;
  ///定义弧线的终点
  final PointEX _endPoint;
  ///构造函数
  Arc(this._position, this._rx, this._ry, this._xr, this._laf, this._sf, this._endPoint){
    _bounds = RectEX.fromPoints(_position, _endPoint);
  }

  RectEX _bounds = RectEX.zero;
  RectEX get bounds => _bounds;
  PointEX get position => _position;
  Decimal get rx => _rx;
  Decimal get ry => _ry;
  Decimal get xr => _xr;
  bool get laf => _laf;
  bool get sf => _sf;
  PointEX get endPoint => _endPoint;






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


  ArcInfo getArcInfoBySvgParams(
      double startX, double startY,
      double rx, double ry,
      double xAxisRotation,
      bool largeArcFlag,
      bool sweepFlag,
      endX, endY) {
    ArcInfo ret = ArcInfo();

    var x1=startX;
    var y1=startY;
    var x2=endX;
    var y2=endY;
    var fA = largeArcFlag;
    var fs = sweepFlag;

    //region 1. Compute (x1′, y1′)
    var matrix1 = Matrix4.zero()
      ..setEntry(0, 0, cos(xAxisRotation))
      ..setEntry(0, 1, sin(xAxisRotation))
      ..setEntry(1, 0, -sin(xAxisRotation))
      ..setEntry(1, 1, cos(xAxisRotation));

    var matrix2 = Matrix4.zero()
      ..setEntry(0, 0, (x1 - x2) / 2)
      ..setEntry(1, 0, (y1 - y2) / 2);

    var matrixX1Y1 = matrix1.multiplied(matrix2);

    var x1_ = matrixX1Y1.entry(0, 0);
    var y1_ = matrixX1Y1.entry(1, 0);
    //endregion

    //region 2. Compute (cx′, cy′)
    var rx2 = pow(rx, 2); var ry2 = pow(ry, 2); var x1_2 = pow(x1_, 2); var y1_2 = pow(y1_, 2);

    var a = pow(rx, 2) * pow(ry, 2) - pow(rx, 2) * pow(y1_, 2) - pow(ry, 2) * pow(x1_, 2);
    var b = rx2 * y1_2 + ry2 * x1_2;

    double c = 0;
    if (fA == fs) {
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

    var cx = matrixStep3.entry(0, 0) + ((x1 + x2) / 2);
    var cy = matrixStep3.entry(1, 0) + ((y1 + y2) / 2);


    ret.centerPoint = Offset(cx, cy);
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
    if (fs && deltaTheta < 0) {
      deltaTheta += 2 * pi;
    } else if (!fs && deltaTheta > 0) {
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
}



class ArcInfo{
  late Offset centerPoint;
  late double startAngle;
  late double sweepAngle;
  @override
  toString() {
    return '中心点: $centerPoint, 起始角度: $startAngle, 旋转角: $sweepAngle';
  }
}





