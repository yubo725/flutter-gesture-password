import 'package:flutter/material.dart';
import 'package:flutter_gesture_password/gesture_view.dart';
import 'package:flutter_gesture_password/point.dart';

// 手势密码路径视图
class GesturePathView extends StatefulWidget {
  final double width;
  final double height;
  final List<GesturePoint> points;
  final OnGestureCompleteListener listener;

  GesturePathView(this.width, this.height, this.points, this.listener);

  @override
  State<StatefulWidget> createState() => _GesturePathViewState();
}

class _GesturePathViewState extends State<GesturePathView> {
  GesturePoint? lastPoint;
  Offset? movePos;
  List<GesturePoint> pathPoints = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: _PathPainter(movePos, pathPoints),
      ),
      onPanDown: _onPanDown,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
    );
  }

  // 手指按下
  _onPanDown(DragDownDetails e) {
    // 判断按下的坐标是否在某个点上
    final x = e.localPosition.dx;
    final y = e.localPosition.dy;
    for (var p in widget.points) {
      if (p.checkInside(x, y)) {
        lastPoint = p;
      }
    }
    pathPoints.clear();
  }

  // 手指滑动
  _onPanUpdate(DragUpdateDetails e) {
    // 如果手指按下时不在某个圆点上，则不处理滑动事件
    if (lastPoint == null) {
      return;
    }
    // 滑动时如果在某个圆点上，则将该圆点加入路径中
    final x = e.localPosition.dx;
    final y = e.localPosition.dy;
    GesturePoint? passPoint;
    for (var p in widget.points) {
      if (p.checkInside(x, y) && !pathPoints.contains(p)) {
        passPoint = p;
        break;
      }
    }
    setState(() {
      if (passPoint != null) {
        lastPoint = passPoint;
        pathPoints.add(passPoint);
      }
      movePos = Offset(x, y);
    });
  }

  // 手指抬起
  _onPanEnd(DragEndDetails e) {
    setState(() {
      movePos = null;
    });
    List<int> arr = [];
    if (pathPoints.isNotEmpty) {
      for (var value in pathPoints) {
        arr.add(value.index);
      }
    }
    widget.listener(arr);
  }
}

// 绘制手势路径
class _PathPainter extends CustomPainter {
  final Offset? movePos;
  final List<GesturePoint> pathPoints;

  // 路径画笔
  final pathPainter = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6
    ..strokeCap = StrokeCap.round
    ..color = Colors.blue;

  _PathPainter(this.movePos, this.pathPoints);

  @override
  void paint(Canvas canvas, Size size) {
    _drawPassPath(canvas);
    _drawRTPath(canvas);
  }

  _drawPassPath(Canvas canvas) {
    if (pathPoints.length <= 1) {
      return;
    }
    for (int i = 0; i < pathPoints.length - 1; i++) {
      var start = pathPoints[i];
      var end = pathPoints[i + 1];
      canvas.drawLine(Offset(start.centerX, start.centerY),
          Offset(end.centerX, end.centerY), pathPainter);
    }
  }

  _drawRTPath(Canvas canvas) {
    if (pathPoints.isNotEmpty && movePos != null) {
      var lastPoint = pathPoints.last;
      canvas.drawLine(Offset(lastPoint.centerX, lastPoint.centerY), movePos!, pathPainter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
