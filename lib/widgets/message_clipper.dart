import 'dart:core';

import 'package:flutter/material.dart';

class MessageClipper extends CustomClipper<Path> {
  final double borderWidth;
  MessageClipper({this.borderWidth = 3.0});

  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    double sWdith = width / 6;

    final path = Path()
      ..moveTo(0, height - borderWidth)
      ..lineTo(0, height)
      ..lineTo(sWdith + borderWidth, height + borderWidth)
      ..lineTo(sWdith + borderWidth, 6 * height / sWdith)
      ..lineTo(2 * sWdith - borderWidth, height)
      ..lineTo(width, height)
      ..lineTo(width, height - borderWidth)
      ..lineTo(2 * sWdith, height - borderWidth)
      ..lineTo(sWdith, 0)
      ..lineTo(sWdith, height - borderWidth)
      ..lineTo(0, height - borderWidth);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
