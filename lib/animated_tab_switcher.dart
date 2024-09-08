import 'dart:ui';

import 'package:precise_clock/iterable_utils.dart';
import 'package:flutter/material.dart';
import 'package:precise_clock/style.dart';

class AnimatedTabSwitcher extends StatefulWidget {
  final List<String> labels;
  final ValueChanged<int> onTabChanged;

  const AnimatedTabSwitcher({
    super.key,
    required this.labels,
    required this.onTabChanged,
  });

  @override
  State<AnimatedTabSwitcher> createState() => _AnimatedTabSwitcherState();
}

class _AnimatedTabSwitcherState extends State<AnimatedTabSwitcher>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this);
  late final _positionAnimation =
      Tween<double>(begin: 0, end: widget.labels.length.toDouble())
          .animate(_controller);

  int _tab = 0;

  void _switchTabs(int tab) {
    if (tab == _tab) return;

    _controller.animateTo(
      tab / widget.labels.length,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutQuint,
    );
    _tab = tab;
    widget.onTabChanged(tab);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _positionAnimation,
      builder: (_, __) => _TabSwitcher(
        position: _positionAnimation.value,
        labels: widget.labels,
        onTabChanged: (tab) => _switchTabs(tab),
      ),
    );
  }
}

class _TabSwitcher extends StatelessWidget {
  final double position;
  final List<String> labels;
  final ValueChanged<int> onTabChanged;

  const _TabSwitcher({
    required this.position,
    required this.labels,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < labels.length; i++)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onTabChanged(i),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(labels[i], style: TextStyles.title1),
                  const SizedBox(height: 2),
                  Transform.scale(
                    scaleX: clampDouble(-1 * (position - i).abs() + 1, 0, 1),
                    alignment: Alignment.centerLeft,
                    child: Container(height: 3, color: const Color(0xFF3DECFF)),
                  ),
                ],
              ),
            ),
          )
      ].separate(const SizedBox(width: Insets.xl)).toList(),
    );
  }
}
