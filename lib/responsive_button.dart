import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:precise_clock/style.dart';

class ResponsiveButton extends StatefulWidget {
  final GestureTapCallback? onTap;
  final Widget Function(Widget)? wrapperBuilder;
  final Widget child;
  final double _scaleLowerBound;

  const ResponsiveButton({
    super.key,
    required this.onTap,
    this.wrapperBuilder,
    required this.child,
  })  : _scaleLowerBound = 0.925;

  const ResponsiveButton.large({
    super.key,
    required this.onTap,
    this.wrapperBuilder,
    required this.child,
  })  : _scaleLowerBound = 0.96;

  @override
  State<ResponsiveButton> createState() => _ResponsiveButtonState();
}

class _ResponsiveButtonState extends State<ResponsiveButton> {
  bool _isPressed = false;
  bool _isPressQueued = false;

  void onPressed(bool isTapDown) {
    if (isTapDown) {
      _isPressQueued = true;
      // Don't play the animation on tap. Delay the animation until the button
      // is pressed for more than 100 ms.
      Future.delayed(100.ms, () {
        if (_isPressQueued) {
          setState(() {
            _isPressed = true;
            _isPressQueued = false;
          });
        }
      });
    } else {
      setState(() {
        _isPressed = false;
        _isPressQueued = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Animate child = widget.child
        .animate(target: _isPressed ? 1 : 0)
        .fade(end: 0.5, duration: Timings.long, curve: Curves.easeInOutSine);

    if (widget.wrapperBuilder != null) {
      child = widget.wrapperBuilder!(child).animate(target: _isPressed ? 1 : 0);
    }

    child.scale(
      duration: Timings.long,
      curve: Curves.easeInOutSine,
      end: Offset(widget._scaleLowerBound, widget._scaleLowerBound),
    );

    return _BaseResponsiveButton(
      onTap: widget.onTap,
      onPressed: onPressed,
      child: RepaintBoundary(child: child),
    );
  }
}

class _BaseResponsiveButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final ValueChanged<bool> onPressed;
  final Widget child;

  const _BaseResponsiveButton({
    required this.onTap,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => onPressed(true),
      onTapCancel: () => onPressed(false),
      onTapUp: (_) => onPressed(false),
      onTap: onTap,
      child: child,
    );
  }
}
