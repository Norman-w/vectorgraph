import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:vectorgraph/utils/num_utils.dart';

import '../points/point_ex.dart';

class Vector2D{
  Decimal x;
  Decimal y;

  Vector2D(this.x, this.y);


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
  rotateZ(Decimal angle) {
    Decimal x = this.x * decimalCos(angle) - this.y * decimalSin(angle);
    Decimal y = this.x * decimalSin(angle) + this.y * decimalCos(angle);
    return Vector2D(x, y);
  }

  operator +(Vector2D vector) {
    return Vector2D(x + vector.x, y + vector.y);
  }

  operator -(Vector2D vector) {
    return Vector2D(x - vector.x, y - vector.y);
  }

  operator *(Decimal value) {
    return Vector2D(x * value, y * value);
  }

  setLength(Decimal length) {
    Decimal angle = getAngle();
    x = length * decimalCos(angle);
    y = length * decimalSin(angle);
  }

  getAngle() {
    return decimalAtan2(y, x);
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

  Decimal get length => decimalSqrt(x * x + y * y);
}

