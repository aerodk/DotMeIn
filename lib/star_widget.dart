import 'dart:math';

import 'package:flutter/material.dart';

class StarWidget extends StatelessWidget {
  final double animationValue;

  const StarWidget({super.key, required this.animationValue});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarPainter(animationValue),
      size: const Size(40, 40),
    );
  }
}

class StarPainter extends CustomPainter {
  final double animationValue;
  StarPainter(this.animationValue);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.yellow;

    // Draw a star
    drawStar(canvas, size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  // Function to draw a star
  void drawStar(Canvas canvas, Size size, Paint paint) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    double radius = size.width / 3;

    // Rotate the star based on animation value
    double rotation = 1 * pi * animationValue;

    double angle = 0;

    // Apply rotation to the canvas
    canvas.save();
    canvas.translate(centerX, centerY);

    canvas.rotate(rotation);
    Path path = Path();

    for (int i = 0; i < 5; i++) {
      double x = centerX + cos(angle) * radius;
      double y = centerY + sin(angle) * radius;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      angle += 2 * pi / 5;

      x = centerX + cos(angle) * (radius * 0.5);
      y = centerY + sin(angle) * (radius * 0.5);

      path.lineTo(x, y);

      angle += 2 * pi / 5;
    }

    path.close();

    canvas.drawPath(path, paint);

    // Restore the canvas to its original state
    canvas.restore();
  }
}
