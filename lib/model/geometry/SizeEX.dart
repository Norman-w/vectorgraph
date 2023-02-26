import 'dart:ui';
import 'package:decimal/decimal.dart';
import 'package:vectorgraph/utils/num_utils.dart';
class SizeEX {
  final Decimal width;
  final Decimal height;

  const SizeEX(this.width, this.height);
  static final zero = SizeEX(Decimal.zero, Decimal.zero);

  SizeEX.fromSize(Size size)
      : width = Decimal.parse(size.width.toString()),
        height = Decimal.parse(size.height.toString());

  Size toSize() {
    return Size(width.toDouble(), height.toDouble());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SizeEX &&
              runtimeType == other.runtimeType &&
              width == other.width &&
              height == other.height;

  @override
  int get hashCode => width.hashCode ^ height.hashCode;

  @override
  String toString() {
    return 'SizeEX{width: $width, height: $height}';
  }

  SizeEX operator /(Decimal value){
    return SizeEX((width/value).toDecimal(scaleOnInfinitePrecision:60), (height/value).toDecimal(scaleOnInfinitePrecision:60));
  }
}

extension SizeExternFunctions on Size{
  SizeEX toSizeEX(){
    return SizeEX(width.toDecimal(),height.toDecimal());
  }
}
