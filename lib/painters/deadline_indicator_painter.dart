import 'package:flutter/material.dart';

class DeadlineIndicatorPainter extends CustomPainter {
  final Color color;

  DeadlineIndicatorPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw a downward-pointing triangle (representing the end of the deadline)
    Path path = Path()
      ..moveTo(size.width - 5, -3) // Start at left point
      ..lineTo(size.width + 5, -3) // Right point
      ..lineTo(size.width, 2) // Top point (tail of the arrow)
      ..close();

    canvas.drawPath(path, paint);

    // Draw white border around the triangle
    final borderPaint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
