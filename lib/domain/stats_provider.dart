import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

final statsProvider = NotifierProvider<StatsNotifier, UserStats>(() {
  return StatsNotifier();
});

class StatsNotifier extends Notifier<UserStats> {
  @override
  UserStats build() {
    _loadStats();
    return UserStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final topScore = prefs.getInt('topScore') ?? 0;
    final topIq = prefs.getInt('topIq') ?? 0;
    final totalGames = prefs.getInt('totalGames') ?? 0;
    final isHardcoreUnlocked = prefs.getBool('isHardcore') ?? false;
    final hasRemovedAds = prefs.getBool('removedAds') ?? false;

    state = UserStats(
      topScore: topScore,
      topIq: topIq,
      totalGames: totalGames,
      isHardcoreUnlocked: isHardcoreUnlocked,
      hasRemovedAds: hasRemovedAds,
    );
  }

  Future<void> updateGameResult(int score, int iq) async {
    final prefs = await SharedPreferences.getInstance();

    int newTopScore = score > state.topScore ? score : state.topScore;
    int newTopIq = iq > state.topIq ? iq : state.topIq;
    int newTotalGames = state.totalGames + 1;

    // Hardcore mode automatically unlocked if IQ > 110 or Score > 15
    bool newHardcore = state.isHardcoreUnlocked || iq > 110 || newTopScore > 15;

    await prefs.setInt('topScore', newTopScore);
    await prefs.setInt('topIq', newTopIq);
    await prefs.setInt('totalGames', newTotalGames);
    await prefs.setBool('isHardcore', newHardcore);

    state = state.copyWith(
      topScore: newTopScore,
      topIq: newTopIq,
      totalGames: newTotalGames,
      isHardcoreUnlocked: newHardcore,
    );
  }

  Future<void> setAdsRemoved(bool removed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('removedAds', removed);
    state = state.copyWith(hasRemovedAds: removed);
  }
}
