import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class Clock extends StatefulWidget {
  final int utcOffset;

  const Clock({super.key, required this.utcOffset});

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
    final formatter = intl.DateFormat('hh:mm:ss.SSS');
    return formatter.format(t);
  }

  @override
  Widget build(BuildContext context) {
    DateTime t = DateTime.now().toUtc();
    t = t.copyWith(hour: t.hour + widget.utcOffset);

    final textSpan = TextSpan(children: [
      TextSpan(
        text: formatTime(t),
        style: const TextStyle(color: Colors.white, fontSize: 30),
      ),
      TextSpan(
        text: t.hour < 12 ? ' am' : ' pm',
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    ]);

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / textPainter.width;

          return Transform.scale(
            scale: scale,
            child: Text.rich(textSpan),
          );
        },
      ),
    );
  }
}
