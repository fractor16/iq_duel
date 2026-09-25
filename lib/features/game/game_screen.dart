import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/game_provider.dart';
import '../../core/theme.dart';
import 'puzzle_board.dart';
import '../results/results_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GameScreen extends ConsumerStatefulWidget {
  final bool hardcore;
  const GameScreen({super.key, this.hardcore = false});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameStateProvider.notifier).startGame(hardcore: widget.hardcore);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameStateProvider);

    // Listen for Game Over
    ref.listen<GameState>(gameStateProvider, (previous, next) {
      if (next.status == GameStatus.gameover &&
          previous?.status != GameStatus.gameover) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ResultsScreen()),
        );
      }
    });

    if (state.status == GameStatus.idle) {
      return const Scaffold(backgroundColor: AppTheme.darkBg);
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        ref.read(gameStateProvider.notifier).pauseGame();
        bool leave =
            await showDialog(
              context: context,
              builder: (c) => AlertDialog(
                backgroundColor: AppTheme.cardBg,
                title: const Text(
                  'Quit Game?',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(c, false),
                    child: const Text('RESUME'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(c, true),
                    child: const Text(
                      'QUIT',
                      style: TextStyle(color: AppTheme.neonPink),
                    ),
                  ),
                ],
              ),
            ) ??
            false;
        if (!leave) {
          ref.read(gameStateProvider.notifier).resumeGame();
        } else {
          if (context.mounted) Navigator.of(context).pop(result);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(state),
              _buildProgressBar(state),
              if (state.currentPuzzle != null) ...[
                PuzzleBoardUI(puzzle: state.currentPuzzle!),
                _buildOptionsGrid(state.currentPuzzle!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(GameState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: AppTheme.neonYellow),
              const SizedBox(width: 8),
              Text(
                    '${state.score}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neonYellow,
                    ),
                  )
                  .animate(key: ValueKey(state.score))
                  .scale(duration: 200.ms, curve: Curves.easeOut),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.timer, color: AppTheme.neonPink),
              const SizedBox(width: 8),
              Text(
                '${state.timeRemaining}s',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: state.timeRemaining <= 10
                      ? AppTheme.neonPink
                      : AppTheme.textWhite,
                ),
              ).animate(target: state.timeRemaining <= 5 ? 1 : 0).shake(hz: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(GameState state) {
    double progress = state.timeRemaining / 30.0;
    return Container(
      height: 6,
      width: double.infinity,
      color: AppTheme.cardBg,
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: state.timeRemaining <= 10
                ? AppTheme.neonPink
                : AppTheme.neonBlue,
            boxShadow: [
              BoxShadow(
                color: state.timeRemaining <= 10
                    ? AppTheme.neonPink
                    : AppTheme.neonBlue,
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsGrid(puzzle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: puzzle.options.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
                onPressed: () =>
                    ref.read(gameStateProvider.notifier).submitAnswer(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.cardBg,
                  foregroundColor: AppTheme.neonBlue,
                  side: const BorderSide(color: AppTheme.neonBlue, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    puzzle.options[index],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              .animate()
              .slideY(begin: 1.0, delay: (index * 100).ms, duration: 400.ms)
              .fadeIn();
        },
      ),
    );
  }
}
