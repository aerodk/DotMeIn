import 'dart:math';

import 'package:flutter/material.dart';

class StarWidget extends StatelessWidget {
  const StarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarPainter(),
      size: const Size(40, 40), // Juster størrelsen efter dine præferencer
    );
  }
}

class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.yellow;

    // Draw a star
    drawStar(canvas, size, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  // Function to draw a star
  void drawStar(Canvas canvas, Size size, Paint paint) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    double radius = size.width / 3;

    double angle = 0;

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
  }
}
