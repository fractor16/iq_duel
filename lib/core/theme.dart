import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color neonPink = Color(0xFFFF007F);
  static const Color neonBlue = Color(0xFF00F0FF);
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color neonYellow = Color(0xFFFAED26);
  static const Color darkBg = Color(0xFF0B0C10);
  static const Color cardBg = Color(0xFF1F2833);
  static const Color textWhite = Color(0xFFC5C6C7);

  static ThemeData get neonTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      primaryColor: neonBlue,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            bodyLarge: const TextStyle(color: Colors.white),
            bodyMedium: const TextStyle(color: textWhite),
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonPink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
          elevation: 10,
          shadowColor: neonPink.withValues(alpha: 0.5),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
