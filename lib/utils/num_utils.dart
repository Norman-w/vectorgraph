import 'dart:math';

const int decimalScale = 100;
class Decimal{
  double _ = 0;
  Decimal();
  @override
  String toString(){
    // return toStringAsFixed(2);
    return (_/decimalScale).toString();
  }
  ///乘以放大倍数以后的值.用于赋值给point的x,y或者其他时候使用.提高运算精度.
  double get accurateValue{
    return _;
  }
  factory Decimal.parse(String value){
    double d = double.parse(value);
    return Decimal().._=d*decimalScale;
  }
  factory Decimal.fromInt(int value){
    return Decimal().._=value * 1.0 * decimalScale;
  }
  factory Decimal.fromDouble(double value){
    return Decimal().._=value * decimalScale;
  }
  double toDouble(){
    return _/decimalScale;
  }
  double get doubleValue {
    return _/decimalScale;
  }
  String toStringAsFixed(int dotCount){
    return toDouble().toStringAsFixed(dotCount);
  }
  static Decimal get zero{
    return Decimal();
  }
  static Decimal get one{
    return Decimal().._=1.0*decimalScale;
  }
  static Decimal get two{
    return Decimal().._=2.0*decimalScale;
  }
  static Decimal get ten{
    return Decimal().._=10.0*decimalScale;
  }
  ///180
  static Decimal get halfCircle{
    return Decimal().._=180.0*decimalScale;
  }
  ///360
  static Decimal get fullCircle{
    return Decimal().._=360.0*decimalScale;
  }
  static Decimal get infinite{
    return Decimal().._=double.infinity * decimalScale;
  }
  static Decimal get negativeInfinity{
    return Decimal().._=double.negativeInfinity * decimalScale;
  }
  ///精度,double类型的最小值 乘以 放大倍数
  static Decimal get epsilon{
    return Decimal().._= double.minPositive*decimalScale;
  }
  Decimal operator /(Decimal other){
    //方案B,先把被除数放大,防止丢失精度,但是容易被除数过大导致崩溃.
    return Decimal().._=_ * decimalScale /other._;
    //方案A,更好理解,先算出来两个数的"比",然后再把得数放大以防丢失精度.不过除完以后再放大的系数是没有提高精度的.
    // return Decimal().._=_/other._ * decimalScale;
  }
  Decimal operator *(Decimal other){
    var v1 = _;
    var v2 = other._;
    var v3 = v1*v2;
    var v5 = v3/ decimalScale;
    return Decimal().._=v5;
  }
  Decimal operator +(Decimal other){
    return Decimal().._=_+other._;
  }
  Decimal operator -(Decimal other){
    return Decimal().._=_-other._;
  }
  bool operator < (Decimal other){
    return _<other._;
  }
  bool operator >(Decimal other){
    return _>other._;
  }
  operator -(){
    return Decimal().._=0.0-_;
  }
  bool operator >=(Decimal other){
    return _>=other._;
  }
  bool operator <=(Decimal other){
    return _<=other._;
  }
}

Decimal decimalSqrt(Decimal decimal) {
  if(decimal == Decimal.zero || decimal == Decimal.one) return decimal;

  Decimal val=decimal,last;
  do{
    last = val;
    val = (val+decimal/val)/Decimal.two;
  }while((val- last).abs() >= Decimal.epsilon);
  return val;
}

Decimal decimalPow(Decimal decimal, int exponent) {
  Decimal result = Decimal.one;
  for (int i = 0; i < exponent; i++) {
    result *= decimal;
  }
  return result;
}

extension DoubleExFunctions on double{
  Decimal toDecimal(){
    return Decimal().._=this*decimalScale;
  }
}
///实例对象的拓展方法
extension DecimalExFunctions on Decimal {
  //绝对值
  Decimal abs() {
    if (this<Decimal.zero) {
      return -this;
    }
    return this;
  }
  //取整
  Decimal round(){
    var d = (_/decimalScale).round()*decimalScale;
    var i = d.toInt();
    return Decimal().._= i.toDouble();
  }
  //向上取整
  Decimal ceil(){
    var d = (_/decimalScale).ceil()*decimalScale;
    var i = d.toInt();
    return Decimal().._= i.toDouble();
  }
  //向下取整
  Decimal floor(){
    var d = (_/decimalScale).floor()*decimalScale;
    var i = d.toInt();
    return Decimal().._= i.toDouble();
  }
  //取余
  Decimal remainder(Decimal other){
    return mod(other);
  }
  //取余
  Decimal mod(Decimal other){
    return Decimal().._=_%other._;
  }

