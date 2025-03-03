import 'package:flutter/material.dart';

/// Animation utilities for the app
class AnimationUtils {
  /// Private constructor to prevent instantiation
  AnimationUtils._();

  /// Default animation duration
  static const Duration defaultDuration = Duration(milliseconds: 300);

  /// Slow animation duration
  static const Duration slowDuration = Duration(milliseconds: 600);

  /// Fast animation duration
  static const Duration fastDuration = Duration(milliseconds: 150);

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
}
