import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Loading indicator widget
class LoadingIndicator extends StatelessWidget {
  /// Size
  final double size;

  /// Color
  final Color? color;

  /// Stroke width
  final double strokeWidth;

  /// Creates a new [LoadingIndicator] instance
  const LoadingIndicator({
    super.key,
    this.size = 48.0,
    this.color,
    this.strokeWidth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).primaryColor,
          ),
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

/// Full screen loading indicator widget
class FullScreenLoadingIndicator extends StatelessWidget {
  /// Background color
  final Color? backgroundColor;

  /// Indicator color
  final Color? indicatorColor;

  /// Creates a new [FullScreenLoadingIndicator] instance
  const FullScreenLoadingIndicator({
    super.key,
    this.backgroundColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppColors.overlay,
      child: Center(
        child: LoadingIndicator(
          color: indicatorColor,
        ),
      ),
    );
  }
}

/// Loading overlay widget
class LoadingOverlay extends StatelessWidget {
  /// Child
  final Widget child;

  /// Is loading
  final bool isLoading;

  /// Background color
  final Color? backgroundColor;

  /// Indicator color
  final Color? indicatorColor;

  /// Creates a new [LoadingOverlay] instance
  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.backgroundColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: FullScreenLoadingIndicator(
              backgroundColor: backgroundColor,
              indicatorColor: indicatorColor,
            ),
          ),
      ],
    );
  }
}
