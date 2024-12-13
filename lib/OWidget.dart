import 'dart:math';

import 'package:flutter/material.dart';

class ORedWidget extends StatelessWidget {
  final double size; // 圆环的直径
  final double strokeWidth; // 圆环的宽度
  final Color color;
  const ORedWidget({
    super.key,
    this.size = 80.0,
    this.strokeWidth = 10.0,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: CirclePainter(strokeWidth: strokeWidth,color: color),
    );
  }
}

class CirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  CirclePainter({required this.strokeWidth,required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (min(size.width, size.height) - strokeWidth) / 2;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
