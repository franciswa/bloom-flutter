import 'package:flutter/material.dart';

/// Bloom-specific animation utilities
class BloomAnimations {
  /// Private constructor to prevent instantiation
  BloomAnimations._();

  /// Default animation duration
  static const Duration defaultDuration = Duration(milliseconds: 300);

  /// Slow animation duration
  static const Duration slowDuration = Duration(milliseconds: 600);

  /// Fast animation duration
  static const Duration fastDuration = Duration(milliseconds: 150);

  /// Create a bloom fade in animation
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

  /// Create a bloom fade out animation
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

  /// Create a bloom slide in animation
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

  /// Create a bloom scale animation
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

  /// Create a bloom pulse animation
  static Widget pulse(
    Widget child, {
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeInOut,
    double minScale = 0.95,
    double maxScale = 1.05,
  }) {
    return _PulseAnimation(
      duration: duration,
      curve: curve,
      minScale: minScale,
      maxScale: maxScale,
      child: child,
    );
  }

  /// Create a bloom staggered list item animation
  static Widget staggeredListItem(
    Widget child,
    int index, {
    Duration staggerDelay = const Duration(milliseconds: 50),
  }) {
    // For staggered animations, we'll use a simpler approach
    // since TweenAnimationBuilder doesn't support delay
    return AnimatedOpacity(
      opacity: 1.0,
      duration: defaultDuration,
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: defaultDuration,
        curve: Curves.easeOutQuad,
        transform: Matrix4.translationValues(0, 0, 0),
        child: child,
      ),
    );
  }
}

/// A stateful widget that implements a continuous pulse animation
class _PulseAnimation extends StatefulWidget {
  /// The child widget to animate
  final Widget child;

  /// The duration of the animation
  final Duration duration;

  /// The curve of the animation
  final Curve curve;

  /// The minimum scale factor
  final double minScale;

  /// The maximum scale factor
  final double maxScale;

  /// Creates a new [_PulseAnimation]
  const _PulseAnimation({
    Key? key,
    required this.duration,
    required this.curve,
    required this.minScale,
    required this.maxScale,
    required this.child,
  }) : super(key: key);

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: widget.minScale,
          end: widget.maxScale,
        ).chain(CurveTween(curve: widget.curve)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: widget.maxScale,
          end: widget.minScale,
        ).chain(CurveTween(curve: widget.curve)),
        weight: 50,
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
