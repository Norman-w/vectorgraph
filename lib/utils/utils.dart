import 'dart:math';
import 'dart:ui';

double fabs(double value) {
  if(value.isInfinite || value.isInfinite) {return value;}
  return value <0? 0-value: value;
}
Color getRandomColor() {
  return Color.fromARGB(255, Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));
}