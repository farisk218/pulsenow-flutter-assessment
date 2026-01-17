import 'package:flutter/material.dart';
import 'constant/pulse_now_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _buildLightTheme();
  static ThemeData get darkTheme => _buildDarkTheme();

  static ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: PulseNowColors.lightBackground,
      fontFamily: PulseNowTextTheme.fontFamily,
      colorScheme: const ColorScheme.light(
        primary: PulseNowColors.primary,
        secondary: PulseNowColors.secondary,
        surface: PulseNowColors.lightSurface,
        error: PulseNowColors.danger,
        onPrimary: PulseNowColors.lightBackground,
        onSecondary: PulseNowColors.lightBackground,
        onSurface: PulseNowColors.lightTextPrimary,
        onError: PulseNowColors.lightBackground,
      ),
      textTheme: PulseNowTextTheme.getLightTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: PulseNowColors.lightSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: PulseNowTextTheme.fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: PulseNowColors.lightTextPrimary,
        ),
        iconTheme: IconThemeData(
          color: PulseNowColors.lightTextPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PulseNowColors.primary,
          foregroundColor: PulseNowColors.lightBackground,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(
            fontFamily: PulseNowTextTheme.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          elevation: 8,
          shadowColor: const Color(0x6600E0FF),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PulseNowColors.lightTextPrimary,
          side: const BorderSide(color: PulseNowColors.lightBorderStrong),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(
            fontFamily: PulseNowTextTheme.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: PulseNowColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: PulseNowColors.lightBorderSubtle),
        ),
        margin: EdgeInsets.zero,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PulseNowColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: PulseNowColors.lightBorderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: PulseNowColors.lightBorderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: PulseNowColors.primary, width: 1.5),
        ),
        hintStyle: const TextStyle(color: PulseNowColors.lightTextMuted),
      ),
      dividerTheme: const DividerThemeData(
        color: PulseNowColors.lightBorderSubtle,
        thickness: 0.5,
      ),
    );
  }

  static ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: PulseNowColors.darkBackground,
      fontFamily: PulseNowTextTheme.fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: PulseNowColors.primary,
        secondary: PulseNowColors.secondary,
        surface: PulseNowColors.darkSurface,
        error: PulseNowColors.danger,
        onPrimary: PulseNowColors.darkBackground,
        onSecondary: PulseNowColors.darkBackground,
        onSurface: PulseNowColors.darkTextPrimary,
        onError: PulseNowColors.darkTextPrimary,
      ),
      textTheme: PulseNowTextTheme.getDarkTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: PulseNowColors.darkSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: PulseNowTextTheme.fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: PulseNowColors.darkTextPrimary,
        ),
        iconTheme: IconThemeData(
          color: PulseNowColors.darkTextPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PulseNowColors.primary,
          foregroundColor: PulseNowColors.darkBackground,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(
            fontFamily: PulseNowTextTheme.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          elevation: 8,
          shadowColor: const Color(0x6600E0FF),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PulseNowColors.darkTextPrimary,
          side: const BorderSide(color: PulseNowColors.darkBorderStrong),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(
            fontFamily: PulseNowTextTheme.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: PulseNowColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: PulseNowColors.darkBorderSubtle),
        ),
        margin: EdgeInsets.zero,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PulseNowColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: PulseNowColors.darkBorderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: PulseNowColors.darkBorderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: PulseNowColors.primary, width: 1.5),
        ),
        hintStyle: const TextStyle(color: PulseNowColors.darkTextMuted),
      ),
      dividerTheme: const DividerThemeData(
        color: PulseNowColors.darkBorderSubtle,
        thickness: 0.5,
      ),
    );
  }
}
