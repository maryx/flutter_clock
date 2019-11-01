import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:model/model.dart';

enum Option {
  mode,
  is24Hr,
  temperature,
  high,
  low,
  weatherCondition,
  temperatureUnit,
}

const _spacer = SizedBox(width: 10);

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
  var _mode = enumToString(Mode.light);
  final _model = ClockModel();
  final _weatherModel = WeatherModel();

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

  void _handleModelChange() {
    setState(() {
      _mode = enumToString(_model.mode);
    });
  }

  void _handleWeatherChange() => setState(() {});

  Widget _dropdownButton(Option option, String item, List<String> items) {
    return DropdownButton<String>(
      value: item,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      style: TextStyle(color: Colors.deepPurple),
      onChanged: (String selected) {
        setState(() {
          switch (option) {
            case Option.mode:
              _mode = selected;
              _model.mode = stringToEnum(selected, Mode.values);
              break;
            case Option.weatherCondition:
              _weatherModel.weatherCondition =
                  stringToEnum(selected, WeatherCondition.values);
              break;
            case Option.temperatureUnit:
              _weatherModel.unit =
                  stringToEnum(selected, TemperatureUnit.values);
              break;
            default:
              break;
          }
        });
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _checkbox(Option option, String title) {
    return Row(
      children: [
        Checkbox(
            value: _model.is24HourFormat,
            onChanged: (bool checked) {
              setState(() {
                _model.is24HourFormat = checked;
              });
            }),
        Text(title),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final clockOptions = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dropdownButton(Option.mode, _mode, enumsToStrings(Mode.values)),
        _spacer,
        _checkbox(Option.is24Hr, '24-hour format'),
        _spacer,
      ],
    );

    final weatherOptions = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Weather:'),
        _spacer,
        _dropdownButton(
            Option.weatherCondition,
            enumToString(_weatherModel.weatherCondition),
            enumsToStrings(WeatherCondition.values)),
        _spacer,
        _dropdownButton(
            Option.temperatureUnit,
            enumToString(_weatherModel.unit),
            enumsToStrings(TemperatureUnit.values))
      ],
    );

    final clockContainer = AspectRatio(
      aspectRatio: 5 / 3,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.black),
        ),
        child: widget._clockFace(_model, _weatherModel),
      ),
    );

    return Column(
      children: [
        clockOptions,
        SizedBox(height: 10),
        weatherOptions,
        SizedBox(height: 10),
        Flexible(child: clockContainer),
      ],
    );
  }
}
