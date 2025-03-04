import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Animation utilities for the app
class Animations {
  /// Private constructor to prevent instantiation
  Animations._();

  /// Default animation duration
  static const Duration defaultDuration = Duration(milliseconds: 300);

  /// Slow animation duration
  static const Duration slowDuration = Duration(milliseconds: 600);

  /// Fast animation duration
  static const Duration fastDuration = Duration(milliseconds: 150);

  /// Apply fade in animation to a widget
  static Widget fadeIn(
    Widget child, {
    Duration? duration,
    Duration? delay,
    Curve? curve,
  }) {
    return Animate(
      effects: [
        FadeEffect(
          begin: 0.0,
          end: 1.0,
          duration: duration ?? defaultDuration,
          curve: curve ?? Curves.easeOut,
          delay: delay,
        ),
      ],
      child: child,
    );
  }

  /// Apply fade out animation to a widget
  static Widget fadeOut(
    Widget child, {
    Duration? duration,
    Duration? delay,
    Curve? curve,
  }) {
    return Animate(
      effects: [
        FadeEffect(
          begin: 1.0,
          end: 0.0,
          duration: duration ?? defaultDuration,
          curve: curve ?? Curves.easeIn,
          delay: delay,
        ),
      ],
      child: child,
    );
  }

  /// Apply slide in from bottom animation to a widget
  static Widget slideInFromBottom(
    Widget child, {
    Duration? duration,
    Duration? delay,
    Curve? curve,
  }) {
    return Animate(
      effects: [
        SlideEffect(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
          duration: duration ?? defaultDuration,
          curve: curve ?? Curves.easeOutQuad,
          delay: delay,
        ),
      ],
      child: child,
    );
  }

  /// Apply slide in from top animation to a widget
  static Widget slideInFromTop(
    Widget child, {
    Duration? duration,
    Duration? delay,
    Curve? curve,
  }) {
    return Animate(
      effects: [
        SlideEffect(
          begin: const Offset(0, -1),
          end: const Offset(0, 0),
          duration: duration ?? defaultDuration,
          curve: curve ?? Curves.easeOutQuad,
          delay: delay,
        ),
      ],
      child: child,
    );
  }

  /// Apply scale animation to a widget
  static Widget scale(
    Widget child, {
    Duration? duration,
    Duration? delay,
    Curve? curve,
    double begin = 0.8,
    double end = 1.0,
  }) {
    return AnimatedScale(
      scale: end,
      duration: duration ?? defaultDuration,
      curve: curve ?? Curves.easeOutBack,
      child: child,
    );
  }

  /// Apply staggered list item animation to a widget
  static Widget staggeredListItem(
    Widget child,
    int index, {
    Duration staggerDelay = const Duration(milliseconds: 50),
  }) {
    final delay = staggerDelay * index;
    return fadeIn(
      child,
      delay: delay,
      duration: defaultDuration,
      curve: Curves.easeOut,
    );
  }
}
