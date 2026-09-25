import 'dart:math';
import 'models.dart';

class PuzzleEngine {
  static final _rand = Random();

  static PuzzleData generatePuzzle(int currentScore, bool hardcore) {
    // Escalate difficulty based on score
    List<PuzzleType> availableTypes = [
      PuzzleType.quickMath,
      PuzzleType.oddOneOut,
      PuzzleType.numberSequence,
    ];

    if (currentScore > 3 || hardcore) {
      availableTypes.add(PuzzleType.pattern);
    }
    if (currentScore > 6 || hardcore) {
      availableTypes.add(PuzzleType.memoryFlash);
    }
    if (currentScore > 10 || hardcore) {
      availableTypes.add(PuzzleType.shapeRotation);
    }

    PuzzleType type = availableTypes[_rand.nextInt(availableTypes.length)];

    switch (type) {
      case PuzzleType.quickMath:
        return _genMath(currentScore, hardcore);
      case PuzzleType.oddOneOut:
        return _genOddOneOut();
      case PuzzleType.numberSequence:
        return _genSequence(currentScore);
      case PuzzleType.pattern:
        return _genPattern();
      case PuzzleType.memoryFlash:
        return _genMemoryFlash();
      case PuzzleType.shapeRotation:
        return _genShapeRotation(currentScore);
    }
  }

  static PuzzleData _genMath(int score, bool hardcore) {
    int maxNum = 20 + (score * (hardcore ? 3 : 2));
    int a = _rand.nextInt(maxNum) + 1;
    int b = _rand.nextInt(maxNum) + 1;
    bool isAdd = _rand.nextBool();

    int answer = isAdd ? a + b : a - b;
    String q = isAdd ? "$a + $b = ?" : "$a - $b = ?";

    // Generate options
    List<int> opts = [
      answer,
      answer + _rand.nextInt(5) + 1,
      answer - _rand.nextInt(5) - 1,
      answer + _rand.nextInt(10) + 2,
    ];
    opts.shuffle(_rand);

    return PuzzleData(
      type: PuzzleType.quickMath,
      question: q,
      options: opts.map((e) => e.toString()).toList(),
      correctIndex: opts.indexOf(answer),
    );
  }

  static PuzzleData _genOddOneOut() {
    // E.g. find the odd letter or color (here we use simple emojis or words)
    List<List<String>> sets = [
      ["🍎", "🍌", "🍇", "🍔"], // food vs fast food
      ["🚗", "🚌", "🚲", "✈️"], // wheels vs fly
      ["🐱", "🐶", "🐭", "🌲"], // animals vs plant
    ];
    var s = sets[_rand.nextInt(sets.length)];
    List<String> opts = List.from(s);
    opts.shuffle(_rand);
    return PuzzleData(
      type: PuzzleType.oddOneOut,
      question: "Odd one out?",
      options: opts,
      correctIndex: opts.indexOf(s[3]),
    );
  }

  static PuzzleData _genSequence(int score) {
    int start = _rand.nextInt(10) + 1;
    int step = _rand.nextInt(5) + 2;
    int a = start, b = start + step, c = b + step;
    int answer = c + step;

    List<int> opts = [answer, answer + step, answer - 1, answer + 1];
    opts.shuffle(_rand);

    return PuzzleData(
      type: PuzzleType.numberSequence,
      question: "$a, $b, $c, ?",
      options: opts.map((e) => e.toString()).toList(),
      correctIndex: opts.indexOf(answer),
    );
  }

  static PuzzleData _genPattern() {
    return PuzzleData(
      type: PuzzleType.pattern,
      question: "Match the Pattern",
      options: ["A", "B", "C", "D"],
      correctIndex: _rand.nextInt(4),
      extraData: List.generate(
        9,
        (i) => _rand.nextBool(),
      ), // 3x3 grid pattern target
    );
  }

  static PuzzleData _genMemoryFlash() {
    int target = _rand.nextInt(99) + 10;
    List<int> opts = [target, target + 1, target - 10, target + 5];
    opts.shuffle(_rand);

    return PuzzleData(
      type: PuzzleType.memoryFlash,
      question: "Memorize: $target",
      options: opts.map((e) => e.toString()).toList(),
      correctIndex: opts.indexOf(target),
    );
  }

  static PuzzleData _genShapeRotation(int score) {
    return PuzzleData(
      type: PuzzleType.shapeRotation,
      question: "Rotated Shape",
      options: ["Up", "Right", "Down", "Left"],
      correctIndex: _rand.nextInt(4),
      // 0: Up, 1: Right, 2: Down, 3: Left
      extraData: [_rand.nextInt(4)], // base rotation
    );
  }
}
