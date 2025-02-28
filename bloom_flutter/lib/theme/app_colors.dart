import 'package:flutter/material.dart';

/// App colors
class AppColors {
  /// Private constructor to prevent instantiation
  const AppColors._();

  // Primary colors
  /// Primary color
  static const Color primary = Color(0xFF6200EE);

  /// Primary variant color
  static const Color primaryVariant = Color(0xFF3700B3);

  /// Primary light color
  static const Color primaryLight = Color(0xFFBB86FC);

  // Secondary colors
  /// Secondary color
  static const Color secondary = Color(0xFF03DAC6);

  /// Secondary variant color
  static const Color secondaryVariant = Color(0xFF018786);

  /// Secondary light color
  static const Color secondaryLight = Color(0xFFCEFAF8);

  // Tertiary colors
  /// Tertiary color
  static const Color tertiary = Color(0xFFFF9800);

  /// Tertiary variant color
  static const Color tertiaryVariant = Color(0xFFF57C00);

  /// Tertiary light color
  static const Color tertiaryLight = Color(0xFFFFE0B2);

  // Background colors
  /// Background color
  static const Color background = Color(0xFFF5F5F5);

  /// Surface color
  static const Color surface = Colors.white;

  /// Card color
  static const Color card = Colors.white;

  /// Dialog color
  static const Color dialog = Colors.white;

  // Text colors
  /// Primary text color
  static const Color textPrimary = Color(0xFF212121);

  /// Secondary text color
  static const Color textSecondary = Color(0xFF757575);

  /// Hint text color
  static const Color textHint = Color(0xFF9E9E9E);

  /// Disabled text color
  static const Color textDisabled = Color(0xFFBDBDBD);

  /// On primary text color
  static const Color onPrimary = Colors.white;

  /// On secondary text color
  static const Color onSecondary = Colors.black;

  /// On background text color
  static const Color onBackground = Color(0xFF212121);

  /// On surface text color
  static const Color onSurface = Color(0xFF212121);

  /// On error text color
  static const Color onError = Colors.white;

  // Status colors
  /// Error color
  static const Color error = Color(0xFFB00020);

  /// Success color
  static const Color success = Color(0xFF4CAF50);

  /// Warning color
  static const Color warning = Color(0xFFFFC107);

  /// Info color
  static const Color info = Color(0xFF2196F3);

  // Divider colors
  /// Divider color
  static const Color divider = Color(0xFFE0E0E0);

  /// Border color
  static const Color border = Color(0xFFE0E0E0);

  // Input colors
  /// Input background color
  static const Color inputBackground = Color(0xFFF5F5F5);

  /// Input border color
  static const Color inputBorder = Color(0xFFE0E0E0);

  /// Input focus color
  static const Color inputFocus = primary;

  /// Input error color
  static const Color inputError = error;

  // Button colors
  /// Button primary color
  static const Color buttonPrimary = primary;

  /// Button secondary color
  static const Color buttonSecondary = secondary;

  /// Button tertiary color
  static const Color buttonTertiary = tertiary;

  /// Button disabled color
  static const Color buttonDisabled = Color(0xFFBDBDBD);

  // Icon colors
  /// Icon primary color
  static const Color iconPrimary = Color(0xFF212121);

  /// Icon secondary color
  static const Color iconSecondary = Color(0xFF757575);

  /// Icon tertiary color
  static const Color iconTertiary = Color(0xFF9E9E9E);

  /// Icon disabled color
  static const Color iconDisabled = Color(0xFFBDBDBD);

  // Overlay colors
  /// Overlay color
  static const Color overlay = Color(0x80000000);

  /// Scrim color
  static const Color scrim = Color(0x99000000);

  // Compatibility colors
  /// Very low compatibility color
  static const Color compatibilityVeryLow = Color(0xFFF44336);

  /// Low compatibility color
  static const Color compatibilityLow = Color(0xFFFF9800);

  /// Moderate compatibility color
  static const Color compatibilityModerate = Color(0xFFFFC107);

  /// High compatibility color
  static const Color compatibilityHigh = Color(0xFF4CAF50);

  /// Very high compatibility color
  static const Color compatibilityVeryHigh = Color(0xFF2196F3);

  // Astrological colors
  /// Fire element color
  static const Color elementFire = Color(0xFFF44336);

  /// Earth element color
  static const Color elementEarth = Color(0xFF795548);

  /// Air element color
  static const Color elementAir = Color(0xFFFFEB3B);

  /// Water element color
  static const Color elementWater = Color(0xFF2196F3);

  /// Sun color
  static const Color planetSun = Color(0xFFFF9800);

  /// Moon color
  static const Color planetMoon = Color(0xFFE0E0E0);

  /// Mercury color
  static const Color planetMercury = Color(0xFF9E9E9E);

  /// Venus color
  static const Color planetVenus = Color(0xFFE91E63);

  /// Mars color
  static const Color planetMars = Color(0xFFF44336);

  /// Jupiter color
  static const Color planetJupiter = Color(0xFF9C27B0);

  /// Saturn color
  static const Color planetSaturn = Color(0xFF795548);

  /// Uranus color
  static const Color planetUranus = Color(0xFF00BCD4);

  /// Neptune color
  static const Color planetNeptune = Color(0xFF2196F3);

  /// Pluto color
  static const Color planetPluto = Color(0xFF607D8B);

  // Gradient colors
  /// Primary gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Secondary gradient
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Tertiary gradient
  static const LinearGradient tertiaryGradient = LinearGradient(
    colors: [tertiary, tertiaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Success gradient
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF388E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Error gradient
  static const LinearGradient errorGradient = LinearGradient(
    colors: [error, Color(0xFF880E4F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Warning gradient
  static const LinearGradient warningGradient = LinearGradient(
    colors: [warning, Color(0xFFFFA000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Info gradient
  static const LinearGradient infoGradient = LinearGradient(
    colors: [info, Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Compatibility gradient
  static const LinearGradient compatibilityGradient = LinearGradient(
    colors: [compatibilityVeryLow, compatibilityVeryHigh],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
