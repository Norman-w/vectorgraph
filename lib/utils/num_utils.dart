import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

/// Num Util.
class NumUtil {
  /// The parameter [fractionDigits] must be an integer satisfying: `0 <= fractionDigits <= 20`.
  static num? getNumByValueStr(String valueStr, {int? fractionDigits}) {
    double? value = double.tryParse(valueStr);
    return fractionDigits == null
        ? value
        : getNumByValueDouble(value, fractionDigits);
  }

  /// The parameter [fractionDigits] must be an integer satisfying: `0 <= fractionDigits <= 20`.
  static num? getNumByValueDouble(double? value, int fractionDigits) {
    if (value == null) return null;
    String valueStr = value.toStringAsFixed(fractionDigits);
    return fractionDigits == 0
        ? int.tryParse(valueStr)
        : double.tryParse(valueStr);
  }

  /// get int by value str.
  static int getIntByValueStr(String valueStr, {int defValue = 0}) {
    return int.tryParse(valueStr) ?? defValue;
  }

  /// get double by value str.
  static double getDoubleByValueStr(String valueStr, {double defValue = 0}) {
    return double.tryParse(valueStr) ?? defValue;
  }

  ///isZero
  static bool isZero(num value) {
    return value == null || value == 0;
  }

  /// 加 (精确相加,防止精度丢失).
  /// add (without loosing precision).
  static double add(num a, num b) {
    return addDec(a, b).toDouble();
  }

  /// 减 (精确相减,防止精度丢失).
  /// subtract (without loosing precision).
  static double subtract(num a, num b) {
    return subtractDec(a, b).toDouble();
  }

  /// 乘 (精确相乘,防止精度丢失).
  /// multiply (without loosing precision).
  static double multiply(num a, num b) {
    return multiplyDec(a, b).toDouble();
  }

  /// 除 (精确相除,防止精度丢失).
  /// divide (without loosing precision).
  static double divide(num a, num b) {
    return divideDec(a, b).toDouble();
  }

  /// 加 (精确相加,防止精度丢失).
  /// add (without loosing precision).
  static Decimal addDec(num a, num b) {
    return addDecStr(a.toString(), b.toString());
  }

  /// 减 (精确相减,防止精度丢失).
  /// subtract (without loosing precision).
  static Decimal subtractDec(num a, num b) {
    return subtractDecStr(a.toString(), b.toString());
  }

  /// 乘 (精确相乘,防止精度丢失).
  /// multiply (without loosing precision).
  static Decimal multiplyDec(num a, num b) {
    return multiplyDecStr(a.toString(), b.toString());
  }

  /// 除 (精确相除,防止精度丢失).
  /// divide (without loosing precision).
  static Decimal divideDec(num a, num b) {
    return divideDecStr(a.toString(), b.toString());
  }

  /// 除 (精确相除,防止精度丢失).保留几位小数，返回String
  /// divide (without loosing precision).
  static String divideStrNum(num a, num b, int digits) {
    return divideDecStr((a ?? 0).toString(), (b ?? 0).toString())
        .toStringAsFixed(digits);
  }

  /// 除 (精确相除,防止精度丢失).保留几位小数，返回String
  /// divide (without loosing precision).
  static String divideStrStr(String a, String b, int digits) {
    return divideDecStr(a ?? '0', b ?? '0').toStringAsFixed(digits);
  }

  /// 四舍五入(精确相除,防止精度丢失).保留几位小数，返回String
  /// (without loosing precision).
  static String toStringAsFixed(num a, int digits) {
    return Decimal.parse((a ?? 0).toString()).toStringAsFixed(digits);
  }

  /// 四舍五入(精确相除,防止精度丢失).保留几位小数，返回Double
  /// (without loosing precision).
  static num toDoubleAsFixed(num a, int digits) {
    return num.parse(
        Decimal.parse((a ?? 0).toString()).toStringAsFixed(digits));
  }

  /// 四舍五入(精确相除,防止精度丢失).保留几位小数，返回String
  /// (without loosing precision).
  static String toStringAsFixedStr(String a, int digits) {
    return Decimal.parse(a).toStringAsFixed(digits);
  }

  /// 余数
  static Decimal remainder(num a, num b) {
    return remainderDecStr(a.toString(), b.toString());
  }

  /// Relational less than operator.
  static bool lessThan(num a, num b) {
    return lessThanDecStr(a.toString(), b.toString());
  }

  /// Relational less than or equal operator.
  static bool thanOrEqual(num a, num b) {
    return thanOrEqualDecStr(a.toString(), b.toString());
  }

  /// Relational greater than operator.
  static bool greaterThan(num a, num b) {
    return greaterThanDecStr(a.toString(), b.toString());
  }

  /// Relational greater than or equal operator.
  static bool greaterOrEqual(num a, num b) {
    return greaterOrEqualDecStr(a.toString(), b.toString());
  }

  /// 加
  static Decimal addDecStr(String a, String b) {
    return Decimal.parse(a) + Decimal.parse(b);
  }

  /// 减
  static Decimal subtractDecStr(String a, String b) {
    return Decimal.parse(a) - Decimal.parse(b);
  }

  /// 乘
  static Decimal multiplyDecStr(String a, String b) {
    return Decimal.parse(a) * Decimal.parse(b);
  }

  /// 除
  static Decimal divideDecStr(String a, String b) {
    return (Decimal.parse(a) / Decimal.parse(b)).toDecimal(scaleOnInfinitePrecision:60);
  }

