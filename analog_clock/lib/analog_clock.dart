import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:model/model.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'clock_theme.dart';
import 'hand.dart';

/// Total distance travelled by a second/minute hand, each second/minute.
final double radiansPerTick = radians(360 / 60);

/// Total distance travelled by an hour hand, each hour, in radians.
final double radiansPerHour = radians(360 / 12);

/// A very basic analog clock.
///
/// You can do better than this!
class AnalogClock extends StatefulWidget {
  final ClockModel _model;

  const AnalogClock(this._model);

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  DateTime _now = DateTime.now();
  ClockTheme _theme = ClockTheme();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget._model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  void _updateModel() {
    setState(() {
      _theme.mode = widget._model.mode;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._model != oldWidget._model) {
      oldWidget._model.removeListener(_updateModel);
      widget._model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget._model.removeListener(_updateModel);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hm().format(DateTime.now());
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with hour, minute, and second hands, showing a time of $time',
        value: time,
      ),
      child: Container(
        color: _theme.background,
        child: Stack(
          children: [
            Hand(
              color: _theme.hand,
              thickness: 10,
              size: 0.5,
              angleRadians: _now.hour * radiansPerHour + (_now.minute / 60) * radiansPerHour,
            ),
            Hand(
              color: _theme.hand,
              thickness: 8,
              size: 0.75,
              angleRadians: _now.minute * radiansPerTick,
            ),
            ContainerHand(
              color: Colors.transparent,
              size: 0.8,
              angleRadians: _now.second * radiansPerTick,
              child: Transform.translate(
                offset: const Offset(0.0, -100.0),
                child: Text('Second', textScaleFactor: 3.0,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
