import 'package:flutter/material.dart';
import 'package:vectorgraph/utils/num_utils.dart';

import '../points/point_ex.dart';

class Vector2D{
  Decimal x;
  Decimal y;

  Vector2D(this.x, this.y);

  static Vector2D get zero{
    return Vector2D(Decimal.zero,Decimal.zero);
  }

  Offset toOffset(){
    return Offset(x.toDouble(), y.toDouble());
  }
  PointEX toPointEX(){
    return PointEX(x,y);
  }


  translate(Vector2D vector) {
    return Vector2D(x + vector.x, y + vector.y);
  }
  transform(Matrix4 matrix) {
    Vector2D vector = Vector2D(x, y);
    vector.x = matrix[0].toDecimal() * x + matrix[4].toDecimal() * y + matrix[12].toDecimal();
    vector.y = matrix[1].toDecimal() * x + matrix[5].toDecimal() * y + matrix[13].toDecimal();
    return vector;
  }

  //rotate z by angle without using matrix
  Vector2D rotateZ(Decimal angle) {
    Decimal x = this.x * decimalCos(angle) - this.y * decimalSin(angle);
    Decimal y = this.x * decimalSin(angle) + this.y * decimalCos(angle);
    return Vector2D(x, y);
  }

  Vector2D operator +(Vector2D vector) {
    return Vector2D(x + vector.x, y + vector.y);
  }

  Vector2D operator -(Vector2D vector) {
    return Vector2D(x - vector.x, y - vector.y);
  }

  Vector2D operator *(Decimal value) {
    return Vector2D(x * value, y * value);
  }

  Decimal dot(Vector2D vector) {
    return x * vector.x + y * vector.y;
  }
  Decimal cross(Vector2D vector) {
    return x * vector.y - y * vector.x;
  }

  // Vector2D dot(Vector2D other){
  //   return Vector2D(x * other.x, y * other.y);
  // }
  // Vector2D cross(Vector2D other){
  //   return Vector2D(x * other.y, y * other.x);
  // }

  setLength(Decimal length) {
    Decimal angle = getAngle();
    x = length * decimalCos(angle);
    y = length * decimalSin(angle);
  }

  ///获取向量的角度,0度为x轴正方向,顺时针为正,逆时针为负
  Decimal getAngle() {
    return decimalAtan2(y, x);
  }

  Decimal angleTo(Vector2D vector) {
    Decimal angle = getAngle() - vector.getAngle();
    if (angle < Decimal.zero) {
      angle += decimalPi * Decimal.two;
    }
    return angle;
  }

  @override
  String toString() {
    return 'Vector2D{x: ${x.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}';
  }
  Decimal distance(Vector2D vector) {
    return decimalSqrt(decimalPow(x - vector.x, 2) + decimalPow(y - vector.y, 2));
  }

  Vector2D multiply(PointEX p) {
    return Vector2D(x * p.x, y * p.y);
  }
  Decimal multiplyToDecimal(PointEX p) {
    return x * p.x + y * p.y;
  }

  factory Vector2D.fromAngle(Decimal angle, Decimal length) {
    return Vector2D(length * decimalCos(angle), length * decimalSin(angle));
  }
  factory Vector2D.fromPolar(Decimal angle, Decimal length) {
    return Vector2D(length * decimalCos(angle), length * decimalSin(angle));
  }

  // Decimal cross(Vector2D vector) {
  //   return x * vector.y - y * vector.x;
  // }

  Decimal get length => decimalSqrt(x * x + y * y);

  Vector2D normalize() {
    Decimal length = this.length;
    return Vector2D(x / length, y / length);
  }
}

