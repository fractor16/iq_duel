import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'features/home/home_screen.dart';

class IqDuelApp extends ConsumerWidget {
  const IqDuelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'IQ Duel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.neonTheme,
      home: const HomeScreen(),
    );
  }
}
