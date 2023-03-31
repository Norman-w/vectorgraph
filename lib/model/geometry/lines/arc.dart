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






  // MainWindow()
  // {
  //   // //OpenXml的360° circle
  //   // const double c = 21600000d;
  //   //
  //   // //<arcTo wR="152403" hR="152403" stAng="cd4" swAng="-5400000" />
  //   // var wR = 172403;
  //   // var hR = 152403;
  //   // var stAng = c / 2;
  //   // var swAng = -c / 3;
  //   //
  //   //
  //   // StringBuilder stringPath = new StringBuilder();
  //   // var currentPoint = new Point(0, 0);
  //   // stringPath.Append($"M {currentPoint.X} {currentPoint.Y}");
  //   //
  //   // var arcStr = OpenXmlArcToArcStr(stringPath, wR, hR, stAng, swAng, currentPoint);
  //   // this.Path.Data = Geometry.Parse(arcStr);
  // }

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

  // /// <summary>
  // /// 获取弧线的开始角度和摆动角度
  // /// </summary>
  // /// <param name="x1">起点X</param>
  // /// <param name="y1">起点Y</param>
  // /// <param name="x2">终点X</param>
  // /// <param name="y2">终点Y</param>
  // /// <param name="fA">优劣弧:1 优弧  0劣弧</param>
  // /// <param name="fs">顺逆时针绘制：1 顺时针  0 逆时针</param>
  // /// <param name="rx">椭圆半长轴</param>
  // /// <param name="ry">椭圆半短轴</param>
  // /// <param name="jia">旋转角</param>
  // /// <returns></returns>
  // static
  //  (double startAngle, double swAngle)
  // GetArcStartAngAndSwAng(double x1, double y1, double x2, double y2, double fA, double fs, double rx, double ry, double jia)
  // {
  // var matrix1 = new Matrix { M11 = Math.Cos(jia), M12 = Math.Sin(jia), M21 = -Math.Sin(jia), M22 = Math.Cos(jia) };
  // var matrix2 = new Matrix { M11 = (x1 - x2) / 2, M21 = (y1 - y2) / 2 };
  // var matrixX1Y1 = Matrix.Multiply(matrix1, matrix2);
  //
  // var x1_ = matrixX1Y1.M11;
  // var y1_ = matrixX1Y1.M21;
  //
  // var a = Math.Pow(rx, 2) * Math.Pow(ry, 2) - Math.Pow(rx, 2) * Math.Pow(y1_, 2) - Math.Pow(ry, 2) * Math.Pow(x1_, 2);
  // var b = Math.Pow(ry, 2) * Math.Pow(y1_, 2) + Math.Pow(ry, 2) * Math.Pow(x1_, 2);
  //
  // double c = 0;
  // if (fA == fs)
  // {
  // c = -Math.Sqrt(a / b);
  // }
  // else
  // {
  // c = Math.Sqrt(a / b);
  // }
  //
  // var matrixCxCy = new Matrix { M11 = c * (rx * y1_ / ry), M21 = c * (-ry * x1_ / rx) };
  //
  // var cx_ = matrixCxCy.M11;
  // var cy_ = matrixCxCy.M21;
  //
  //
  // //求开始角
  // //cos<夹角> = 两向量之积 / 两向量模的乘积
  // //< 夹角 > = arcCos(两向量之积 / 两向量模的乘积)
  //
  // //向量U的坐标
  // double vectorUx = 1;
  // double vectorUy = 0;
  //
  // //向量V的坐标
  // double vectorVx = (x1_ - cx_) / rx;
  // double vectorVy = (y1_ - cy_) / ry;
  //
  //
  // var multiVectorUVectorV = vectorUx * vectorVx + vectorUy * vectorVy; //两向量的乘积
  // var vectorUMod = Math.Sqrt(vectorUx * vectorUx + vectorUy * vectorUy);//向量U的模
  // var vectorVMod = Math.Sqrt(vectorVx * vectorVx + vectorVy * vectorVy);//向量V的模
  // var cosResult = multiVectorUVectorV / (vectorUMod * vectorVMod);
  //
  // var startAngle = Math.Acos(cosResult) * 180 / Math.PI;
  //
  //
  // //求摆动角
  // //cos<夹角> = 两向量之积 / 两向量模的乘积
  // //< 夹角 > = arcCos(两向量之积 / 两向量模的乘积)
  //
  // //向量U的坐标
  // vectorUx = (x1_ - cx_) / rx;
  // vectorUy = (y1_ - cy_) / ry;
  //
  // //向量V的坐标
  // vectorVx = (-x1_ - cx_) / rx;
  // vectorVy = (-y1_ - cy_) / ry;
  //
  // multiVectorUVectorV = vectorUx * vectorVx + vectorUy * vectorVy; //两向量的乘积
  // vectorUMod = Math.Sqrt(vectorUx * vectorUx + vectorUy * vectorUy);//向量U的模
  // vectorVMod = Math.Sqrt(vectorVx * vectorVx + vectorVy * vectorVy);//向量V的模
  // cosResult = multiVectorUVectorV / (vectorUMod * vectorVMod);
  //
  // var swAngle = Math.Acos(cosResult) * 180 / Math.PI;
  //
  // if (fs == 0)
  // {
  // swAngle = -swAngle;
  // }
  // else
  // {
  // swAngle = Math.Abs(swAngle);
  // }
  //
  //
  // return (startAngle, swAngle);
  //
  // }

  // /// 获取弧线的开始角度和摆动角度
  // /// 起点X
  // /// 起点Y
  // /// 终点X
  // /// 终点Y
  // /// 优劣弧:1 优弧  0劣弧
  // /// 顺逆时针绘制：1 顺时针  0 逆时针
  // /// 椭圆半长轴
  // /// 椭圆半短轴
  // /// 旋转角
  // ArcInfo getArcStartAngAndSwAng(
  //     double startX,
  //     double startY,
  //     double endX,
  //     double endY,
  //     ///优弧
  //     bool fA,
  //     //顺时针
  //     bool fs,
  //     double rx,
  //     double ry,
  //     double jia) {
  //   var matrix1 = Matrix4.zero()
  //       ..setEntry(0, 0, cos(jia))
  //       ..setEntry(0, 1, sin(jia))
  //       ..setEntry(1, 0, -sin(jia))
  //       ..setEntry(1, 1, cos(jia));
  //   var matrix2 = Matrix4.zero()
  //       ..setEntry(0, 0, (startX - endX) / 2)
  //       ..setEntry(1, 0, (startY - endY) / 2);
  //
  //   var matrixX1Y1 = matrix1 * matrix2;
  //
  //   var x1_ = matrixX1Y1.entry(0, 0);
  //   var y1_ = matrixX1Y1.entry(1, 0);
  //
  //   var a = pow(rx, 2) * pow(ry, 2) - pow(rx, 2) * pow(y1_, 2) - pow(ry, 2) * pow(x1_, 2);
  //   var b = pow(ry, 2) * pow(y1_, 2) + pow(ry, 2) * pow(x1_, 2);
  //
  //   double c = 0;
  //   if (fA == fs) {
  //     c = -sqrt(a / b);
  //   } else {
  //     c = sqrt(a / b);
  //   }
  //
  //   var matrixCxCy = Matrix4.zero()
  //       ..setEntry(0, 0, c * (rx * y1_ / ry))
  //       ..setEntry(1, 0, c * (-ry * x1_ / rx));
  //
  //   var cx_ = matrixCxCy.entry(0, 0);
  //   var cy_ = matrixCxCy.entry(1, 0);
  //
  //   //求开始角
  //   //cos<夹角> = 两向量之积 / 两向量模的乘积
  //   //< 夹角 > = arcCos(两向量之积 / 两向量模的乘积)
  //
  //   //向量U的坐标
  //   double vectorUx = 1;
  //   double vectorUy = 0;
  //
  //   //向量V的坐标
  //   double vectorVx = (x1_ - cx_) / rx;
  //   double vectorVy = (y1_ - cy_) / ry;
  //
  //   var multiVectorUVectorV = vectorUx * vectorVx + vectorUy * vectorVy; //两向量的乘积
  //   var vectorUMod = sqrt(vectorUx * vectorUx + vectorUy * vectorUy);//向量U的模
  //   var vectorVMod = sqrt(vectorVx * vectorVx + vectorVy * vectorVy);//向量V的模
  //   var cosResult = multiVectorUVectorV / (vectorUMod * vectorVMod);
  //
  //   var startAngle = acos(cosResult) * 180 / pi;
  //
  //   //求摆动角
  //   //cos<夹角> = 两向量之积 / 两向量模的乘积
  //   //< 夹角 > = arcCos(两向量之积 / 两向量模的乘积)
  //
  //   //向量U的坐标
  //   vectorUx = (x1_ - cx_) / rx;
  //   vectorUy = (y1_ - cy_) / ry;
  //
  //   //向量V的坐标
  //   vectorVx = (-x1_ - cx_) / rx;
  //   vectorVy = (-y1_ - cy_) / ry;
  //
  //   multiVectorUVectorV = vectorUx * vectorVx + vectorUy * vectorVy; //两向量的乘积
  //   vectorUMod = sqrt(vectorUx * vectorUx + vectorUy * vectorUy);//向量U的模
  //   vectorVMod = sqrt(vectorVx * vectorVx + vectorVy * vectorVy);//向量V的模
  //   cosResult = multiVectorUVectorV / (vectorUMod * vectorVMod);
  //
  //   var swAngle = acos(cosResult) * 180 / pi;
  //
  //   if (fs == 0) {
  //     swAngle = -swAngle;
  //   } else {
  //     swAngle = swAngle.abs();
  //   }
  //
  //
  //   //region 圆心计算
  //   var matrixCx_Cy_ = Matrix4.zero()
  //     ..setEntry(0, 0, c * (rx * y1_ / ry))
  //     ..setEntry(1, 0, c * (-ry * x1_ / rx));
  //
  //   var tempMatrix = Matrix4.zero()
  //     ..setEntry(0, 0, cos(jia))
  //     ..setEntry(0, 1, -sin(jia))
  //     ..setEntry(1, 0, sin(jia))
  //     ..setEntry(1, 1, cos(jia));
  //
  //   var multiplyMatrix = tempMatrix.multiplied(matrixCx_Cy_);
  //
  //   var matrixCxCy2 = Matrix4.zero()
  //     ..setEntry(0, 0, multiplyMatrix.entry(0, 0) + ((startX + endX) / 2))
  //     ..setEntry(1, 0, multiplyMatrix.entry(1, 0) + ((startY + endY) / 2));
  //
  //
  //   //endregion
  //   var ret = ArcInfo();
  //   ret.centerPoint = Offset(matrixCxCy2.entry(0, 0), matrixCxCy2.entry(1, 0));
  //   ret.startAngle = startAngle;
  //   ret.sweepAngle = swAngle;
  //   return ret;
  //   // return [startAngle, swAngle];
  // }



  // /// <summary>
  // /// 获取弧线的椭圆圆心
  // /// </summary>
  // /// <param name="x1">起点X</param>
  // /// <param name="y1">起点Y</param>
  // /// <param name="x2">终点X</param>
  // /// <param name="y2">终点Y</param>
  // /// <param name="fA">优劣弧:1 优弧  0劣弧</param>
  // /// <param name="fs">顺逆时针绘制：1 顺时针  0 逆时针</param>
  // /// <param name="rx">椭圆半长轴</param>
  // /// <param name="ry">椭圆半短轴</param>
  // /// <param name="jia">旋转角</param>
  // /// <returns></returns>
  // private static Point GetArcCenterPoint(double x1, double y1, double x2, double y2, double fA, double fs, double rx, double ry, double jia)
  // {
  //
  // var matrix1 = new Matrix { M11 = Math.Cos(jia), M12 = Math.Sin(jia), M21 = -Math.Sin(jia), M22 = Math.Cos(jia) };
  // var matrix2 = new Matrix { M11 = (x1 - x2) / 2, M21 = (y1 - y2) / 2 };
  // var matrixX1Y1 = Matrix.Multiply(matrix1, matrix2);
  //
  // var x1_ = matrixX1Y1.M11;
  // var y1_ = matrixX1Y1.M21;
  //
  // var a = Math.Pow(rx, 2) * Math.Pow(ry, 2) - Math.Pow(rx, 2) * Math.Pow(y1_, 2) - Math.Pow(ry, 2) * Math.Pow(x1_, 2);
  // var b = Math.Pow(ry, 2) * Math.Pow(y1_, 2) + Math.Pow(ry, 2) * Math.Pow(x1_, 2);
  //
  // double c = 0;
  // if (fA == fs)
  // {
  // c = -Math.Sqrt(a / b);
  // }
  // else
  // {
  // c = Math.Sqrt(a / b);
  // }
  //
  // var matrixCx_Cy_ = new Matrix { M11 = c * (rx * y1_ / ry), M21 = c * (-ry * x1_ / rx) };
  //
  // var tempMatrix = new Matrix { M11 = Math.Cos(jia), M12 = -Math.Sin(jia), M21 = Math.Sin(jia), M22 = Math.Cos(jia) };
  // var multiplyMatrix = Matrix.Multiply(tempMatrix, matrixCx_Cy_);
  //
  // var matrixCxCy=new Matrix(){M11 = multiplyMatrix.M11+((x1+x2)/2),M21= multiplyMatrix.M21+((y1+y2)/2) };
  //
  // return new Point(matrixCxCy.M11, matrixCxCy.M21);
  //
  // }

  // getArcCenterPoint(double x1, double y1, double x2, double y2, double fA, double fs, double rx, double ry, double jia){
  //   var matrix1 = Matrix4.zero()
  //   ..setEntry(0, 0, cos(jia))
  //   ..setEntry(0, 1, sin(jia))
  //   ..setEntry(1, 0, -sin(jia))
  //   ..setEntry(1, 1, cos(jia));
  //
  //   var matrix2 = Matrix4.zero()
  //   ..setEntry(0, 0, (x1 - x2) / 2)
  //   ..setEntry(1, 0, (y1 - y2) / 2);
  //
  //   var matrixX1Y1 = matrix1.multiplied(matrix2);
  //
  //   var x1_ = matrixX1Y1.entry(0, 0);
  //   var y1_ = matrixX1Y1.entry(1, 0);
  //
  //   var rx2 = pow(rx, 2); var ry2 = pow(ry, 2); var x1_2 = pow(x1_, 2); var y1_2 = pow(y1_, 2);
  //
  //   var a = pow(rx, 2) * pow(ry, 2) - pow(rx, 2) * pow(y1_, 2) - pow(ry, 2) * pow(x1_, 2);
  //   // var b = pow(rx, 2) * pow(y1_, 2) + pow(ry, 2) * pow(x1_, 2);
  //   var b = rx2 * y1_2 + ry2 * x1_2;
  //
  //   double c = 0;
  //   if (fA == fs) {
  //     c = -sqrt(a / b);
  //   } else {
  //     c = sqrt(a / b);
  //   }
  //
  //   var d = rx*y1_;
  //   var e = d/ry;
  //
  //   var f = ry*x1_;
  //   var g = -(f/rx);
  //
  //   var cx_ = c * e;
  //   var cy_ = c * g;
  //
  //   var matrix_step3_1 = Matrix4.zero()
  //   ..setEntry(0, 0, cos(jia))
  //   ..setEntry(0, 1, -sin(jia))
  //   ..setEntry(1, 0, sin(jia))
  //   ..setEntry(1, 1, cos(jia));
  //
  //   var matrix_step3_2 = Matrix4.zero()
  //   ..setEntry(0, 0, cx_)
  //   ..setEntry(1, 0, cy_);
  //
  //   var matrix_step3 = matrix_step3_1.multiplied(matrix_step3_2);
  //
  //   var cx = matrix_step3.entry(0, 0) + ((x1 + x2) / 2);
  //   var cy = matrix_step3.entry(1, 0) + ((y1 + y2) / 2);
  //
  //   return Offset(cx, cy);
  //
  //   // var matrixCx_Cy_ = Matrix4.zero()
  //   // ..setEntry(0, 0, c * (rx * y1_ / ry))
  //   // ..setEntry(1, 0, c * (-ry * x1_ / rx));
  //   //
  //   // var tempMatrix = Matrix4.zero()
  //   // ..setEntry(0, 0, cos(jia))
  //   // ..setEntry(0, 1, -sin(jia))
  //   // ..setEntry(1, 0, sin(jia))
  //   // ..setEntry(1, 1, cos(jia));
  //   //
  //   // var multiplyMatrix = tempMatrix.multiplied(matrixCx_Cy_);
  //   //
  //   // var matrixCxCy = Matrix4.zero()
  //   // ..setEntry(0, 0, multiplyMatrix.entry(0, 0) + ((x1 + x2) / 2))
  //   // ..setEntry(1, 0, multiplyMatrix.entry(1, 0) + ((y1 + y2) / 2));
  //
  //   // return Offset(matrixCxCy.entry(0, 0), matrixCxCy.entry(1, 0));
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
    var matrix_step3_1 = Matrix4.zero()
      ..setEntry(0, 0, cos(xAxisRotation))
      ..setEntry(0, 1, -sin(xAxisRotation))
      ..setEntry(1, 0, sin(xAxisRotation))
      ..setEntry(1, 1, cos(xAxisRotation));

    var matrix_step3_2 = Matrix4.zero()
      ..setEntry(0, 0, cx_)
      ..setEntry(1, 0, cy_);

    var matrix_step3 = matrix_step3_1.multiplied(matrix_step3_2);

    var cx = matrix_step3.entry(0, 0) + ((x1 + x2) / 2);
    var cy = matrix_step3.entry(1, 0) + ((y1 + y2) / 2);


    ret.centerPoint = Offset(cx, cy);
    //endregion

    //region 4. Compute θ1 and Δθ
    double ux = 1;
    double uy = 0;
    var vx = (x1_ - cx_) / rx;
    var vy = (y1_ - cy_) / ry;

    Vector2D v1 = Vector2D(Decimal.fromDouble(ux), uy.toDecimal());
    Vector2D v2 = Vector2D(vx.toDecimal(), vy.toDecimal());

    var theta1 = v1.angleTo(v2);

    double ux1 = (x1_ - cx_) / rx;
    double uy1 = (y1_ - cy_) / ry;

    double vx1 = (-x1_ - cx_) / rx;
    double vy1 = (-y1_ - cy_) / ry;

    Vector2D v3 = Vector2D(ux1.toDecimal(), uy1.toDecimal());
    Vector2D v4 = Vector2D(vx1.toDecimal(), vy1.toDecimal());

    var deltaTheta = v3.angleTo(v4);

    // where Δθ is fixed in the range −360° < Δθ < 360° such that:
    //
    // if fS = 0, then Δθ < 0,
    //
    // else if fS = 1, then Δθ > 0.
    if (fs && deltaTheta < Decimal.zero) {
      deltaTheta += Decimal.two * decimalPi;
    } else if (!fs && deltaTheta > Decimal.zero) {
      deltaTheta -= Decimal.two * decimalPi;
    }
    // In other words, if fS = 0 and the right side of (eq. 5.6) is greater than 0, then subtract 360°, whereas if fS = 1 and the right side of (eq. 5.6) is less than 0, then add 360°. In all other cases leave it as is.
    //endregion

    ret.startAngle = theta1.toDouble();
    ret.sweepAngle = deltaTheta.toDouble();

    return ret;
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





