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
    widget.model.removeListener(_updateModel);
    widget.weatherModel.removeListener(_updateWeatherModel);
    widget.model.dispose();
    widget.weatherModel.dispose();
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
    final colors = Theme.of(context).colorScheme;


    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);

    final defaultStyle = TextStyle(
      color: colors.onBackground,
      fontFamily: 'PressStart2P',
      fontSize: 130,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors.onBackground,
          offset: Offset(10, 0),
        ),
      ],
    );

//    final hour = Center(
//      child: Semantics.fromProperties(
//        properties: SemanticsProperties(
//          label: 'Time is $hour $minute',
//          value: '$hour $minute',
//        ),
//        child: Text($hour),
//      ),
//    );
//

    final weather = Positioned(
      left: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(_temperature),
      ),
    );

    return Container(
      color: colors.background,
      child: Center(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Stack(
            children: <Widget>[
              Positioned(left: -16, top: 0, child: Text(hour)),
              Positioned(right: -16, bottom: -16, child: Text(minute)),
              weather,
            ],
          ),
        ),
      ),
    );
  }
}
