import 'package:flutter/material.dart';

/// Simple animation utilities for the app
class SimpleAnim {
  /// Private constructor to prevent instantiation
  SimpleAnim._();

  /// Default animation duration
  static const Duration defaultDuration = Duration(milliseconds: 300);

  /// Slow animation duration
  static const Duration slowDuration = Duration(milliseconds: 600);

  /// Fast animation duration
  static const Duration fastDuration = Duration(milliseconds: 150);

  /// Create a fade in animation controller
  static AnimationController createFadeInController(
    TickerProvider vsync, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return AnimationController(
      vsync: vsync,
      duration: duration,
    );
  }

  /// Create a fade in animation
  static Animation<double> createFadeInAnimation(
      AnimationController controller) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );
  }

  /// Create a fade out animation
  static Animation<double> createFadeOutAnimation(
      AnimationController controller) {
    return Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );
  }

  /// Create a slide in animation
  static Animation<Offset> createSlideInAnimation(
    AnimationController controller, {
    Offset begin = const Offset(0, 1),
    Offset end = const Offset(0, 0),
  }) {
    return Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutQuad,
      ),
    );
  }

  /// Create a scale animation
  static Animation<double> createScaleAnimation(
    AnimationController controller, {
    double begin = 0.8,
    double end = 1.0,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );
  }

  /// Create a staggered animation
  static Animation<double> createStaggeredAnimation(
    AnimationController controller,
    int index, {
    Duration staggerDelay = const Duration(milliseconds: 50),
  }) {
    final delay = staggerDelay.inMilliseconds * index;
    final startTime = delay / controller.duration!.inMilliseconds;
    final endTime = startTime + 0.6; // 60% of the animation time

    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          startTime.clamp(0.0, 1.0),
          endTime.clamp(0.0, 1.0),
          curve: Curves.easeOut,
        ),
      ),
    );
  }
}
