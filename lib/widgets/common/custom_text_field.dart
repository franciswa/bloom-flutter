import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';

/// Custom text field widget
class CustomTextField extends StatelessWidget {
  /// Controller
  final TextEditingController? controller;

  /// Label
  final String? label;

  /// Label text (alternative to label)
  final String? labelText;

  /// Hint text
  final String? hintText;

  /// Error text
  final String? errorText;

  /// Helper text
  final String? helperText;

  /// Prefix icon
  final dynamic prefixIcon;

  /// Suffix icon
  final Widget? suffixIcon;

  /// Keyboard type
  final TextInputType? keyboardType;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Focus node
  final FocusNode? focusNode;

  /// On changed
  final ValueChanged<String>? onChanged;

  /// On submitted
  final ValueChanged<String>? onSubmitted;

  /// On tap
  final VoidCallback? onTap;

  /// Validator
  final FormFieldValidator<String>? validator;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Max lines
  final int? maxLines;

  /// Min lines
  final int? minLines;

  /// Max length
  final int? maxLength;

  /// Obscure text
  final bool obscureText;

  /// Auto focus
  final bool autofocus;

  /// Enabled
  final bool enabled;

  /// Read only
  final bool readOnly;

  /// Auto validate mode
  final AutovalidateMode? autovalidateMode;

  /// Text align
  final TextAlign textAlign;

  /// Text style
  final TextStyle? textStyle;

  /// Content padding
  final EdgeInsetsGeometry? contentPadding;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Fill color
  final Color? fillColor;

  /// Border color
  final Color? borderColor;

  /// Focus border color
  final Color? focusBorderColor;

  /// Error border color
  final Color? errorBorderColor;

  /// Autofill hints
  final Iterable<String>? autofillHints;

  /// Creates a new [CustomTextField] instance
  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.labelText,
    this.hintText,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.obscureText = false,
    this.autofocus = false,
    this.enabled = true,
    this.readOnly = false,
    this.autovalidateMode,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
    this.borderColor,
    this.focusBorderColor,
    this.errorBorderColor,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || labelText != null) ...[
          Text(
            label ?? labelText!,
            style: TextStyles.subtitle2.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          autofocus: autofocus,
          enabled: enabled,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          textAlign: textAlign,
          style: textStyle ?? TextStyles.body1,
          inputFormatters: inputFormatters,
          autovalidateMode: autovalidateMode,
          autofillHints: autofillHints,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            helperText: helperText,
            prefixIcon: prefixIcon != null
                ? (prefixIcon is IconData ? Icon(prefixIcon) : prefixIcon)
                : null,
            suffixIcon: suffixIcon,
            contentPadding: contentPadding ?? const EdgeInsets.all(16),
            filled: true,
            fillColor: fillColor ?? AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius:
                  borderRadius ?? const BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                color: borderColor ?? AppColors.inputBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  borderRadius ?? const BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                color: borderColor ?? AppColors.inputBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  borderRadius ?? const BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                color: focusBorderColor ?? theme.primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius:
                  borderRadius ?? const BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                color: errorBorderColor ?? AppColors.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius:
                  borderRadius ?? const BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                color: errorBorderColor ?? AppColors.error,
                width: 2,
              ),
            ),
          ),
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          validator: validator,
        ),
      ],
    );
  }
}
