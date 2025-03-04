import 'package:flutter/material.dart';

/// Simple animation utilities for the app
class SimpleAnimations {
  /// Private constructor to prevent instantiation
  SimpleAnimations._();

  /// Default animation duration
  static const Duration defaultDuration = Duration(milliseconds: 300);

  /// Create a fade in animation
  static Widget fadeIn(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeIn,
  }) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  /// Create a fade out animation
  static Widget fadeOut(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    return AnimatedOpacity(
      opacity: 0.0,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  /// Create a slide in animation
  static Widget slideIn(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutQuad,
    Offset offset = const Offset(0, 100),
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: offset, end: Offset.zero),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Create a scale animation
  static Widget scale(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutBack,
    double begin = 0.8,
    double end = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Create a staggered list item animation
  static Widget staggeredListItem(
    Widget child,
    int index, {
    Duration staggerDelay = const Duration(milliseconds: 50),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: defaultDuration,
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
