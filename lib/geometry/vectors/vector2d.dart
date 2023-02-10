import 'dart:math';

import 'package:flutter/material.dart';

import '../points/point_ex.dart';
import '../../utils.dart';

class Vector2D{
  double x;
  double y;

  Vector2D(this.x, this.y);


  translate(Vector2D vector) {
    return Vector2D(x + vector.x, y + vector.y);
  }
  transform(Matrix4 matrix) {
    Vector2D vector = Vector2D(x, y);
    vector.x = matrix[0] * x + matrix[4] * y + matrix[12];
    vector.y = matrix[1] * x + matrix[5] * y + matrix[13];
    return vector;
  }

  //rotate z by angle without using matrix
  rotateZ(double angle) {
    double x = this.x * cos(angle) - this.y * sin(angle);
    double y = this.x * sin(angle) + this.y * cos(angle);
    return Vector2D(x, y);
  }

  operator +(Vector2D vector) {
    return Vector2D(x + vector.x, y + vector.y);
  }

  operator -(Vector2D vector) {
    return Vector2D(x - vector.x, y - vector.y);
  }

  operator *(double value) {
    return Vector2D(x * value, y * value);
  }

  setLength(double length) {
    double angle = getAngle();
    x = length * cos(angle);
    y = length * sin(angle);
  }

  getAngle() {
    return atan2(y, x);
  }

  @override
  String toString() {
    return 'Vector2D{x: ${x.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}';
  }
  double distance(Vector2D vector) {
    return sqrt(pow(x - vector.x, 2) + pow(y - vector.y, 2));
  }

  Vector2D multiply(PointEX p) {
    return Vector2D(x * p.x, y * p.y);
  }
  double multiplyToDouble(PointEX p) {
    return x * p.x + y * p.y;
  }

  factory Vector2D.fromAngle(double angle, double length) {
    return Vector2D(length * cos(angle), length * sin(angle));
  }

  double get length => sqrt(x * x + y * y);
}