  //幂次方
  Decimal pow(int exponent){
    return decimalPow(this, exponent);
  }
  //开平方
  Decimal sqrt(){
    return decimalSqrt(this);
  }
  //立方
  Decimal cube(){
    return this*this*this;
  }
  //平方
  Decimal square(){
    return this*this;
  }
  //万倍
  Decimal tenThousandTimes(){
    return this*Decimal.ten*Decimal.ten*Decimal.ten*Decimal.ten;
  }
  //千倍
  Decimal thousandTimes(){
    return this*Decimal.ten*Decimal.ten*Decimal.ten;
  }
  //百倍
  Decimal hundredTimes(){
    return this*Decimal.ten*Decimal.ten;
  }
  //十倍
  Decimal tenTimes(){
    return this*Decimal.ten;
  }
  //两倍
  Decimal doubleValue(){
    return this*Decimal.two;
  }
  //一半
  Decimal half(){
    return this/Decimal.two;
  }
  //十分之一
  Decimal tenth(){
    return this/Decimal.ten;
  }
  //百分之一
  Decimal hundredth(){
    return this/Decimal.ten/Decimal.ten;
  }
  //千分之一
  Decimal thousandth(){
    return this/Decimal.ten/Decimal.ten/Decimal.ten;
  }
  //万分之一
  Decimal tenThousandth(){
    return this/Decimal.ten/Decimal.ten/Decimal.ten/Decimal.ten;
  }
}
// 计算弧度制角度的正弦值
Decimal decimalSin(Decimal radians) {
   // Decimal sinValue = Decimal.zero;
   //  Decimal term = Decimal.zero;
   //  Decimal power = Decimal.one;
   //  Decimal factorial = Decimal.one;
   //
   //  for (int i = 0; i <= 20; i++) {
   //    power *= radians;
   //    factorial *= Decimal.fromInt(2 * i + 1);
   //    term = power / factorial;
   //    if (i % 2 == 0) {
   //      sinValue += term;
   //    } else {
   //      sinValue -= term;
   //    }
   //  }
   //
   //  return sinValue;
  return sin(radians.toDouble()).toDecimal();
}

// 计算弧度制角度的余弦值
Decimal decimalCos(Decimal radians) {
  // Decimal cosValue = Decimal.one;
  // Decimal term = Decimal.one;
  // Decimal power = radians;
  // Decimal factorial = Decimal.one;
  //
  // for (int i = 1; i <= 20; i++) {
  //   power *= radians * radians;
  //   factorial *= Decimal.fromInt((2 * i - 1) * (2 * i));
  //   term = power / factorial;
  //   if (i % 2 == 0) {
  //     cosValue += term;
  //   } else {
  //     cosValue -= term;
  //   }
  // }
  //
  // return cosValue;
  return cos(radians.toDouble()).toDecimal();
}

Decimal decimalACos(Decimal value)
{
  return acos(value.toDouble()).toDecimal();
}

Decimal decimalClamp(Decimal value, Decimal min, Decimal max) {
  if (value < min) {
    return min;
  } else if (value > max) {
    return max;
  } else {
    return value;
  }
}



var decimalPi = Decimal.parse('3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679');
var decimalPi2 = decimalPi*Decimal.two;
var decimalPiHalf = decimalPi/Decimal.two;
///每度的弧度pi值
var decimalPerDegree = decimalPi/Decimal.fromInt(180);

Decimal decimalAtan2(Decimal y, Decimal x) {
  // if (x > Decimal.zero) {
  //   return decimalAtan(y / x);
  // } else if (x < Decimal.zero) {
  //   if (y >= Decimal.zero) {
  //     return decimalAtan(y / x) + decimalPi;
  //   } else {
  //     return decimalAtan(y / x) - decimalPi;
  //   }
  // } else {
  //   if (y > Decimal.zero) {
  //     return decimalPiHalf;
  //   } else if (y < Decimal.zero) {
  //     return -decimalPiHalf;
  //   } else {
  //     return Decimal.zero;
  //   }
  // }
  return atan2(y.toDouble(), x.toDouble()).toDecimal();
}


Decimal decimalAtan(Decimal x) {
  // var epsilon = Decimal.parse('0.0000000000000001');
  //
  // var sum = Decimal.zero;
  // var sign = Decimal.one;
  // var term = x;
  // var n = 1;
  //
  // while (term.abs() >= epsilon) {
  //   sum += sign * term;
  //   sign = -sign;
  //   n += 2;
  //   term = decimalPow(x * x, n ~/ 2) / Decimal.fromInt(n);
  // }
  //
  // return sum + x / decimalSqrt(Decimal.one + x * x);
  return atan(x.toDouble()).toDecimal();
}

Decimal decimalTan(Decimal x){
  return tan(x.toDouble()).toDecimal();
}

Decimal decimalMin(x, y){
  return x>y? y:x;
}
Decimal decimalMax(x, y){
  return x>y? x:y;
}

// 将角度转换为弧度
Decimal degreesToRadians(Decimal deg) {
  return deg / Decimal.halfCircle * decimalPi;
}

// 将弧度转换为角度
Decimal radiansToDegrees(Decimal rad) {
  return rad / decimalPi * Decimal.halfCircle;
}

///计算离心角.椭圆和圆弧需要用到的函数.不明白原理.
Decimal eccentricAngle(Decimal a, Decimal b, Decimal rad) {
  return decimalAtan2(a*decimalSin(rad), b*decimalCos(rad));
}

