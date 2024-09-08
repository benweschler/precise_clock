import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:precise_clock/SlidingCrossFadeTransition.dart';
import 'package:precise_clock/animated_tab_switcher.dart';

import 'clock.dart';

//TODO: use style insets
//TODO: clean up style

void main() {
  runApp(const ClockApp());
}

class ClockApp extends StatelessWidget {
  const ClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF001526),
        body: SafeArea(
          child: DefaultTextStyle(
            style: TextStyle(fontSize: 22, letterSpacing: 1),
            child: Home(),
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _tab = 0;

  static const List<Clock> _clocks = [
    Clock(),
    Clock(hourOffset: 1),
    Clock(hourOffset: 2),
    Clock(hourOffset: 3),
    Clock(utc: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ),
                          child: AnimatedTabSwitcher(
                            labels: const [
                              'PST',
                              'MST',
                              'CST',
                              'EST',
                              'UTC',
                            ],
                            onTabChanged: (tab) => setState(() => _tab = tab),
                          ),
                        ),
                      ),
                    )),
          ),
          Positioned.fill(
            child: SlidingCrossFadeTransition(
              childKey: ValueKey(_tab),
              duration: 250.ms,
              index: _tab,
              slideOffset: 0.1,
              child: _clocks[_tab],
            ),
          ),
        ],
      ),
    );
  }
}
