import 'package:flutter/material.dart';

import 'package:model/model.dart';

String enumToString(Object e) => e.toString().split('.').last;

T stringToEnum<T>(String string, Iterable<T> enums) {
  return enums.firstWhere((type) => type.toString().split('.').last == string,
      orElse: () => null);
}

List<String> enumsToStrings(List<Object> enums) =>
    enums.map((e) => e.toString().split('.').last).toList(growable: false);

class ClockCustomizer extends StatefulWidget {
  final dynamic _clockFace;
  ClockCustomizer(this._clockFace);

  @override
  _ClockCustomizerState createState() => _ClockCustomizerState();
}

class _ClockCustomizerState extends State<ClockCustomizer> {
  final _model = ClockModel();
  final _weatherModel = WeatherModel();
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _model.addListener(_handleModelChange);
    _weatherModel.addListener(_handleWeatherChange);
  }

  @override
  void dispose() {
    super.dispose();
    _model.removeListener(_handleModelChange);
    _model.dispose();
    _weatherModel.removeListener(_handleWeatherChange);
    _weatherModel.dispose();
  }

  void _handleModelChange() => setState(() {});

  void _handleWeatherChange() => setState(() {});

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
                child: Text(enumToString(item)),
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
              _enumMenu('Theme', _themeMode, ThemeMode.values,
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
              _enumMenu('Weather', _weatherModel.weatherCondition,
                  WeatherCondition.values, (WeatherCondition condition) {
                setState(() {
                  _weatherModel.weatherCondition = condition;
                });
              }),
              _enumMenu('Units', _weatherModel.unit, TemperatureUnit.values,
                  (TemperatureUnit unit) {
                setState(() {
                  _weatherModel.unit = unit;
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
          border: Border.all(width: 2, color: Colors.black),
        ),
        child: widget._clockFace(_model, _weatherModel),
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
