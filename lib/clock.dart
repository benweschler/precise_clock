import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

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

    final formatter = intl.DateFormat('hh:mm:ss.SSS');
    return formatter.format(t);
  }

  @override
  Widget build(BuildContext context) {
    final textSpan = TextSpan(children: [
      TextSpan(
        text: formatTime(DateTime.now()),
        style: const TextStyle(color: Colors.white, fontSize: 30),
      ),
      TextSpan(
        text: DateTime.now().hour < 12 ? ' am' : ' pm',
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
