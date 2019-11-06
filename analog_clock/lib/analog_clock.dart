// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'hand.dart';

/// Total distance travelled by a second/minute hand, each second/minute.
final radiansPerTick = radians(360 / 60);

/// Total distance travelled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// A very basic analog clock.
///
/// You can do better than this!
class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model, this.weatherModel);

  final model;
  final weatherModel;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  var _temperature = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    widget.weatherModel.addListener(_updateWeatherModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
    _updateWeatherModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
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
  Widget build(BuildContext context) {
    final time = DateFormat.Hm().format(DateTime.now());
    final colors = Theme.of(context).colorScheme;
    final handColor = colors.onBackground;
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with hour, minute, and second hands, showing a time of $time',
        value: time,
      ),
      child: Container(
        color: colors.background,
        child: Stack(
          children: [
            ContainerHand(
              color: Colors.transparent,
              size: 0.8,
              angleRadians: _now.hour * radiansPerHour + (_now.minute / 60) * radiansPerHour,
              child: Transform.translate(
                offset: Offset(0.0, -50.0),
                child: Container(width: 10, height: 100, color: handColor),
              ),
            ),
            DrawnHand(
              color: handColor,
              thickness: 8,
              size: 0.5,
              angleRadians: _now.minute * radiansPerTick,
            ),
            DrawnHand(
              color: handColor,
              thickness: 4,
              size: 0.9,
              angleRadians: _now.second * radiansPerTick,
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
    );
  }
}
