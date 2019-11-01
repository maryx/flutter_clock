import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:model/model.dart';

import 'clock_theme.dart';

class DigitalClock extends StatefulWidget {
  final ValueNotifier<ClockModel> _model;

  const DigitalClock(this._model);

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  final _dateTime = ValueNotifier<DateTime>(DateTime.now());
  ClockTheme _theme;
  Timer _timer;
  bool _is24Hr;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    _dateTime.value = DateTime.now();
    _timer = Timer(
        Duration(seconds: 60 - _dateTime.value.second) -
            Duration(milliseconds: _dateTime.value.millisecond),
        _updateTime);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dateTime.dispose();
    widget._model.dispose();
    super.dispose();
  }

  Widget _buildClock() => Container(
        color: _theme.background,
        child: Center(
          child: DefaultTextStyle(
            style: TextStyle(
              color: _theme.text,
              fontSize: 160,
    fontFamily: 'PressStart2P',
            ),
            child: ValueListenableBuilder(
              valueListenable: _dateTime,
              builder: (_, time, __) {
                final timeText =
                    DateFormat(_is24Hr ? 'HH:mm' : 'hh:mm').format(time);
                return Semantics.fromProperties(
                  properties: SemanticsProperties(
                    label: 'Digital clock showing a time of $timeText',
                    value: timeText,
                  ),
                  child: Text(timeText),
                );
              },
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget._model,
      builder: (_, model, __) {
        _theme = ClockTheme()..mode = model.mode;
        _is24Hr = model.is24HourFormat;
        return _buildClock();
      },
    );
  }
}
