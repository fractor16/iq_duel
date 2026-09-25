import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/stats_provider.dart';
import '../../domain/iap_manager.dart';
import '../game/game_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                    'IQ DUEL',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 64,
                      color: AppTheme.neonBlue,
                      shadows: [
                        Shadow(
                          color: AppTheme.neonBlue.withValues(alpha: 0.8),
                          blurRadius: 20,
                        ),
                      ],
                      letterSpacing: 4,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .scale(curve: Curves.easeOutBack, duration: 800.ms),

              const SizedBox(height: 10),

              Text(
                '30 Second Brain Battle',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: AppTheme.textWhite,
                  letterSpacing: 2,
                ),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 60),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatBox("TOP SCORE", "${stats.topScore}", AppTheme.neonPink),
                  _StatBox("MAX IQ", "${stats.topIq}", AppTheme.neonGreen),
                ],
              ).animate().slideY(begin: 1.0, duration: 600.ms).fadeIn(),

              const SizedBox(height: 60),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const GameScreen(hardcore: false),
                    ),
                  );
                },
                child: const Text('PLAY NOW'),
              ).animate().shimmer(delay: 1.seconds, duration: 2.seconds),

              const SizedBox(height: 20),

              if (stats.isHardcoreUnlocked)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: AppTheme.neonPink, width: 2),
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const GameScreen(hardcore: true),
                      ),
                    );
                  },
                  child: const Text(
                    'HARDCORE MODE',
                    style: TextStyle(color: AppTheme.neonPink),
                  ),
                )
              else
                OutlinedButton.icon(
                  onPressed: () {
                    ref.read(iapManagerProvider).buyHardcoreMode();
                  },
                  icon: const Icon(Icons.lock, color: Colors.grey),
                  label: const Text(
                    'UNLOCK HARDCORE (\$1.99)',
                    style: TextStyle(color: Colors.grey),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey, width: 2),
                  ),
                ),

              const Spacer(),

              if (!stats.hasRemovedAds)
                TextButton(
                  onPressed: () {
                    ref.read(iapManagerProvider).buyRemoveAds();
                  },
                  child: const Text(
                    'Remove Ads (\$2.99)',
                    style: TextStyle(color: AppTheme.textWhite),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String val;
  final Color color;
  const _StatBox(this.label, this.val, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textWhite,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            val,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
