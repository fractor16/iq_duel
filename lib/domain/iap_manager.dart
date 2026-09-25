import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'stats_provider.dart';

final iapManagerProvider = Provider<IapManager>((ref) {
  return IapManager(ref);
});

class IapManager {
  final Ref ref;
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  static const String removeAdsId = 'remove_ads_lifetime';
  static const String hardcoreModeId = 'hardcore_mode_unlock';

  IapManager(this.ref) {
    _initIap();
  }

  void _initIap() {
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        // Handle error
      },
    );
  }

  Future<void> buyRemoveAds() async {
    final ProductDetailsResponse response = await _iap.queryProductDetails(
      {removeAdsId}.toSet(),
    );
    if (response.notFoundIDs.isEmpty) {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: response.productDetails.first,
      );
      _iap.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Future<void> buyHardcoreMode() async {
    final ProductDetailsResponse response = await _iap.queryProductDetails(
      {hardcoreModeId}.toSet(),
    );
    if (response.notFoundIDs.isEmpty) {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: response.productDetails.first,
      );
      _iap.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        if (purchaseDetails.productID == removeAdsId) {
          ref.read(statsProvider.notifier).setAdsRemoved(true);
        } else if (purchaseDetails.productID == hardcoreModeId) {
          // Hardcore naturally unlocked or via IAP
          // Update statsProvider
        }
        if (purchaseDetails.pendingCompletePurchase) {
          _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void dispose() {
    _subscription.cancel();
  }
}
