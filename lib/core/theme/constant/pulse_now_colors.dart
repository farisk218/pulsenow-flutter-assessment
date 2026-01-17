import 'package:flutter/material.dart';

class PulseNowColors {
  // Primary colors (same for both themes)
  static const Color primary = Color(0xFF00E0FF);
  static const Color primarySoft = Color(0xFF0B1E26);
  static const Color secondary = Color(0xFF19FF9C);
  static const Color danger = Color(0xFFFF4B6B);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF020308);
  static const Color darkSurface = Color(0xFF050814);
  static const Color darkSurfaceAlt = Color(0xFF0A0F1F);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFA9B2C8);
  static const Color darkTextMuted = Color(0xFF6B7387);
  static const Color darkBorderSubtle = Color(0xFF1A2333);
  static const Color darkBorderStrong = Color(0xFF2A3B4F);

  // Light theme colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF5F7FA);
  static const Color lightSurfaceAlt = Color(0xFFE8ECF1);
  static const Color lightTextPrimary = Color(0xFF0A0F1F);
  static const Color lightTextSecondary = Color(0xFF6B7387);
  static const Color lightTextMuted = Color(0xFFA9B2C8);
  static const Color lightBorderSubtle = Color(0xFFE8ECF1);
  static const Color lightBorderStrong = Color(0xFFD1D9E6);

  // Market colors (same for both themes)
  static const Color positiveColor = Color(0xFF4CAF50); // Green
  static const Color negativeColor = Color(0xFFF44336); // Red
}

class PulseNowTextTheme {
  static const String fontFamily = 'Sora';

  static TextTheme getDarkTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: PulseNowColors.darkTextPrimary,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: PulseNowColors.darkTextPrimary,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: PulseNowColors.darkTextPrimary,
      ),
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: PulseNowColors.darkTextPrimary,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: PulseNowColors.darkTextPrimary,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: PulseNowColors.darkTextPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: PulseNowColors.darkTextPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: PulseNowColors.darkTextPrimary,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: PulseNowColors.darkTextPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: PulseNowColors.darkTextPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: PulseNowColors.darkTextSecondary,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: PulseNowColors.darkTextMuted,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: PulseNowColors.darkTextPrimary,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: PulseNowColors.darkTextSecondary,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: PulseNowColors.darkTextMuted,
      ),
    );
  }

  static TextTheme getLightTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: PulseNowColors.lightTextPrimary,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: PulseNowColors.lightTextPrimary,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: PulseNowColors.lightTextPrimary,
      ),
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: PulseNowColors.lightTextPrimary,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: PulseNowColors.lightTextPrimary,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: PulseNowColors.lightTextPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: PulseNowColors.lightTextPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: PulseNowColors.lightTextPrimary,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: PulseNowColors.lightTextPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: PulseNowColors.lightTextPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: PulseNowColors.lightTextSecondary,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: PulseNowColors.lightTextMuted,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: PulseNowColors.lightTextPrimary,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: PulseNowColors.lightTextSecondary,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: PulseNowColors.lightTextMuted,
      ),
    );
  }
}
