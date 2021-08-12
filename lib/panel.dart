
import 'package:flutter/material.dart';
import 'package:flutter_gesture_password/point.dart';

// 9个圆点视图
class GestureDotsPanel extends StatelessWidget {
  final double width, height;
  final List<GesturePoint> points;

  GestureDotsPanel(this.width, this.height, this.points);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _PanelPainter(points),
      ),
    );
  }
}

class _PanelPainter extends CustomPainter {
  final List<GesturePoint> points;

  _PanelPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isNotEmpty) {
      for (var p in points) {
        p.drawCircle(canvas);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

}