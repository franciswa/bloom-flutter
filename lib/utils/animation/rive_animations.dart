import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// A widget that displays a Rive animation
class RiveAnimationWidget extends StatefulWidget {
  /// The asset path to the Rive animation file
  final String assetPath;

  /// The name of the animation to play
  final String? animationName;

  /// Whether to auto play the animation
  final bool autoPlay;

  /// The fit of the animation
  final BoxFit fit;

  /// The width of the animation
  final double? width;

  /// The height of the animation
  final double? height;

  /// The alignment of the animation
  final Alignment alignment;

  /// Creates a new [RiveAnimationWidget]
  const RiveAnimationWidget({
    Key? key,
    required this.assetPath,
    this.animationName,
    this.autoPlay = true,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  State<RiveAnimationWidget> createState() => _RiveAnimationWidgetState();
}

class _RiveAnimationWidgetState extends State<RiveAnimationWidget> {
  /// The controller for the Rive animation
  RiveAnimationController? _controller;

  @override
  void initState() {
    super.initState();

    if (widget.autoPlay) {
      _controller = SimpleAnimation(widget.animationName ?? 'Animation');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RiveAnimation.asset(
        widget.assetPath,
        controllers: _controller != null ? [_controller!] : [],
        fit: widget.fit,
        alignment: widget.alignment,
      ),
    );
  }

  /// Play the animation
  void play() {
    _controller?.isActive = true;
  }

  /// Pause the animation
  void pause() {
    _controller?.isActive = false;
  }

  /// Stop the animation
  void stop() {
    _controller?.isActive = false;
  }
}

/// A widget that displays a Rive animation with a trigger
class RiveTriggerAnimation extends StatefulWidget {
  /// The asset path to the Rive animation file
  final String assetPath;

  /// The name of the state machine to use
  final String stateMachineName;

  /// The name of the trigger to activate
  final String triggerName;

  /// Whether to auto play the animation
  final bool autoPlay;

  /// The fit of the animation
  final BoxFit fit;

  /// The width of the animation
  final double? width;

  /// The height of the animation
  final double? height;

  /// Creates a new [RiveTriggerAnimation]
  const RiveTriggerAnimation({
    Key? key,
    required this.assetPath,
    required this.stateMachineName,
    required this.triggerName,
    this.autoPlay = false,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<RiveTriggerAnimation> createState() => _RiveTriggerAnimationState();
}

class _RiveTriggerAnimationState extends State<RiveTriggerAnimation> {
  /// The controller for the Rive animation
  StateMachineController? _controller;

  /// The trigger for the Rive animation
  SMITrigger? _trigger;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RiveAnimation.asset(
        widget.assetPath,
        fit: widget.fit,
        onInit: _onRiveInit,
      ),
    );
  }

  /// Initialize the Rive animation
  void _onRiveInit(Artboard artboard) {
    _controller = StateMachineController.fromArtboard(
      artboard,
      widget.stateMachineName,
    );

    if (_controller != null) {
      artboard.addController(_controller!);
      _trigger =
          _controller!.findInput<bool>(widget.triggerName) as SMITrigger?;

      if (widget.autoPlay && _trigger != null) {
        _trigger!.fire();
      }
    }
  }

  /// Fire the trigger
  void fire() {
    _trigger?.fire();
  }
}

/// A widget that displays a Rive animation with a boolean input
class RiveBoolAnimation extends StatefulWidget {
  /// The asset path to the Rive animation file
  final String assetPath;

  /// The name of the state machine to use
  final String stateMachineName;

  /// The name of the boolean input to control
  final String inputName;

  /// The initial value of the boolean input
  final bool initialValue;

  /// The fit of the animation
  final BoxFit fit;

  /// The width of the animation
  final double? width;

  /// The height of the animation
  final double? height;

  /// Creates a new [RiveBoolAnimation]
  const RiveBoolAnimation({
    Key? key,
    required this.assetPath,
    required this.stateMachineName,
    required this.inputName,
    this.initialValue = false,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<RiveBoolAnimation> createState() => _RiveBoolAnimationState();
}

class _RiveBoolAnimationState extends State<RiveBoolAnimation> {
  /// The controller for the Rive animation
  StateMachineController? _controller;

  /// The boolean input for the Rive animation
  SMIBool? _input;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RiveAnimation.asset(
        widget.assetPath,
        fit: widget.fit,
        onInit: _onRiveInit,
      ),
    );
  }

  /// Initialize the Rive animation
  void _onRiveInit(Artboard artboard) {
    _controller = StateMachineController.fromArtboard(
      artboard,
      widget.stateMachineName,
    );

    if (_controller != null) {
      artboard.addController(_controller!);
      _input = _controller!.findInput<bool>(widget.inputName) as SMIBool?;

      if (_input != null) {
        _input!.value = widget.initialValue;
      }
    }
  }

  /// Set the value of the boolean input
  void setValue(bool value) {
    if (_input != null) {
      _input!.value = value;
    }
  }

  /// Toggle the value of the boolean input
  void toggle() {
    if (_input != null) {
      _input!.value = !_input!.value;
    }
  }
}
