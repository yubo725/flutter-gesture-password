import 'package:flutter/material.dart';
import 'package:flutter_gesture_password/path.dart';
import 'package:flutter_gesture_password/point.dart';
import 'package:flutter_gesture_password/panel.dart';

typedef OnGestureCompleteListener = void Function(List<int>);

class GestureView extends StatefulWidget {
  final double width, height;
  final OnGestureCompleteListener listener;

  GestureView({required this.width, required this.height, required this.listener});

  @override
  State<StatefulWidget> createState() => _GestureViewState();
}

class _GestureViewState extends State<GestureView> {
  List<GesturePoint> _points = [];

  @override
  void initState() {
    super.initState();
    // 计算9个圆点的位置坐标
    double deltaW = widget.width / 4;
    double deltaH = widget.height / 4;
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        int index = row * 3 + col;
        var p = GesturePoint(index, (col + 1) * deltaW, (row + 1) * deltaH);
        _points.add(p);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDotsPanel(widget.width, widget.height, _points),
        GesturePathView(widget.width, widget.height, _points, widget.listener)
      ],
    );
  }
}
