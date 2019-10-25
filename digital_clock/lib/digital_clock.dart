import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:model/model.dart';

import 'clock_theme.dart';

/// A very basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  final ClockModel _model;

  const DigitalClock(this._model);

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  ClockTheme _theme = ClockTheme();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget._model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._model != oldWidget._model) {
      oldWidget._model.removeListener(_updateModel);
      widget._model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget._model.addListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _theme.mode = widget._model.mode;
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final String timeText = DateFormat(widget._model.is24HourFormat ? 'HH:mm:ss' : 'h:mm:ss a')
        .format(_dateTime)
        .toLowerCase();

    return Container(
      color: _theme.background,
      child: Center(
        child: DefaultTextStyle(
          style: TextStyle(
            color: _theme.text,
            fontSize: widget._model.is24HourFormat ? 100 : 70,
          ),
          child: Semantics.fromProperties(
            properties: SemanticsProperties(
              label: 'Digital clock showing a time of $timeText',
              value: timeText,
            ),
            child: Text(timeText),
          ),
        ),
      ),
    );
  }
}
