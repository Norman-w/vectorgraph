import '../../../utils/num_utils.dart';
import '../points/point_ex.dart';
import '../rect/RectEX.dart';
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
}