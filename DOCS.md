# IQ Duel – 30 Second Brain Battle

## Folder Structure
- `lib/core/`: Contains app theme (Neon colors/fonts) and `IqCalculator` logic.
- `lib/domain/`: Riverpod providers (`GameProvider`, `AdManager`, `IapManager`, `StatsProvider`) and models. `PuzzleEngine` for procedural challenges.
- `lib/features/`: UI split by screens (`home`, `game`, `results`) with custom painters.
- `lib/app.dart & main.dart`: App bootstrap and initialization.

## Game Logic Explanation
- The game runs on a `Timer.periodic` for exactly 30 seconds (`GameProvider`).
- Submitting the correct answer grants `+1` score.
- Submitting a wrong answer triggers a time penalty of `-1s` (`-5s` in Hardcore mode) and resets the combo streak.
- IQ is calculated using `IqCalculator` based on: 
  - Accuracy (correct/wrong answers)
  - Combo factor (Max Streak)
  - Base difficulty multiplier.
- `PuzzleEngine` randomly selects from 6 mini-game archetypes, scaling difficulty based on current score. 

## AdMob Setup Guide
- The app uses test IDs from Google (`ca-app-pub-3940256099942544/...`).
- To go production: 
  1. Replace `_bannerAdUnitId` and others in `ad_manager.dart` with real IDs.
  2. Add your real app ID to `AndroidManifest.xml` and `Info.plist`.

## In-App Purchase Setup
- Defined identifiers: `remove_ads_lifetime`, `hardcore_mode_unlock`.
- Handled using `in_app_purchase` plugin. Set up these non-consumable IDs in Google Play Console / App Store Connect.

## Monetization
- **Rewarded Video:** Re-engage players after "Game Over" by offering `+10s`.
- **Interstitial:** Shows after the game ends.
- **IAP:** Removes interstitial and unlocks Hardcore mode early.

## Play Store Release Steps
1. Make sure to generate signing keys (`keytool`).
2. Update `version` in `pubspec.yaml` and `build.gradle`.
3. Run `flutter build appbundle`.
4. Upload `app-release.aab` to Google Play Console.
5. Setup the AdMob real IDs and IAP products.
