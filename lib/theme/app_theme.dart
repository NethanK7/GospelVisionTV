import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Core Palette - Astra Update
  static const Color deepObsidian = Color(0xFF050505); // Pure deep obsidian
  static const Color primaryOrange = Color(0xFFEA5400); // Astra Orange
  static const Color primaryGold = Color(0xFFF29200); // Astra Gold
  static const Color offWhite = Color(0xFFF5F5F1);
  static const Color textGrey = Color(0xFFB3B3B3);
  static const Color textDimGrey = Color(0xFF808080);

  static const Color accentRed = Color(0xFFE50914);
  static const Color accentGreen = Color(0xFF46D369);

  static const Color cardDark = Color(
    0xFF151515,
  ); // Slightly elevated from obsidian
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Gradients
  static const LinearGradient brandGradient = LinearGradient(
    colors: [primaryGold, primaryOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient cardGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [Colors.black.withValues(alpha: 0.9), Colors.transparent],
  );

  // ShaderMask logic for Shimmering Text
  static Widget shimmeringText(Widget textWidget) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [primaryGold, Colors.white, primaryGold],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment(-1.0, -0.5),
          end: Alignment(1.0, 0.5),
        ).createShader(bounds);
      },
      child: textWidget,
    );
  }

  static ThemeData get darkTheme {
    // Premium Typography
    final baseTextTheme = GoogleFonts.outfitTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryOrange,
      scaffoldBackgroundColor: deepObsidian,
      useMaterial3: true,

      // Page Transitions (Cinematic Zoom Fade)
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
        },
      ),

      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w900,
          color: offWhite,
          letterSpacing: -0.5,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: offWhite,
          letterSpacing: -0.5,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: offWhite,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: offWhite,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: textGrey),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: textGrey),
        bodySmall: baseTextTheme.bodySmall?.copyWith(color: textDimGrey),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryOrange,
        secondary: primaryGold,
        surface: deepObsidian,
        onPrimary: offWhite,
        onSurface: offWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      iconTheme: const IconThemeData(color: offWhite),
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.1),
      ),
    );
  }

  // Helper for generating the radial background decoration
  static BoxDecoration get radialBackground {
    return BoxDecoration(
      color: deepObsidian,
      gradient: RadialGradient(
        center: Alignment.topCenter,
        radius: 1.5,
        colors: [
          primaryOrange.withValues(alpha: 0.05), // 5% Soft Glow at top
          deepObsidian,
        ],
        stops: const [0.0, 0.7],
      ),
    );
  }
}