  /// 余数
  static Decimal remainderDecStr(String a, String b) {
    return Decimal.parse(a) % Decimal.parse(b);
  }

  /// Relational less than operator.
  static bool lessThanDecStr(String a, String b) {
    return Decimal.parse(a) < Decimal.parse(b);
  }

  /// Relational less than or equal operator.
  static bool thanOrEqualDecStr(String a, String b) {
    return Decimal.parse(a) <= Decimal.parse(b);
  }

  /// Relational greater than operator.
  static bool greaterThanDecStr(String a, String b) {
    return Decimal.parse(a) > Decimal.parse(b);
  }

  /// Relational greater than or equal operator.
  static bool greaterOrEqualDecStr(String a, String b) {
    return Decimal.parse(a) >= Decimal.parse(b);
  }

  static String parseFeeNumber(num fee) {
    if (fee == null) {
      return "0";
    }
    //数字格式化
    NumberFormat format = NumberFormat.currency(
        locale: 'id_ID', name: 'IDR', symbol: 'Rp', decimalDigits: 0);
    return format.format(fee);
  }
}

// Decimal decimalSqrt(Decimal decimal) {
//   // Decimal x = decimal;
//   // Decimal y = ((x + Decimal.one) / Decimal.fromInt(2)).toDecimal(scaleOnInfinitePrecision:60);
//   // while (x - y > Decimal.zero) {
//   //   x = y;
//   //   y = ((x + (decimal / x).toDecimal(scaleOnInfinitePrecision:60)) / Decimal.fromInt(2)).toDecimal(scaleOnInfinitePrecision:60);
//   // }
//   // return x;
//   return sqrt(decimal.toDouble()).toDecimal();
// }
Decimal decimalSqrt(Decimal decimal) {
  if (decimal == Decimal.zero) return Decimal.zero;
  if (decimal == Decimal.one) return Decimal.one;

  Decimal z = (decimal / decimal2).toDecimal(scaleOnInfinitePrecision:100);
  Decimal x = (decimal / z).toDecimal(scaleOnInfinitePrecision:100);

  while (z < x) {
    x = z;
    z = (((decimal / x).toDecimal(scaleOnInfinitePrecision:100) + x) / decimal2).toDecimal(scaleOnInfinitePrecision:100);
  }

  return x;
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
    return Decimal.parse(toString());
  }
}
extension DecimalExFunctions on Decimal {
  Decimal abs() {
    if (this<Decimal.zero) {
      return -this;
    }
    return this;
  }
}

Decimal decimal2 = Decimal.fromInt(2);

// 计算弧度制角度的正弦值
Decimal decimalSin(Decimal radians) {
  Decimal sinValue = Decimal.zero;
  Decimal term = radians;
  Decimal power = radians;
  Decimal factorial = Decimal.one;

  for (int i = 1; i <= 20; i++) {
    sinValue += term;
    power *= radians * radians;
    factorial *= Decimal.fromInt((2 * i) * (2 * i + 1));
    term = (power / factorial).toDecimal(scaleOnInfinitePrecision:60);
    if (i % 2 == 0) {
      term = -term;
    }
  }

  return sinValue;
}

// 计算弧度制角度的余弦值
Decimal decimalCos(Decimal radians) {
  Decimal cosValue = Decimal.one;
  Decimal term = Decimal.one;
  Decimal power = radians;
  Decimal factorial = Decimal.one;

  for (int i = 1; i <= 20; i++) {
    power *= radians * radians;
    factorial *= Decimal.fromInt((2 * i - 1) * (2 * i));
    term = (power / factorial).toDecimal(scaleOnInfinitePrecision:60);
    if (i % 2 == 0) {
      cosValue += term;
    } else {
      cosValue -= term;
    }
  }

  return cosValue;
}


var decimalPi = Decimal.parse('3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679');
var decimalPiHalf = (decimalPi/decimal2).toDecimal(scaleOnInfinitePrecision:60);

Decimal decimalAtan2(Decimal y, Decimal x) {
  if (x > Decimal.zero) {
    return decimalAtan((y / x).toDecimal(scaleOnInfinitePrecision:60));
  } else if (x < Decimal.zero) {
    if (y >= Decimal.zero) {
      return decimalAtan((y / x).toDecimal(scaleOnInfinitePrecision:60)) + decimalPi;
    } else {
      return decimalAtan((y / x).toDecimal(scaleOnInfinitePrecision:60)) - decimalPi;
    }
  } else {
    if (y > Decimal.zero) {
      return decimalPiHalf;
    } else if (y < Decimal.zero) {
      return -decimalPiHalf;
    } else {
      return Decimal.zero;
    }
  }
}


Decimal decimalAtan(Decimal x) {
  var epsilon = Decimal.parse('0.0000000000000001');

  var sum = Decimal.zero;
  var sign = Decimal.one;
  var term = x;
  var n = 1;

  while (term.abs() >= epsilon) {
    sum += sign * term;
    sign = -sign;
    n += 2;
    term = (decimalPow(x * x, n ~/ 2) / Decimal.fromInt(n)).toDecimal(scaleOnInfinitePrecision:60);
  }

  return sum + (x / decimalSqrt(Decimal.one + x * x)).toDecimal(scaleOnInfinitePrecision:60);
}

Decimal decimalMin(x, y){
  return x>y? y:x;
}
Decimal decimalMax(x, y){
  return x>y? x:y;
}

