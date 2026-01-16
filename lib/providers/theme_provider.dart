// =============================================================================
// Theme Provider - Manages app theme (Light/Dark/System)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme mode options
enum AppThemeMode {
  system, // Follow system theme
  light,  // Always light
  dark,   // Always dark
}

/// Provider for managing app theme state
class ThemeProvider extends ChangeNotifier {
  // Storage key for theme preference
  static const String _themeKey = 'theme_mode';
  
  // Current theme mode
  AppThemeMode _themeMode = AppThemeMode.system;
  
  // Getter for current theme mode
  AppThemeMode get themeMode => _themeMode;

  /// Constructor - loads saved theme preference
  ThemeProvider() {
    _loadTheme();
  }

  /// Loads the saved theme preference from SharedPreferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      _themeMode = AppThemeMode.values[themeIndex];
      notifyListeners();
    } catch (e) {
      // If loading fails, use system default
      _themeMode = AppThemeMode.system;
    }
  }

  /// Saves the current theme preference to SharedPreferences
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, _themeMode.index);
    } catch (e) {
      // Silently fail if saving doesn't work
      debugPrint('Failed to save theme preference: $e');
    }
  }

  /// Sets the theme mode and saves the preference
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      await _saveTheme();
    }
  }

  /// Gets the Flutter ThemeMode based on current setting
  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  /// Returns the display name for the current theme mode
  String get themeModeDisplayName {
    switch (_themeMode) {
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }

  /// Cycles through theme modes (for quick toggle)
  Future<void> cycleTheme() async {
    final nextIndex = (_themeMode.index + 1) % AppThemeMode.values.length;
    await setThemeMode(AppThemeMode.values[nextIndex]);
  }
}
