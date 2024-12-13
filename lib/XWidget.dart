import 'package:flutter/material.dart';

class XBlueWidget extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;

  const XBlueWidget({super.key, this.size = 80, this.strokeWidth = 10, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: BlueXPainter(strokeWidth: strokeWidth, color: color),
    );
  }
}

class BlueXPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  BlueXPainter({required this.strokeWidth, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth; // 设置线条宽度

    // 绘制左上到右下的线
    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width, size.height),
      paint,
    );

    // 绘制右上到左下的线
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
