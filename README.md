# ⚡ IQ Duel – 30 Second Brain Battle

<div align="center">

  ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
  ![Riverpod](https://img.shields.io/badge/State_Management-Riverpod-2e7d32?style=for-the-badge)
  ![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)
  ![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-orange?style=for-the-badge)

  <p align="center">
    <strong>A high-octane, neon-styled speed puzzle game built with Flutter. Test your cognitive reflexes, maintain your combo streak, and prove your IQ in 30 seconds of pure mental intensity!</strong>
  </p>

  <p align="center">
    <a href="#-key-features">Features</a> •
    <a href="#-game-mechanics">Game Mechanics</a> •
    <a href="#-puzzle-archetypes">Puzzles</a> •
    <a href="#-tech-stack--architecture">Architecture</a> •
    <a href="#-getting-started">Getting Started</a> •
    <a href="#-monetization">Monetization</a>
  </p>
</div>

---

## 🎮 Overview

**IQ Duel** challenges players to solve rapid-fire logic, arithmetic, spatial, and memory challenges under strict time pressure. With dynamic procedural difficulty scaling and time-penalty mechanics, every millisecond counts!

- ⏱ **30-Second Sprints:** Fast, addictive game loop engineered for quick sessions and high replayability.
- 🔥 **Combo Multipliers:** Chaining correct answers builds a streak multiplier that boosts your calculated IQ score.
- ⚡ **Neon Cyberpunk Aesthetic:** Designed with immersive dark neon styling, fluid micro-interactions, and reactive animations powered by `flutter_animate`.
- 🧠 **Procedural Puzzle Engine:** Infinite variations—no two runs are ever identical.

---

## ✨ Key Features

- **Dynamic IQ Assessment:** Calculates an accurate performance IQ score based on accuracy, response velocity, and combo consistency.
- **Two Game Modes:**
  - **Normal Mode:** 30 seconds, `-1s` penalty for incorrect answers.
  - **Hardcore Mode:** Accelerated difficulty curve with brutal `-5s` penalty per mistake.
- **Procedural Challenge Generator:** Scales difficulty dynamically as your score climbs within the same run.
- **Comprehensive Statistics:** Local persistence tracking lifetime games, high scores, average IQ, and peak streaks using `shared_preferences`.
- **Haptic & Audio Feedback:** Punchy audio effects via `audioplayers` for correct answers, errors, countdown ticks, and game over sequences.
- **Monetization Ready:** Built-in integration for Google Mobile Ads (Banner, Interstitial, Rewarded Revives) and In-App Purchases (Ad Removal & Hardcore Mode Unlock).

---

## 🧩 Puzzle Archetypes

The custom `PuzzleEngine` randomly selects and scales 6 distinct cognitive archetypes:

| Type | Cognitive Domain | Description |
| :--- | :--- | :--- |
| 🧮 **Quick Math** | Numerical Agility | Rapid mental arithmetic under time pressure with escalating numerical ranges. |
| 🔍 **Odd One Out** | Visual Discrimination | Detect the anomalous shape, color, or symbol from a quick grid. |
| 🔢 **Number Sequence** | Inductive Reasoning | Extrapolate arithmetic, geometric, or algorithmic number sequences. |
| 🧬 **Pattern Matching** | Spatial Logic | Identify the missing segment in progressive geometric patterns. |
| ⚡ **Memory Flash** | Short-Term Memory | Recall positions, sequences, or symbols flashed briefly on screen. |
| 🔄 **Shape Rotation** | Mental Rotation | Match target geometries subjected to 2D rotations and reflections. |

---

## 🕹 Game Mechanics & Scoring Formula

```
           [ Start 30s Countdown ]
                      │
                      ▼
             [ Answer Question ]
              ╱               ╲
      [ Correct ]            [ Wrong ]
          │                      │
    +1 Score Point         -1s Penalty (-5s in Hardcore)
    +1 Streak Combo        Streak Reset to 0
    Time Refill/Combo FX   Screen Shake & Penalty FX
              │                      │
              └──────►  ◄────────────┘
                        │
                  [ Time Left? ]
                   /          \
                (Yes)         (No)
                 │              │
           Next Puzzle     [ Game Over ]
                                │
                        Calculate Final IQ
```

### IQ Scoring Engine (`IqCalculator`)
The final IQ rating is generated dynamically by factoring:
- **Baseline IQ:** 85-100 base bracket
- **Accuracy Ratio:** Correct vs. wrong inputs
- **Peak Streak (Combo Factor):** Reward for sustained focus
- **Mode Multiplier:** Bonus scale for Hardcore execution

---

## 🛠 Tech Stack & Architecture

### Tech Stack
- **Framework:** [Flutter](https://flutter.dev) (v3.x / Dart 3.x)
- **State Management:** [Riverpod 3](https://riverpod.dev) (`flutter_riverpod`)
- **Animations:** [flutter_animate](https://pub.dev/packages/flutter_animate)
- **Audio Engine:** [audioplayers](https://pub.dev/packages/audioplayers)
- **Fonts:** [google_fonts](https://pub.dev/packages/google_fonts)
- **Persistence:** [shared_preferences](https://pub.dev/packages/shared_preferences)
- **Ads & Monetization:** [google_mobile_ads](https://pub.dev/packages/google_mobile_ads), [in_app_purchase](https://pub.dev/packages/in_app_purchase)

### Project Structure
```text
lib/
├── app.dart                   # MaterialApp setup, routing & dark theme configuration
├── main.dart                  # App bootstrap, provider scope & service initialization
├── core/
│   ├── constants/             # App colors, neon themes, and typography constants
│   └── utils/                 # IqCalculator and timing utilities
├── domain/
│   ├── ad_manager.dart        # AdMob integration (Rewarded, Interstitial, Banner)
│   ├── game_provider.dart     # Riverpod state notifier managing active game loop
│   ├── iap_manager.dart       # StoreKit & Google Play In-App Purchase handlers
│   ├── models.dart            # PuzzleData, GameState, and Score models
│   ├── puzzle_engine.dart     # Procedural puzzle generators across 6 archetypes
│   └── stats_provider.dart    # User score history, records, and stats persistence
└── features/
    ├── home/                  # Title screen, mode selection & quick stats preview
    ├── game/                  # Game view, countdown HUD, combo counter & puzzle renderers
    └── results/               # IQ breakdown, performance charts, revive options & sharing
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.9.2` or later)
- Dart SDK (`^3.9.2`)
- Android Studio / Xcode for device simulation and deployment

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/fractor16/iq_duel.git
   cd iq_duel
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run on connected emulator or device:**
   ```bash
   flutter run
   ```

---

## 💰 Monetization & Configuration

### AdMob Setup
The project comes pre-configured with Google test ad units. For production release:
1. Register your app in the [Google AdMob Console](https://admob.google.com).
2. Update your App ID in:
   - **Android:** `android/app/src/main/AndroidManifest.xml`
   - **iOS:** `ios/Runner/Info.plist`
3. Replace the ad unit identifiers in `lib/domain/ad_manager.dart`.

### In-App Purchases (IAP)
Configured non-consumable product IDs:
- `remove_ads_lifetime` – Permanently eliminates interstitials and banners.
- `hardcore_mode_unlock` – Instantly unlocks Hardcore Mode without milestone requirements.

---

## 📱 Release & Build

To generate an optimized release build for Android:
```bash
# Generate Android App Bundle (AAB) for Google Play
flutter build appbundle --release
```

For iOS:
```bash
# Generate iOS release bundle
flutter build ipa --release
```

---

## 🤝 Contributing

Contributions, feedback, and pull requests are welcome!
1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.