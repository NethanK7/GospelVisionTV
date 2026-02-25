import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryGold = Color(0xFFE8B931); // Premium gold accent
  static const Color primaryOrange = Color(0xFFF37A20);
  static const Color primaryDark = Color(0xFF141414);
  static const Color cardDark = Color(0xFF1A1A1A);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFFB3B3B3);
  static const Color textDimGrey = Color(0xFF808080);
  static const Color accentRed = Color(0xFFE50914); // Netflix-style red for Live
  static const Color accentGreen = Color(0xFF46D369); // Match percentage green

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.center,
    colors: [Colors.black, Colors.transparent],
    stops: [0.0, 0.5],
  );

  static LinearGradient cardGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Colors.black.withValues(alpha: 0.9),
      Colors.transparent,
    ],
  );

  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryOrange,
      scaffoldBackgroundColor: primaryDark,
      useMaterial3: true,
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w900,
          color: textWhite,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: textWhite,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: textWhite,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: textWhite,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: textGrey,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: textGrey,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          color: textDimGrey,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryOrange,
        secondary: primaryGold,
        surface: primaryDark,
        onPrimary: textWhite,
        onSurface: textWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      iconTheme: const IconThemeData(color: textWhite),
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.1),
      ),
    );
  }
}
