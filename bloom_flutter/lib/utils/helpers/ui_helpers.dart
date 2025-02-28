import 'package:flutter/material.dart';
import '../error_handling.dart';

/// UI helpers
class UIHelpers {
  /// Private constructor to prevent instantiation
  const UIHelpers._();

  /// Screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Screen padding
  static EdgeInsets screenPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Screen safe area
  static EdgeInsets screenSafeArea(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Screen orientation
  static Orientation screenOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  /// Is portrait
  static bool isPortrait(BuildContext context) {
    return screenOrientation(context) == Orientation.portrait;
  }

  /// Is landscape
  static bool isLandscape(BuildContext context) {
    return screenOrientation(context) == Orientation.landscape;
  }

  /// Is mobile
  static bool isMobile(BuildContext context) {
    return screenWidth(context) < 600;
  }

  /// Is tablet
  static bool isTablet(BuildContext context) {
    return screenWidth(context) >= 600 && screenWidth(context) < 1200;
  }

  /// Is desktop
  static bool isDesktop(BuildContext context) {
    return screenWidth(context) >= 1200;
  }

  /// Responsive value
  static T responsiveValue<T>({
    required BuildContext context,
    required T mobile,
    required T tablet,
    required T desktop,
  }) {
    if (isDesktop(context)) {
      return desktop;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return mobile;
    }
  }

  /// Responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    return responsiveValue(
      context: context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(24),
      desktop: const EdgeInsets.all(32),
    );
  }

  /// Responsive margin
  static EdgeInsets responsiveMargin(BuildContext context) {
    return responsiveValue(
      context: context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(24),
      desktop: const EdgeInsets.all(32),
    );
  }

  /// Responsive border radius
  static BorderRadius responsiveBorderRadius(BuildContext context) {
    return BorderRadius.circular(
      responsiveValue(
        context: context,
        mobile: 8.0,
        tablet: 12.0,
        desktop: 16.0,
      ),
    );
  }

  /// Responsive font size
  static double responsiveFontSize(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    return responsiveValue(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Responsive icon size
  static double responsiveIconSize(BuildContext context) {
    return responsiveValue(
      context: context,
      mobile: 24.0,
      tablet: 28.0,
      desktop: 32.0,
    );
  }

  /// Responsive spacing
  static double responsiveSpacing(BuildContext context) {
    return responsiveValue(
      context: context,
      mobile: 8.0,
      tablet: 12.0,
      desktop: 16.0,
    );
  }

  /// Responsive width
  static double responsiveWidth(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    return responsiveValue(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Responsive height
  static double responsiveHeight(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    return responsiveValue(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Show snackbar
  static void showSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
    Color? backgroundColor,
    Color? textColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Show error snackbar
  static void showErrorSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    showSnackBar(
      context,
      message: message,
      duration: duration,
      action: action,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  /// Show success snackbar
  static void showSuccessSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    showSnackBar(
      context,
      message: message,
      duration: duration,
      action: action,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Show info snackbar
  static void showInfoSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    showSnackBar(
      context,
      message: message,
      duration: duration,
      action: action,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  /// Show warning snackbar
  static void showWarningSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    showSnackBar(
      context,
      message: message,
      duration: duration,
      action: action,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }

  /// Show error dialog
  static Future<void> showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return showAppDialog(
      context: context,
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonText),
        ),
      ],
    );
  }

  /// Get error message from error
  static String getErrorMessage(dynamic error) {
    return ErrorHandler.getErrorMessage(error);
  }

  /// Show dialog
  static Future<T?> showAppDialog<T>({
    required BuildContext context,
    required Widget title,
    required Widget content,
    List<Widget>? actions,
    bool barrierDismissible = true,
    Color? barrierColor,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      builder: (context) {
        return AlertDialog(
          title: title,
          content: content,
          actions: actions,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  /// Show confirmation dialog
  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool barrierDismissible = true,
    Color? confirmColor,
    Color? cancelColor,
  }) {
    return showAppDialog<bool>(
      context: context,
      title: Text(title),
      content: Text(message),
      barrierDismissible: barrierDismissible,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            foregroundColor: cancelColor,
          ),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: confirmColor,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }

  /// Show loading dialog
  static Future<void> showLoadingDialog({
    required BuildContext context,
    String message = 'Loading...',
    bool barrierDismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  /// Show bottom sheet
  static Future<T?> showAppBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool useSafeArea = false,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      builder: (context) {
        return child;
      },
    );
  }

  /// Show date picker
  static Future<DateTime?> showAppDatePicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? currentDate,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    SelectableDayPredicate? selectableDayPredicate,
    String? helpText,
    String? cancelText,
    String? confirmText,
    Locale? locale,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    TextDirection? textDirection,
    TransitionBuilder? builder,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    String? errorFormatText,
    String? errorInvalidText,
    String? fieldHintText,
    String? fieldLabelText,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      currentDate: currentDate,
      initialEntryMode: initialEntryMode,
      selectableDayPredicate: selectableDayPredicate,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      locale: locale,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      textDirection: textDirection,
      builder: builder,
      initialDatePickerMode: initialDatePickerMode,
      errorFormatText: errorFormatText,
      errorInvalidText: errorInvalidText,
      fieldHintText: fieldHintText,
      fieldLabelText: fieldLabelText,
    );
  }

  /// Show time picker
  static Future<TimeOfDay?> showAppTimePicker({
    required BuildContext context,
    required TimeOfDay initialTime,
    TransitionBuilder? builder,
    bool useRootNavigator = true,
    TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
    String? cancelText,
    String? confirmText,
    String? helpText,
    String? errorInvalidText,
    String? hourLabelText,
    String? minuteLabelText,
    RouteSettings? routeSettings,
    EntryModeChangeCallback? onEntryModeChanged,
    Offset? anchorPoint,
  }) {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: builder,
      useRootNavigator: useRootNavigator,
      initialEntryMode: initialEntryMode,
      cancelText: cancelText,
      confirmText: confirmText,
      helpText: helpText,
      errorInvalidText: errorInvalidText,
      hourLabelText: hourLabelText,
      minuteLabelText: minuteLabelText,
      routeSettings: routeSettings,
      onEntryModeChanged: onEntryModeChanged,
      anchorPoint: anchorPoint,
    );
  }

  /// Get status bar height
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// Get bottom navigation bar height
  static double getBottomNavigationBarHeight(BuildContext context) {
    return kBottomNavigationBarHeight;
  }

  /// Get app bar height
  static double getAppBarHeight() {
    return kToolbarHeight;
  }

  /// Get keyboard height
  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  /// Is keyboard visible
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  /// Hide keyboard
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Get theme
  static ThemeData getTheme(BuildContext context) {
    return Theme.of(context);
  }

  /// Get text theme
  static TextTheme getTextTheme(BuildContext context) {
    return Theme.of(context).textTheme;
  }

  /// Get color scheme
  static ColorScheme getColorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  /// Get primary color
  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).primaryColor;
  }

  /// Get accent color
  static Color getAccentColor(BuildContext context) {
    return Theme.of(context).colorScheme.secondary;
  }

  /// Get scaffold background color
  static Color getScaffoldBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  /// Get text color
  static Color getTextColor(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.color!;
  }

  /// Get brightness
  static Brightness getBrightness(BuildContext context) {
    return Theme.of(context).brightness;
  }

  /// Is dark mode
  static bool isDarkMode(BuildContext context) {
    return getBrightness(context) == Brightness.dark;
  }

  /// Is light mode
  static bool isLightMode(BuildContext context) {
    return getBrightness(context) == Brightness.light;
  }

  /// Get platform
  static TargetPlatform getPlatform(BuildContext context) {
    return Theme.of(context).platform;
  }

  /// Is iOS
  static bool isIOS(BuildContext context) {
    return getPlatform(context) == TargetPlatform.iOS;
  }

  /// Is Android
  static bool isAndroid(BuildContext context) {
    return getPlatform(context) == TargetPlatform.android;
  }

  /// Is web
  static bool isWeb() {
    return false;
  }

  /// Get device pixel ratio
  static double getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  /// Get text scale factor
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  /// Get navigation bar height
  static double getNavigationBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  /// Get safe area
  static EdgeInsets getSafeArea(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Get safe area top
  static double getSafeAreaTop(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// Get safe area bottom
  static double getSafeAreaBottom(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  /// Get safe area left
  static double getSafeAreaLeft(BuildContext context) {
    return MediaQuery.of(context).padding.left;
  }

  /// Get safe area right
  static double getSafeAreaRight(BuildContext context) {
    return MediaQuery.of(context).padding.right;
  }

  /// Get safe area horizontal
  static double getSafeAreaHorizontal(BuildContext context) {
    return MediaQuery.of(context).padding.left +
        MediaQuery.of(context).padding.right;
  }

  /// Get safe area vertical
  static double getSafeAreaVertical(BuildContext context) {
    return MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom;
  }

  /// Get safe area width
  static double getSafeAreaWidth(BuildContext context) {
    return screenWidth(context) - getSafeAreaHorizontal(context);
  }

  /// Get safe area height
  static double getSafeAreaHeight(BuildContext context) {
    return screenHeight(context) - getSafeAreaVertical(context);
  }

  /// Get message bubble max width
  static double getMessageBubbleMaxWidth(BuildContext context) {
    return screenWidth(context) * 0.75;
  }

  /// Get message input max height
  static double getMessageInputMaxHeight(BuildContext context) {
    return screenHeight(context) * 0.3;
  }
}
