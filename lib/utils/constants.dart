// =============================================================================
// Constants - App-wide constants for theming and styling
// =============================================================================

import 'package:flutter/material.dart';

/// App-wide styling constants
class AppConstants {
  // Padding and spacing values
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border radius values
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;

  // Card elevation
  static const double cardElevation = 2.0;
  static const double cardElevationHigh = 4.0;

  // Animation durations
  static const Duration animationShort = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationLong = Duration(milliseconds: 500);
}

/// Light theme colors
class LightThemeColors {
  static const Color primary = Color(0xFF6750A4); // Deep Purple
  static const Color secondary = Color(0xFF03DAC6); // Teal
  static const Color background = Color(0xFFF7F7F7);
  static const Color surface = Colors.white;
  static const Color card = Colors.white;
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF49454F);
  static const Color error = Color(0xFFB3261E);
  static const Color success = Color(0xFF4CAF50);
}

/// Dark theme colors
class DarkThemeColors {
  static const Color primary = Color(0xFFD0BCFF); // Deep Purple Accent
  static const Color secondary = Color(0xFF03DAC6); // Teal Accent
  static const Color background = Color(0xFF1C1B1F);
  static const Color surface = Color(0xFF2B2930);
  static const Color card = Color(0xFF2B2930);
  static const Color textPrimary = Color(0xFFE6E1E5);
  static const Color textSecondary = Color(0xFFCAC4D0);
  static const Color error = Color(0xFFF2B8B5);
  static const Color success = Color(0xFF81C784);
}

/// App theme data factory
class AppTheme {
  /// Creates the light theme
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: LightThemeColors.primary,
        secondary: LightThemeColors.secondary,
        surface: LightThemeColors.surface,
        error: LightThemeColors.error,
      ),
      scaffoldBackgroundColor: LightThemeColors.background,
      cardTheme: CardTheme(
        color: LightThemeColors.card,
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: LightThemeColors.background,
        foregroundColor: LightThemeColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: LightThemeColors.primary,
        foregroundColor: Colors.white,
        elevation: AppConstants.cardElevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LightThemeColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: LightThemeColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LightThemeColors.primary,
          foregroundColor: Colors.white,
          elevation: AppConstants.cardElevation,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: LightThemeColors.primary,
        ),
      ),
    );
  }

  /// Creates the dark theme
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: DarkThemeColors.primary,
        secondary: DarkThemeColors.secondary,
        surface: DarkThemeColors.surface,
        error: DarkThemeColors.error,
      ),
      scaffoldBackgroundColor: DarkThemeColors.background,
      cardTheme: CardTheme(
        color: DarkThemeColors.card,
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: DarkThemeColors.background,
        foregroundColor: DarkThemeColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: DarkThemeColors.primary,
        foregroundColor: DarkThemeColors.background,
        elevation: AppConstants.cardElevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DarkThemeColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: DarkThemeColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DarkThemeColors.primary,
          foregroundColor: DarkThemeColors.background,
          elevation: AppConstants.cardElevation,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DarkThemeColors.primary,
        ),
      ),
    );
  }
}
