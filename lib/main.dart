import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Mobile Ads
  MobileAds.instance.initialize();

  // Initialize SharedPreferences just to trigger load
  await SharedPreferences.getInstance();

  // Initialize In-App Purchases connection
  InAppPurchase.instance.isAvailable();

  runApp(const ProviderScope(child: IqDuelApp()));
}
