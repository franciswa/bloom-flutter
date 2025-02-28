import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'text_styles.dart';

/// App theme
class AppTheme {
  /// Private constructor to prevent instantiation
  const AppTheme._();

  /// Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      // Color scheme
      primaryColor: AppColors.primary,
      primaryColorLight: AppColors.primaryLight,
      primaryColorDark: AppColors.primaryVariant,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryVariant,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryVariant,
        tertiary: AppColors.tertiary,
        tertiaryContainer: AppColors.tertiaryVariant,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onSecondary,
        onSurface: AppColors.onSurface,
        onBackground: AppColors.onBackground,
        onError: AppColors.onError,
        brightness: Brightness.light,
      ),
      
      // Scaffold background color
      scaffoldBackgroundColor: AppColors.background,
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyles.headline6,
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: TextStyles.caption,
        unselectedLabelStyle: TextStyles.caption,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Tab bar theme
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: TextStyles.tab,
        unselectedLabelStyle: TextStyles.tab,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      
      // Card theme
      cardTheme: const CardTheme(
        color: AppColors.card,
        elevation: 2,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      
      // Dialog theme
      dialogTheme: const DialogTheme(
        backgroundColor: AppColors.dialog,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        titleTextStyle: TextStyles.dialogTitle,
        contentTextStyle: TextStyles.dialogContent,
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          textStyle: TextStyles.button,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: TextStyles.button,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(
            color: AppColors.primary,
            width: 1,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: TextStyles.button,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        contentPadding: const EdgeInsets.all(16),
        hintStyle: TextStyles.inputHint,
        errorStyle: TextStyles.inputError,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.inputBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.inputBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
      ),
      
      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.buttonDisabled;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(AppColors.onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: const BorderSide(
          color: AppColors.inputBorder,
          width: 1.5,
        ),
      ),
      
      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.buttonDisabled;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return AppColors.inputBorder;
        }),
      ),
      
      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.buttonDisabled;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return Colors.white;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.buttonDisabled.withOpacity(0.5);
          }
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary.withOpacity(0.5);
          }
          return AppColors.inputBorder;
        }),
      ),
      
      // Slider theme
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.inputBorder,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary,
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: TextStyles.caption,
      ),
      
      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        circularTrackColor: AppColors.inputBackground,
        linearTrackColor: AppColors.inputBackground,
      ),
      
      // Tooltip theme
      tooltipTheme: const TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.textPrimary,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        textStyle: TextStyles.tooltip,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      
      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.inputBackground,
        disabledColor: AppColors.buttonDisabled,
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.secondary,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        labelStyle: TextStyles.chip,
        secondaryLabelStyle: TextStyles.chip.copyWith(
          color: AppColors.onSecondary,
        ),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.inputBorder,
          ),
        ),
      ),
      
      // Snackbar theme
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: TextStyles.snackbar,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Bottom sheet theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
      ),
      
      // List tile theme
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        dense: false,
        horizontalTitleGap: 16,
        minLeadingWidth: 40,
        iconColor: AppColors.iconPrimary,
        textColor: AppColors.textPrimary,
      ),
      
      // Popup menu theme
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyles.body2,
      ),
      
      // Drawer theme
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.surface,
        elevation: 16,
        scrimColor: AppColors.scrim,
      ),
      
      // Bottom app bar theme
      bottomAppBarTheme: const BottomAppBarTheme(
        color: AppColors.surface,
        elevation: 8,
        shape: CircularNotchedRectangle(),
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 6,
        highlightElevation: 12,
        shape: CircleBorder(),
      ),
      
      // Typography
      textTheme: const TextTheme(
        displayLarge: TextStyles.headline1,
        displayMedium: TextStyles.headline2,
        displaySmall: TextStyles.headline3,
        headlineMedium: TextStyles.headline4,
        headlineSmall: TextStyles.headline5,
        titleLarge: TextStyles.headline6,
        titleMedium: TextStyles.subtitle1,
        titleSmall: TextStyles.subtitle2,
        bodyLarge: TextStyles.body1,
        bodyMedium: TextStyles.body2,
        labelLarge: TextStyles.button,
        bodySmall: TextStyles.caption,
        labelSmall: TextStyles.overline,
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: AppColors.iconPrimary,
        size: 24,
      ),
      
      // Primary icon theme
      primaryIconTheme: const IconThemeData(
        color: AppColors.onPrimary,
        size: 24,
      ),
    );
  }

  /// Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      // Color scheme
      primaryColor: AppColors.primaryLight,
      primaryColorLight: AppColors.primary,
      primaryColorDark: AppColors.primaryVariant,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryLight,
        primaryContainer: AppColors.primaryVariant,
        secondary: AppColors.secondaryLight,
        secondaryContainer: AppColors.secondaryVariant,
        tertiary: AppColors.tertiaryLight,
        tertiaryContainer: AppColors.tertiaryVariant,
        surface: Colors.grey[900]!,
        background: Colors.grey[850]!,
        error: AppColors.error,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
        brightness: Brightness.dark,
      ),
      
      // Scaffold background color
      scaffoldBackgroundColor: Colors.grey[850],
      
      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyles.headline6.copyWith(color: Colors.white),
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey[900],
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: TextStyles.caption,
        unselectedLabelStyle: TextStyles.caption,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Tab bar theme
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.primaryLight,
        unselectedLabelColor: Colors.grey[400],
        labelStyle: TextStyles.tab,
        unselectedLabelStyle: TextStyles.tab,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      
      // Card theme
      cardTheme: CardTheme(
        color: Colors.grey[900],
        elevation: 2,
        margin: const EdgeInsets.all(8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      
      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: Colors.grey[900],
        elevation: 24,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        titleTextStyle: TextStyles.dialogTitle.copyWith(color: Colors.white),
        contentTextStyle: TextStyles.dialogContent.copyWith(color: Colors.white),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.black,
          textStyle: TextStyles.button,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          textStyle: TextStyles.button,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: AppColors.primaryLight,
            width: 1,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          textStyle: TextStyles.button,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[800],
        contentPadding: const EdgeInsets.all(16),
        hintStyle: TextStyles.inputHint.copyWith(color: Colors.grey[400]),
        errorStyle: TextStyles.inputError,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[700]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[700]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primaryLight,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
      ),
      
      // Typography
      textTheme: TextTheme(
        displayLarge: TextStyles.headline1.copyWith(color: Colors.white),
        displayMedium: TextStyles.headline2.copyWith(color: Colors.white),
        displaySmall: TextStyles.headline3.copyWith(color: Colors.white),
        headlineMedium: TextStyles.headline4.copyWith(color: Colors.white),
        headlineSmall: TextStyles.headline5.copyWith(color: Colors.white),
        titleLarge: TextStyles.headline6.copyWith(color: Colors.white),
        titleMedium: TextStyles.subtitle1.copyWith(color: Colors.grey[300]),
        titleSmall: TextStyles.subtitle2.copyWith(color: Colors.grey[300]),
        bodyLarge: TextStyles.body1.copyWith(color: Colors.white),
        bodyMedium: TextStyles.body2.copyWith(color: Colors.white),
        labelLarge: TextStyles.button,
        bodySmall: TextStyles.caption.copyWith(color: Colors.grey[300]),
        labelSmall: TextStyles.overline.copyWith(color: Colors.grey[300]),
      ),
    );
  }
}
