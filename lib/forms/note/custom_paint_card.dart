
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color starColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.starColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(size.width, size.height),
        [HSLColor.fromColor(starColor).withLightness(0.8).toColor(), endColor]);

    var path = Path()
      ..moveTo(0, size.height - 4)
      ..lineTo(size.width - radius, size.height - 4)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius + 10)
      ..quadraticBezierTo(size.width, -2, size.width - radius, 4)
      ..lineTo(size.width - 10 * radius, 4)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height - 2)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}