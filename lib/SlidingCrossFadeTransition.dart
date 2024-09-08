import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SlidingCrossFadeTransition extends StatefulWidget {
  final Widget child;
  final Key childKey;
  final int index;
  final double slideOffset;
  final Duration duration;

  const SlidingCrossFadeTransition({
    super.key,
    required this.childKey,
    required this.duration,
    required this.index,
    required this.slideOffset,
    required this.child,
  });

  @override
  State<SlidingCrossFadeTransition> createState() =>
      _SlidingCrossFadeTransitionState();
}

class _SlidingCrossFadeTransitionState extends State<SlidingCrossFadeTransition>
    with SingleTickerProviderStateMixin {
  late Widget _firstChild = widget.child;
  late Widget _secondChild = widget.child;
  // Initial value is arbitrary.
  Direction _direction = Direction.forward;

  late final _controller = AnimationController(
    // Initialize a completely animated state, reflecting the fact that no
    // animation is ready until the child is reset.
    value: 1,
    duration: widget.duration,
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SlidingCrossFadeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.childKey != oldWidget.childKey) {
      _firstChild = oldWidget.child;
      _secondChild = widget.child;
      _direction = widget.index > oldWidget.index
          ? Direction.forward
          : Direction.reverse;
      _controller.value = 1 - _controller.value;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final offset = widget.slideOffset;

    return CrossFadeTransition(
      animation: _controller.view,
      firstChild: SlideTransition(
        position: _controller.drive(Tween(
          end: Offset(_direction == Direction.forward ? -offset : offset, 0),
          begin: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutQuad))),
        child: _firstChild,
      ),
      secondChild: SlideTransition(
        position: _controller.drive(Tween(
          begin: Offset(_direction == Direction.forward ? offset : -offset, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutQuad))),
        child: _secondChild,
      ),
    );
  }
}

class CrossFadeTransition extends AnimatedWidget {
  final Animation<double> animation;
  final Widget firstChild;
  final Widget secondChild;

  const CrossFadeTransition({
    super.key,
    required this.animation,
    required this.firstChild,
    required this.secondChild,
  }) : super(listenable: animation);

  static final _quadraticValleyTween = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(begin: 1, end: 0)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 0.5,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: 0, end: 1)
          .chain(CurveTween(curve: Curves.easeIn)),
      weight: 0.5,
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _quadraticValleyTween.animate(animation),
      child: animation.value <= 0.5 ? firstChild : secondChild,
    );
  }
}
