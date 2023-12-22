// star_animation_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';

class StarAnimationScreen extends StatefulWidget {
  final Size canvasSize;

  StarAnimationScreen({required this.canvasSize});

  @override
  _StarAnimationScreenState createState() => _StarAnimationScreenState();
}

class _StarAnimationScreenState extends State<StarAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Star Animation'),
      ),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: StarPainter(_animation.value),
            size: widget.canvasSize,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class StarPainter extends CustomPainter {
  final double animationValue;

  StarPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.yellow;

    // Draw a star based on animation value
    drawStar(canvas, size, paint, animationValue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  // Function to draw a star
  void drawStar(Canvas canvas, Size size, Paint paint, double animationValue) {
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
