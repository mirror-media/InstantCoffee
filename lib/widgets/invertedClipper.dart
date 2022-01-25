import 'package:flutter/material.dart';

class InvertedClipper extends CustomClipper<Path> {
  final double left;
  final double top;
  final double width;
  final double height;

  InvertedClipper({
    required this.left,
    required this.top,
    required this.width,
    required this.height,  
  });

  @override
  Path getClip(Size size) {
    return Path.combine(
      PathOperation.difference,
      Path()..addRect(
        Rect.fromLTWH(0, 0, size.width, size.height)
      ),
      Path()..addRect(
        Rect.fromLTWH(left, top, width, height)
      )..close(),
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}