import 'package:flutter/material.dart';
import '../../domain/models.dart';
import 'painters/pattern_painter.dart';
import 'painters/shape_painter.dart';

class PuzzleBoardUI extends StatelessWidget {
  final PuzzleData puzzle;

  const PuzzleBoardUI({super.key, required this.puzzle});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Center(child: _buildInteractiveElement()));
  }

  Widget _buildInteractiveElement() {
    switch (puzzle.type) {
      case PuzzleType.quickMath:
      case PuzzleType.numberSequence:
      case PuzzleType.oddOneOut:
        return Text(
          puzzle.question,
          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        );
      case PuzzleType.pattern:
        return CustomPaint(
          size: const Size(200, 200),
          painter: PatternPainter(
            pattern: puzzle.extraData?.cast<bool>() ?? [],
          ),
        );
      case PuzzleType.memoryFlash:
        return Text(
          puzzle.question.split(': ')[1],
          style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
        );
      case PuzzleType.shapeRotation:
        return CustomPaint(
          size: const Size(150, 150),
          painter: ShapePainter(rotationIndex: puzzle.extraData?.first ?? 0),
        );
    }
  }
}
