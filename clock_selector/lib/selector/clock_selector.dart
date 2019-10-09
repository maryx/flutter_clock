import 'package:flutter/material.dart';

import '../analog/analog_clock.dart';
import '../clock_model.dart';
import '../digital/digital_clock.dart';

enum Option {
  mode,
  type,
  theme, // TODO
  is24Hr,
  showTickers,
  temperature,
  high,
  low,
  weatherCondition,
  temperatureUnit,
}

const _spacer = SizedBox(width: 30);
const types = ['ANALOG', 'DIGITAL'];

String enumToString(Object e) => e.toString().split('.').last;

T stringToEnum<T>(String string, Iterable<T> enums) {
  return enums.firstWhere((type) => type.toString().split('.').last == string,
      orElse: () => null);
}

List<String> enumsToStrings(List<Object> enums) =>
    enums.map((e) => e.toString().split('.').last).toList(growable: false);

class ClockSelector extends StatefulWidget {
  const ClockSelector();

  @override
  _ClockSelectorState createState() => _ClockSelectorState();
}

class _ClockSelectorState extends State<ClockSelector> {
  String _mode = enumToString(Mode.LIGHT);
  String _type = types[0];
  bool _is24Hr = true;
  bool _showTickers = false;

  ClockModel _model = ClockModel();

  Widget _dropdownButton(Option option, String item, List<String> items) =>
      DropdownButton<String>(
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
              case Option.type:
                _type = selected;
                break;
              case Option.weatherCondition:
                _model.weatherModel.weatherCondition =
                    stringToEnum(selected, WeatherCondition.values);
                break;
              case Option.temperatureUnit:
                _model.weatherModel.unit =
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

  Widget _checkbox(Option option, String title) {
    return Row(
      children: [
        Checkbox(
            value: option == Option.is24Hr ? _is24Hr : _showTickers,
            onChanged: (bool checked) {
              setState(() {
                if (option == Option.is24Hr) {
                  _is24Hr = checked;
                  _model.is24HrFormat = checked;
                } else {
                  _showTickers = checked;
                }
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
        _dropdownButton(Option.type, _type, types),
        _spacer,
        _dropdownButton(Option.mode, _mode, enumsToStrings(Mode.values)),
        _spacer,
        _checkbox(Option.is24Hr, '24-hour format'),
        _spacer,
        _checkbox(Option.showTickers, 'Show tickers'),
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
            enumToString(_model.weatherModel.weatherCondition),
            enumsToStrings(WeatherCondition.values)),
        _spacer,
        _dropdownButton(
            Option.temperatureUnit,
            enumToString(_model.weatherModel.unit),
            enumsToStrings(TemperatureUnit.values))
      ],
    );

    final children = <Widget>[
      Container(
        height: 480,
        width: 800,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.black),
        ),
        child: _type == types[0]
            ? AnalogClock(ValueNotifier<ClockModel>(_model))
            : DigitalClock(ValueNotifier<ClockModel>(_model)),
      )
    ];

    if (_showTickers) {
      children.addAll([
        Positioned(
          right: 24,
          top: 24,
          child: Icon(Icons.alarm, size: 36, color: Colors.grey),
        ),
        Positioned(
          right: 80,
          top: 24,
          child: Icon(Icons.wb_sunny, size: 36, color: Colors.grey),
        ),
        Positioned(
          bottom: 24,
          left: 260,
          child: Center(
            child: Text(
              'Alarm ticker text',
              style: TextStyle(color: Colors.grey, fontSize: 36),
            ),
          ),
        ),
      ]);
    }

    final clockContainer = Stack(children: children);

    return Column(
      children: [
        clockOptions,
        SizedBox(height: 30),
        weatherOptions,
        SizedBox(height: 30),
        clockContainer
      ],
    );
  }
}
