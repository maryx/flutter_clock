// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'model.dart';

/// Returns a clock [Widget] with [ClockModel].
///
/// Example:
///   final myClockBuilder = (ClockModel model) => AnalogClock(model);
///
/// Contestants should not edit this.
typedef Widget ClockBuilder(ClockModel model);

/// Wrapper for clock widget to allow for customizations.
///
/// Puts clock in landscape orientation with an aspect ratio of 5:3.
/// Provides drawer where users can customize the data that is sent to the
/// clock.
///
/// To use the [ClockCustomizer], pass your clock into it, via a ClockBuilder.
/// ```
///   final myClockBuilder = (ClockModel model) => AnalogClock(model);
///   return ClockCustomizer(myClockBuilder);
/// ```
///
/// Contestants should not edit this.
class ClockCustomizer extends StatefulWidget {
  /// Clock widget with [ClockModel] to update and display.
  final ClockBuilder _clock;

  const ClockCustomizer(this._clock);

  @override
  _ClockCustomizerState createState() => _ClockCustomizerState();
}

class _ClockCustomizerState extends State<ClockCustomizer> {
  final _model = ClockModel();
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _model.addListener(_handleModelChange);
  }

  @override
  void dispose() {
    _model.removeListener(_handleModelChange);
    _model.dispose();
    super.dispose();
  }

  void _handleModelChange() => setState(() {});

  Widget _enumMenu<T>(
      String label, T value, List<T> items, ValueChanged<T> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isDense: true,
            onChanged: onChanged,
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(_enumToString(item)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _switch(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(label)),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _configDrawer(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              _enumMenu('Theme', _themeMode,
                  ThemeMode.values.toList()..remove(ThemeMode.system),
                  (ThemeMode mode) {
                setState(() {
                  _themeMode = mode;
                });
              }),
              _switch('24-hour format', _model.is24HourFormat, (bool value) {
                setState(() {
                  _model.is24HourFormat = value;
                });
              }),
              _enumMenu(
                  'Weather', _model.weatherCondition, WeatherCondition.values,
                  (WeatherCondition condition) {
                setState(() {
                  _model.weatherCondition = condition;
                });
              }),
              _enumMenu('Units', _model.unit, TemperatureUnit.values,
                  (TemperatureUnit unit) {
                setState(() {
                  _model.unit = unit;
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _configButton() {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: Icon(Icons.settings),
          tooltip: 'Configure clock',
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final clock = AspectRatio(
      aspectRatio: 5 / 3,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            // TODO use onBackground.
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: widget._clock(_model),
      ),
    );

    return MaterialApp(
      theme: ThemeData.from(colorScheme: const ColorScheme.light()),
      darkTheme: ThemeData.from(colorScheme: const ColorScheme.dark()),
      themeMode: _themeMode,
      home: Scaffold(
        endDrawer: _configDrawer(context),
        body: SafeArea(
          child: Stack(
            children: [
              clock,
              // TODO put icon outside of clock.
              Positioned(
                top: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.7,
                  child: _configButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _enumToString(Object e) => e.toString().split('.').last;

T _stringToEnum<T>(String string, Iterable<T> enums) {
  return enums.firstWhere((type) => type.toString().split('.').last == string,
      orElse: () => null);
}

List<String> _enumsToStrings(List<Object> enums) =>
    enums.map((e) => e.toString().split('.').last).toList(growable: false);
