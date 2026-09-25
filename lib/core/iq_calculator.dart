import 'dart:math';

class IqCalculator {
  // Baseline IQ is 85. Max realistic calculated might be around 160-180.
  // Factors: Score (number of correct answers), Time efficiency, Penalty for wrongs.

  static int calculateIq({
    required int score,
    required int wrongAnswers,
    required int maxStreak,
    required bool isHardcore,
  }) {
    int baseIq = 85;

    // Each correct answer gives 3 points to IQ
    double scoreFactor = score * 3.5;

    // Penalty for mistakes
    double errorPenalty = wrongAnswers * 2.0;

    // Reward for consistency
    double streakBonus = maxStreak * 1.5;

    // Hardcore mode multiplier
    double difficultyMult = isHardcore ? 1.25 : 1.0;

    double finalIq =
        baseIq + ((scoreFactor - errorPenalty + streakBonus) * difficultyMult);

    // Add a bit of random variation to make it feel natural but keep it mostly deterministic
    final randomVar = Random().nextInt(5) - 2;

    return (finalIq + randomVar).clamp(50, 200).toInt();
  }

  static double calculatePercentile(int iq) {
    // Normal distribution approximation
    // Mean = 100, StdDev = 15
    double mean = 100;
    double sd = 15;
    double z = (iq - mean) / sd;

    // Simple approximation of CDF
    double percentile;
    if (z <= -3) {
      percentile = 0.1;
    } else if (z <= -2) {
      percentile = 2.3;
    } else if (z <= -1) {
      percentile = 15.9;
    } else if (z <= 0) {
      percentile = 50.0;
    } else if (z <= 1) {
      percentile = 84.1;
    } else if (z <= 2) {
      percentile = 97.7;
    } else if (z <= 3) {
      percentile = 99.9;
    } else {
      percentile = 99.99;
    }

    // Linear interpolation for more granular feeling
    if (z > 0 && z < 1) {
      percentile = 50.0 + (z * 34.1);
    }
    if (z >= 1 && z < 2) {
      percentile = 84.1 + ((z - 1) * 13.6);
    }
    if (z >= 2 && z < 3) {
      percentile = 97.7 + ((z - 2) * 2.2);
    }

    return double.parse(percentile.clamp(0.1, 99.9).toStringAsFixed(1));
  }
}
