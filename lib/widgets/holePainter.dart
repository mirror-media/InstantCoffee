import 'package:flutter/material.dart';

class HolePainter extends CustomPainter {
  final double left;
  final double top;
  final double width;
  final double height;

  HolePainter({
    @required this.left,
    @required this.top,
    @required this.width,
    @required this.height,  
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54;

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(
          Rect.fromLTWH(0, 0, size.width, size.height)
        ),
        Path()..addRect(
          Rect.fromLTWH(left, top, width, height)
        )..close(),
      ),
      paint
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}