import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'models.dart';
import 'puzzle_engine.dart';
import '../core/iq_calculator.dart';
import 'stats_provider.dart';

enum GameStatus { playing, paused, gameover, idle }

class GameState {
  final int score;
  final int timeRemaining;
  final int wrongAnswers;
  final int currentStreak;
  final int maxStreak;
  final PuzzleData? currentPuzzle;
  final GameStatus status;
  final bool isHardcore;
  final int iqResult;

  GameState({
    this.score = 0,
    this.timeRemaining = 30,
    this.wrongAnswers = 0,
    this.currentStreak = 0,
    this.maxStreak = 0,
    this.currentPuzzle,
    this.status = GameStatus.idle,
    this.isHardcore = false,
    this.iqResult = 0,
  });

  GameState copyWith({
    int? score,
    int? timeRemaining,
    int? wrongAnswers,
    int? currentStreak,
    int? maxStreak,
    PuzzleData? currentPuzzle,
    GameStatus? status,
    bool? isHardcore,
    int? iqResult,
  }) {
    return GameState(
      score: score ?? this.score,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      currentStreak: currentStreak ?? this.currentStreak,
      maxStreak: maxStreak ?? this.maxStreak,
      currentPuzzle: currentPuzzle ?? this.currentPuzzle,
      status: status ?? this.status,
      isHardcore: isHardcore ?? this.isHardcore,
      iqResult: iqResult ?? this.iqResult,
    );
  }
}

final gameStateProvider = NotifierProvider<GameNotifier, GameState>(() {
  return GameNotifier();
});

class GameNotifier extends Notifier<GameState> {
  Timer? _timer;

  @override
  GameState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return GameState();
  }

  void startGame({bool hardcore = false}) {
    state = GameState(
      status: GameStatus.playing,
      isHardcore: hardcore,
      currentPuzzle: PuzzleEngine.generatePuzzle(0, hardcore),
    );
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeRemaining > 0 && state.status == GameStatus.playing) {
        state = state.copyWith(timeRemaining: state.timeRemaining - 1);
      } else if (state.timeRemaining <= 0) {
        endGame();
      }
    });
  }

  void submitAnswer(int selectedIndex) {
    if (state.status != GameStatus.playing || state.currentPuzzle == null) {
      return;
    }
    HapticFeedback.lightImpact();

    bool isCorrect = selectedIndex == state.currentPuzzle!.correctIndex;

    if (isCorrect) {
      int newStreak = state.currentStreak + 1;
      int newMaxStreak = newStreak > state.maxStreak
          ? newStreak
          : state.maxStreak;
      state = state.copyWith(
        score: state.score + 1,
        currentStreak: newStreak,
        maxStreak: newMaxStreak,
        currentPuzzle: PuzzleEngine.generatePuzzle(
          state.score + 1,
          state.isHardcore,
        ),
      );
    } else {
      HapticFeedback.vibrate();
      state = state.copyWith(
        wrongAnswers: state.wrongAnswers + 1,
        currentStreak: 0,
        timeRemaining:
            state.timeRemaining - (state.isHardcore ? 5 : 1), // Penalty
      );
    }
  }

  void extendTime(int seconds) {
    state = state.copyWith(timeRemaining: state.timeRemaining + seconds);
  }

  void pauseGame() {
    _timer?.cancel();
    state = state.copyWith(status: GameStatus.paused);
  }

  void resumeGame() {
    if (state.status == GameStatus.paused) {
      state = state.copyWith(status: GameStatus.playing);
      _startTimer();
    }
  }

  void endGame() {
    _timer?.cancel();

    int finalIq = IqCalculator.calculateIq(
      score: state.score,
      wrongAnswers: state.wrongAnswers,
      maxStreak: state.maxStreak,
      isHardcore: state.isHardcore,
    );

    // Save to stats
    ref.read(statsProvider.notifier).updateGameResult(state.score, finalIq);

    state = state.copyWith(
      status: GameStatus.gameover,
      timeRemaining: 0,
      iqResult: finalIq,
    );
  }
}
