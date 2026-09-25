import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/game_provider.dart';
import '../../domain/ad_manager.dart';
import '../../core/theme.dart';
import '../../core/iq_calculator.dart';

class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  bool _rewardClaimed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adManagerProvider).showInterstitialIfAvailable();
      ref.read(adManagerProvider).loadRewardedAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameStateProvider);
    final percentile = IqCalculator.calculatePercentile(state.iqResult);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        Navigator.pop(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'GAME OVER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.neonPink,
                    letterSpacing: 2,
                  ),
                ).animate().slideY(begin: -2.0, duration: 600.ms).fadeIn(),

                const SizedBox(height: 48),

                _buildResultCard(
                  "YOUR IQ SCORE",
                  "${state.iqResult}",
                  AppTheme.neonBlue,
                ).animate().scale(delay: 400.ms, duration: 600.ms),

                const SizedBox(height: 24),

                _buildResultCard(
                  "CORRECT ANSWERS",
                  "${state.score}",
                  AppTheme.neonYellow,
                ).animate().scale(delay: 500.ms, duration: 600.ms),

                const SizedBox(height: 32),

                Text(
                  "You are smarter than $percentile% of people!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppTheme.textWhite,
                    fontStyle: FontStyle.italic,
                  ),
                ).animate().fadeIn(delay: 1.seconds),

                const Spacer(),

                if (!_rewardClaimed)
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(adManagerProvider).showRewardedAd(() {
                        setState(() {
                          _rewardClaimed = true;
                        });
                        // Resume game with 10 seconds
                        ref.read(gameStateProvider.notifier).extendTime(10);
                        ref.read(gameStateProvider.notifier).resumeGame();
                        Navigator.pop(context); // Go back to game
                      });
                    },
                    icon: const Icon(Icons.ondemand_video),
                    label: const Text('WATCH TO GET +10s'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.neonGreen,
                      foregroundColor: AppTheme.darkBg,
                    ),
                  ).animate().shimmer(delay: 1.5.seconds, duration: 2.seconds),

                const SizedBox(height: 16),

                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context); // Goes back to home
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.neonBlue, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'BACK TO MENU',
                    style: TextStyle(
                      color: AppTheme.neonBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              color: color,
              shadows: [
                Shadow(color: color.withValues(alpha: 0.5), blurRadius: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
