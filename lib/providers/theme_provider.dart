import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_settings.dart' as models;
import '../services/service_registry.dart';

/// Theme provider
class ThemeProvider extends ChangeNotifier {
  /// Shared preferences key
  static const String _themePreferenceKey = 'theme_mode';

  /// Theme mode
  ThemeMode _themeMode = ThemeMode.system;

  /// Is loading
  bool _isLoading = false;

  /// Error message
  String? _errorMessage;

  /// User ID
  String? _userId;

  /// Creates a new [ThemeProvider] instance
  ThemeProvider() {
    _loadThemeMode();
  }

  /// Load theme mode
  Future<void> _loadThemeMode() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final themeValue = prefs.getString(_themePreferenceKey);

      if (themeValue != null) {
        _themeMode = _getThemeModeFromString(themeValue);
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get theme mode from string
  ThemeMode _getThemeModeFromString(String themeValue) {
    switch (themeValue) {
      case 'system':
        return ThemeMode.system;
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Get theme mode string
  String _getThemeModeString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }

  /// Get theme mode
  ThemeMode get themeMode => _themeMode;

  /// Is loading
  bool get isLoading => _isLoading;

  /// Error message
  String? get errorMessage => _errorMessage;

  /// Is light mode
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Is dark mode
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Is system mode
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (_themeMode == themeMode) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Save to shared preferences for non-logged in users
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themePreferenceKey, _getThemeModeString(themeMode));

      // If user is logged in, save to user settings
      if (_userId != null) {
        await ServiceRegistry.userSettingsService.updateThemeMode(
          _userId!,
          getThemeModeForUserSettings(),
        );
      }

      _themeMode = themeMode;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set light mode
  Future<void> setLightMode() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Set dark mode
  Future<void> setDarkMode() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Set system mode
  Future<void> setSystemMode() async {
    await setThemeMode(ThemeMode.system);
  }

  /// Toggle theme mode
  Future<void> toggleThemeMode() async {
    switch (_themeMode) {
      case ThemeMode.system:
        await setLightMode();
        break;
      case ThemeMode.light:
        await setDarkMode();
        break;
      case ThemeMode.dark:
        await setSystemMode();
        break;
    }
  }

  /// Update from user settings
  Future<void> updateFromUserSettings(models.UserSettings settings) async {
    _userId = settings.userId;
    
    ThemeMode newThemeMode;

    switch (settings.themeMode) {
      case models.ThemeMode.system:
        newThemeMode = ThemeMode.system;
        break;
      case models.ThemeMode.light:
        newThemeMode = ThemeMode.light;
        break;
      case models.ThemeMode.dark:
        newThemeMode = ThemeMode.dark;
        break;
    }

    await setThemeMode(newThemeMode);
  }

  /// Get theme mode for user settings
  models.ThemeMode getThemeModeForUserSettings() {
    switch (_themeMode) {
      case ThemeMode.system:
        return models.ThemeMode.system;
      case ThemeMode.light:
        return models.ThemeMode.light;
      case ThemeMode.dark:
        return models.ThemeMode.dark;
    }
  }

  /// Set user ID
  void setUserId(String? userId) {
    _userId = userId;
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
