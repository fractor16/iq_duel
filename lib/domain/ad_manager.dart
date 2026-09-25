import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'stats_provider.dart';

final adManagerProvider = Provider<AdManager>((ref) {
  return AdManager(ref);
});

class AdManager {
  final Ref ref;
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  BannerAd? bannerAd;
  bool isBannerLoaded = false;

  // Test IDs
  static const String _bannerAdUnitId =
      'ca-app-pub-3232403057975372/9341258534';
  static const String _interstitialAdUnitId =
      'ca-app-pub-3232403057975372/4088602282';
  static const String _rewardedAdUnitId =
      'ca-app-pub-3232403057975372/4639596195';

  AdManager(this.ref) {
    _init();
  }

  void _init() {
    MobileAds.instance.initialize();
  }

  bool get _adsRemoved => ref.read(statsProvider).hasRemovedAds;

  void loadBannerAd(void Function() onAdLoaded) {
    if (_adsRemoved) return;
    bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBannerLoaded = true;
          onAdLoaded();
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void loadInterstitialAd() {
    if (_adsRemoved) return;
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null,
      ),
    );
  }

  void showInterstitialIfAvailable() {
    if (_interstitialAd != null && !_adsRemoved) {
      _interstitialAd!.show();
      _interstitialAd = null;
      loadInterstitialAd();
    }
  }

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (error) => _rewardedAd = null,
      ),
    );
  }

  void showRewardedAd(Function onRewarded) {
    if (_rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
          onRewarded();
        },
      );
      _rewardedAd = null;
      loadRewardedAd();
    } else {
      // Fallback if ad not ready
      onRewarded();
    }
  }

  void dispose() {
    bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
