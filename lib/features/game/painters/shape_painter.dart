import 'package:flutter/material.dart';
import 'dart:math' as math;

class ShapePainter extends CustomPainter {
  final int rotationIndex; // 0, 1, 2, 3

  ShapePainter({required this.rotationIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Save state before rotation
    canvas.save();

    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationIndex * math.pi / 2);
    canvas.translate(-center.dx, -center.dy);

    // Paint complex shape pointing up (0 rotation)
    var path = Path()
      ..moveTo(center.dx, 10)
      ..lineTo(center.dx + 40, size.height - 20)
      ..lineTo(center.dx, size.height - 50)
      ..lineTo(center.dx - 40, size.height - 20)
      ..close();

    var paint = Paint()
      ..color = const Color(0xFFFF007F)
      ..style = PaintingStyle.fill
      ..strokeWidth = 3;

    var borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ShapePainter oldDelegate) => true;
}
