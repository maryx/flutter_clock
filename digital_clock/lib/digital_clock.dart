import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:model/model.dart';

/// A very basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model, this.weatherModel);

  final ClockModel model;
  final WeatherModel weatherModel;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  var _temperature = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    widget.weatherModel.addListener(_updateWeatherModel);
    _updateTime();
    _updateModel();
    _updateWeatherModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
    if (widget.weatherModel != oldWidget.weatherModel) {
      oldWidget.weatherModel.removeListener(_updateWeatherModel);
      widget.weatherModel.addListener(_updateWeatherModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.addListener(_updateModel);
    widget.weatherModel.removeListener(_updateWeatherModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Just need to rebuild here
    });
  }

  void _updateWeatherModel() {
    setState(() {
      _temperature = widget.weatherModel.temperatureString;
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
    final String timeText = DateFormat(widget.model.is24HourFormat ? 'HH:mm:ss' : 'h:mm:ss a')
        .format(_dateTime)
        .toLowerCase();
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: colors.background,
      child: Center(
        child: DefaultTextStyle(
          style: TextStyle(
            color: colors.onBackground,
          ),
          child: Stack(
            children: <Widget>[

              DefaultTextStyle(
                style: TextStyle(
                  color: colors.onBackground,
                  fontSize: widget.model.is24HourFormat ? 100 : 70,
                ),
                child: Center(
                  child: Semantics.fromProperties(
                    properties: SemanticsProperties(
                      label: 'Digital clock showing a time of $timeText',
                      value: timeText,
                    ),
                    child: Text(timeText),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_temperature),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
