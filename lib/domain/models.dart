class UserStats {
  final int topScore;
  final int topIq;
  final int totalGames;
  final bool isHardcoreUnlocked;
  final bool hasRemovedAds;

  UserStats({
    this.topScore = 0,
    this.topIq = 0,
    this.totalGames = 0,
    this.isHardcoreUnlocked = false,
    this.hasRemovedAds = false,
  });

  UserStats copyWith({
    int? topScore,
    int? topIq,
    int? totalGames,
    bool? isHardcoreUnlocked,
    bool? hasRemovedAds,
  }) {
    return UserStats(
      topScore: topScore ?? this.topScore,
      topIq: topIq ?? this.topIq,
      totalGames: totalGames ?? this.totalGames,
      isHardcoreUnlocked: isHardcoreUnlocked ?? this.isHardcoreUnlocked,
      hasRemovedAds: hasRemovedAds ?? this.hasRemovedAds,
    );
  }
}

enum PuzzleType {
  pattern,
  numberSequence,
  oddOneOut,
  quickMath,
  memoryFlash,
  shapeRotation,
}

class PuzzleData {
  final PuzzleType type;
  final String question;
  final List<String> options;
  final int correctIndex;

  // Optional parameters for specific rendering logic like shapes
  final List<dynamic>? extraData;

  PuzzleData({
    required this.type,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.extraData,
  });
}
