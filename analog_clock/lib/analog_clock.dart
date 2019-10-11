import 'dart:async';

import 'package:flutter/material.dart';
import 'package:model/model.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'clock_theme.dart';
import 'hand.dart';

/// Total distance travelled by a second/minute hand, each second/minute.
final radiansTraveledPerMinute = radians(360 / 60);

/// Total distance travelled by an hour hand, each hour, in radians.
final radiansTraveledPerHour = radians(360 / 12);

class AnalogClock extends StatefulWidget {
  final ValueNotifier<ClockModel> _model;

  const AnalogClock(this._model);

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  final _hourAngle = ValueNotifier<double>(0.0);
  final _minuteAngle = ValueNotifier<double>(0.0);
  ClockTheme _theme;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    final time = DateTime.now();
    _minuteAngle.value = round(time.minute * radiansTraveledPerMinute, 3);
    _hourAngle.value = round(
        time.hour * radiansTraveledPerHour +
            (time.minute / 60) * radiansTraveledPerHour,
        3);
    _timer = Timer(
        Duration(seconds: 60 - time.second) -
            Duration(milliseconds: time.millisecond),
        _updateTime);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _minuteAngle.dispose();
    _hourAngle.dispose();
    widget._model.dispose();
    super.dispose();
  }

  Widget _buildClock() => Center(
        child: Container(
          color: _theme.background,
          child: Stack(children: [
            ValueListenableBuilder(
              valueListenable: _minuteAngle,
              builder: (_, __, ___) => Hand(
                color: _theme.hand,
                width: 8,
                length: 300,
                angle: _minuteAngle,
                offset: 0,
                overflow: 0,
              ),
            ),
            Hand(
              color: _theme.hand,
              width: 8,
              length: 150,
              angle: _hourAngle,
              offset: 0,
              overflow: 0,
            ),
            Center(
              child: Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _theme.hand,
                ),
              ),
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget._model,
      builder: (_, model, __) {
        _theme = ClockTheme()..mode = widget._model.value.mode;
        return _buildClock();
      },
    );
  }
}

/// Rounds an angle in radians (for an analog clock hand) to [decimalPlaces].
double round(double angle, decimalPlaces) {
  return double.parse(angle.toStringAsFixed(decimalPlaces));
}
