import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';

/// Button type enum
enum ButtonType {
  /// Primary button
  primary,

  /// Secondary button
  secondary,

  /// Tertiary button
  tertiary,

  /// Outline button
  outline,

  /// Text button
  text,
}

/// Custom button widget
class CustomButton extends StatelessWidget {
  /// Text
  final String text;

  /// Icon
  final IconData? icon;

  /// On pressed
  final VoidCallback? onPressed;

  /// Button type
  final ButtonType type;

  /// Width
  final double? width;

  /// Height
  final double? height;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Text style
  final TextStyle? textStyle;

  /// Background color
  final Color? backgroundColor;

  /// Foreground color
  final Color? foregroundColor;

  /// Border color
  final Color? borderColor;

  /// Padding
  final EdgeInsetsGeometry? padding;
  
  /// Is loading
  final bool isLoading;

  /// Creates a new [CustomButton] instance
  const CustomButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.type = ButtonType.primary,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.padding,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Default styles based on button type
    late final Color defaultBackgroundColor;
    late final Color defaultForegroundColor;
    late final Color defaultBorderColor;
    late final EdgeInsetsGeometry defaultPadding;
    late final Widget buttonChild;
    
    switch (type) {
      case ButtonType.primary:
        defaultBackgroundColor = theme.primaryColor;
        defaultForegroundColor = Colors.white;
        defaultBorderColor = Colors.transparent;
        defaultPadding = const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        );
        buttonChild = _buildElevatedButton(
          context,
          defaultBackgroundColor,
          defaultForegroundColor,
          defaultBorderColor,
          defaultPadding,
        );
        break;
      case ButtonType.secondary:
        defaultBackgroundColor = AppColors.secondary;
        defaultForegroundColor = Colors.white;
        defaultBorderColor = Colors.transparent;
        defaultPadding = const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        );
        buttonChild = _buildElevatedButton(
          context,
          defaultBackgroundColor,
          defaultForegroundColor,
          defaultBorderColor,
          defaultPadding,
        );
        break;
      case ButtonType.tertiary:
        defaultBackgroundColor = AppColors.tertiary;
        defaultForegroundColor = Colors.white;
        defaultBorderColor = Colors.transparent;
        defaultPadding = const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        );
        buttonChild = _buildElevatedButton(
          context,
          defaultBackgroundColor,
          defaultForegroundColor,
          defaultBorderColor,
          defaultPadding,
        );
        break;
      case ButtonType.outline:
        defaultBackgroundColor = Colors.transparent;
        defaultForegroundColor = theme.primaryColor;
        defaultBorderColor = theme.primaryColor;
        defaultPadding = const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        );
        buttonChild = _buildOutlinedButton(
          context,
          defaultBackgroundColor,
          defaultForegroundColor,
          defaultBorderColor,
          defaultPadding,
        );
        break;
      case ButtonType.text:
        defaultBackgroundColor = Colors.transparent;
        defaultForegroundColor = theme.primaryColor;
        defaultBorderColor = Colors.transparent;
        defaultPadding = const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        );
        buttonChild = _buildTextButton(
          context,
          defaultBackgroundColor,
          defaultForegroundColor,
          defaultBorderColor,
          defaultPadding,
        );
        break;
    }
    
    return SizedBox(
      width: width,
      height: height,
      child: buttonChild,
    );
  }

  /// Build elevated button
  Widget _buildElevatedButton(
    BuildContext context,
    Color defaultBackgroundColor,
    Color defaultForegroundColor,
    Color defaultBorderColor,
    EdgeInsetsGeometry defaultPadding,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? defaultBackgroundColor,
        foregroundColor: foregroundColor ?? defaultForegroundColor,
        padding: padding ?? defaultPadding,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          side: BorderSide(
            color: borderColor ?? defaultBorderColor,
          ),
        ),
        elevation: 0,
      ),
      child: _buildButtonContent(context),
    );
  }

  /// Build outlined button
  Widget _buildOutlinedButton(
    BuildContext context,
    Color defaultBackgroundColor,
    Color defaultForegroundColor,
    Color defaultBorderColor,
    EdgeInsetsGeometry defaultPadding,
  ) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor ?? defaultBackgroundColor,
        foregroundColor: foregroundColor ?? defaultForegroundColor,
        padding: padding ?? defaultPadding,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          side: BorderSide(
            color: borderColor ?? defaultBorderColor,
          ),
        ),
      ),
      child: _buildButtonContent(context),
    );
  }

  /// Build text button
  Widget _buildTextButton(
    BuildContext context,
    Color defaultBackgroundColor,
    Color defaultForegroundColor,
    Color defaultBorderColor,
    EdgeInsetsGeometry defaultPadding,
  ) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor ?? defaultBackgroundColor,
        foregroundColor: foregroundColor ?? defaultForegroundColor,
        padding: padding ?? defaultPadding,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          side: BorderSide(
            color: borderColor ?? defaultBorderColor,
          ),
        ),
      ),
      child: _buildButtonContent(context),
    );
  }

  /// Build button content
  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            foregroundColor ?? Colors.white,
          ),
          strokeWidth: 2.0,
        ),
      );
    } else if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(
            text,
            style: textStyle ?? TextStyles.button,
          ),
        ],
      );
    } else {
      return Text(
        text,
        style: textStyle ?? TextStyles.button,
      );
    }
  }
}
