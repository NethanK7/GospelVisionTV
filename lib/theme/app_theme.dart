import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryOrange = Color(
    0xFFF37A20,
  ); // Extracted from GospelVision.tv logo roughly
  static const Color primaryDark = Color(
    0xFF141414,
  ); // Netflix-style dark background
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFFB3B3B3); // Standard subtitle grey

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryOrange,
      scaffoldBackgroundColor: primaryDark,
      useMaterial3: true,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: primaryOrange,
        secondary: primaryOrange,
        surface: primaryDark,
        background: primaryDark,
        onPrimary: textWhite,
        onSurface: textWhite,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textWhite, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: textWhite, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: textWhite, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textWhite),
        bodyMedium: TextStyle(color: textGrey),
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textWhite),
        titleTextStyle: TextStyle(
          color: textWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedItemColor: primaryOrange,
        unselectedItemColor: textGrey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 8,
      ),

      // Navigation Rail (Web)
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: Colors.black,
        selectedIconTheme: IconThemeData(color: primaryOrange),
        unselectedIconTheme: IconThemeData(color: textGrey),
        selectedLabelTextStyle: TextStyle(color: primaryOrange),
        unselectedLabelTextStyle: TextStyle(color: textGrey),
      ),
    );
  }
}
