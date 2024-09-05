import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:precise_clock/responsive_button.dart';

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
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ClockStack(
                      label: 'Pacific Standard Time',
                      clock: Clock(),
                    ),
                    if (_showDetails)
                      ...const [
                        ClockStack(
                          label: 'Mountain Standard Time',
                          clock: Clock(hourOffset: 1),
                        ),
                        ClockStack(
                          label: 'Central Standard Time',
                          clock: Clock(hourOffset: 2),
                        ),
                        ClockStack(
                          label: 'Eastern Standard Time',
                          clock: Clock(hourOffset: 3),
                        ),
                        ClockStack(
                          label: 'Coordinated Universal Time',
                          clock: Clock(utc: true),
                        ),
                      ].expand((e) => [const SizedBox(height: 30), e]),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 15,
          top: 30,
          child: OptionsButton(
            onTap: () => setState(() => _showDetails = !_showDetails),
            value: _showDetails,
          ),
        ),
      ],
    );
  }
}

class ClockStack extends StatelessWidget {
  final String label;
  final Clock clock;

  const ClockStack({super.key, required this.label, required this.clock});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 5),
        clock,
      ],
    );
  }
}

class OptionsButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool value;

  const OptionsButton({super.key, required this.onTap, required this.value});

  @override
  Widget build(BuildContext context) {
    return ResponsiveButton(
      onTap: onTap,
      wrapperBuilder: (child) => Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)),
        child: child,
      ),
      child: const Icon(Icons.list, size: 32, color: Colors.white)
          .animate(target: value ? 1 : 0)
          .crossfade(
            curve: value ? Curves.easeOutQuint : Curves.easeInQuint,
            builder: (_) => const Icon(
              Icons.close,
              size: 32,
              color: Colors.white,
            ),
          ),
    ).animate(target: value ? 1 : 0).rotate(
          curve: value ? Curves.easeOutQuint : Curves.easeInQuint,
          end: 0.25,
        );
  }
}

class Clock extends StatefulWidget {
  final int hourOffset;
  final bool utc;

  const Clock({super.key, this.hourOffset = 0, this.utc = false});

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(milliseconds: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatTime(DateTime t) {
    if (widget.utc) {
      t = t.toUtc();
    } else {
      t = t.copyWith(hour: t.hour + widget.hourOffset);
    }

    final formatter = DateFormat('hh:mm:ss.SSS');
    return formatter.format(t);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        formatTime(DateTime.now()),
        style: const TextStyle(color: Colors.white, fontSize: 50),
      ),
    );
  }
}
