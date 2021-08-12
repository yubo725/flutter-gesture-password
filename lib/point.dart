import 'package:flutter/material.dart';
import 'dart:math';

// 手势密码盘上的圆点
class GesturePoint {
  static final pointPainter = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.blue;

  static final linePainter = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.2
    ..color = Colors.blue;

  final int index;
  final double centerX;
  final double centerY;
  final double radius = 4;
  final double padding = 26;

  GesturePoint(this.index, this.centerX, this.centerY);

  // 绘制小圆点
  void drawCircle(Canvas canvas) {
    canvas.drawOval(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        pointPainter);

    canvas.drawOval(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: padding),
        linePainter);
  }

  // 判断坐标是否在小圆内（padding为半径）
  bool checkInside(double x, double y) {
    var distance = sqrt(pow((x - centerX), 2) + pow((y - centerY), 2));
    return distance <= padding;
  }

  @override
  bool operator ==(Object other) {
    if (other is GesturePoint) {
      return this.index == other.index &&
          this.centerX == other.centerX &&
          this.centerY == other.centerY;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;

}