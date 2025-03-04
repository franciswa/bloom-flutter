import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Text styles
class TextStyles {
  /// Private constructor to prevent instantiation
  const TextStyles._();

  // Font families
  /// Primary font family
  static const String primaryFontFamily = 'Poppins';

  /// Secondary font family
  static const String secondaryFontFamily = 'Roboto';

  // Headline styles
  /// Headline 1 style
  static const TextStyle headline1 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  /// Headline 2 style
  static const TextStyle headline2 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  /// Headline 3 style
  static const TextStyle headline3 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  /// Headline 4 style
  static const TextStyle headline4 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.25,
    color: AppColors.textPrimary,
  );

  /// Headline 5 style
  static const TextStyle headline5 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  /// Headline 6 style
  static const TextStyle headline6 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  // Subtitle styles
  /// Subtitle 1 style
  static const TextStyle subtitle1 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.15,
    color: AppColors.textSecondary,
  );

  /// Subtitle 2 style
  static const TextStyle subtitle2 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.1,
    color: AppColors.textSecondary,
  );

  // Body styles
  /// Body 1 style
  static const TextStyle body1 = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  /// Body 2 style
  static const TextStyle body2 = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    color: AppColors.textPrimary,
  );

  // Button styles
  /// Button style
  static const TextStyle button = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.25,
    color: AppColors.onPrimary,
  );

  // Caption styles
  /// Caption style
  static const TextStyle caption = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
  );

  // Overline styles
  /// Overline style
  static const TextStyle overline = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 10,
    fontWeight: FontWeight.normal,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
  );

  // Label styles
  /// Label style
  static const TextStyle label = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.25,
    color: AppColors.textPrimary,
  );

  // Input styles
  /// Input style
  static const TextStyle input = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  /// Input hint style
  static const TextStyle inputHint = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    color: AppColors.textHint,
  );

  /// Input error style
  static const TextStyle inputError = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    color: AppColors.error,
  );

  // Link styles
  /// Link style
  static const TextStyle link = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  // Tab styles
  /// Tab style
  static const TextStyle tab = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.25,
    color: AppColors.primary,
  );

  // Chip styles
  /// Chip style
  static const TextStyle chip = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    color: AppColors.textPrimary,
  );

  // Dialog styles
  /// Dialog title style
  static const TextStyle dialogTitle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  /// Dialog content style
  static const TextStyle dialogContent = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  /// Dialog button style
  static const TextStyle dialogButton = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.25,
    color: AppColors.primary,
  );

  // Snackbar styles
  /// Snackbar style
  static const TextStyle snackbar = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    color: Colors.white,
  );

  // Tooltip styles
  /// Tooltip style
  static const TextStyle tooltip = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    color: Colors.white,
  );

  // Card styles
  /// Card title style
  static const TextStyle cardTitle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  /// Card subtitle style
  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.1,
    color: AppColors.textSecondary,
  );

  /// Card content style
  static const TextStyle cardContent = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    color: AppColors.textPrimary,
  );

  // List styles
  /// List title style
  static const TextStyle listTitle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  /// List subtitle style
  static const TextStyle listSubtitle = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.1,
    color: AppColors.textSecondary,
  );

  /// List content style
  static const TextStyle listContent = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    color: AppColors.textPrimary,
  );
}
