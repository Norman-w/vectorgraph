import 'dart:math';
import 'dart:ui';

double fabs(double value) {
  if(value.isInfinite || value.isInfinite) {return value;}
  return value <0? 0-value: value;
}
Color getRandomColor() {
  return Color.fromARGB(255, Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));
}

///已知两向量,求两向量夹角
double getAngle(double ux, double uy, double vx, double vy)
{
  double dot = ux * vx + uy * vy;
  double det = ux * vy - uy * vx;
  double angle = atan2(det, dot);
  return angle;
}