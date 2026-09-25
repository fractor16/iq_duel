import 'package:flutter/material.dart';

class PatternPainter extends CustomPainter {
  final List<bool> pattern; // length 9

  PatternPainter({required this.pattern});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..style = PaintingStyle.fill;

    double cellSize = size.width / 3;

    for (int i = 0; i < 9; i++) {
      int row = i ~/ 3;
      int col = i % 3;

      paint.color = pattern[i]
          ? const Color(0xFF00F0FF)
          : const Color(0xFF1F2833);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            col * cellSize + 2,
            row * cellSize + 2,
            cellSize - 4,
            cellSize - 4,
          ),
          const Radius.circular(8),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PatternPainter oldDelegate) => true;
}
