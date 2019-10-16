import 'package:flutter/material.dart';

import 'package:digital_clock/digital_clock.dart';
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

const _spacer = SizedBox(width: 30);

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
  bool _is24Hr = true;

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
            value: _is24Hr,
            onChanged: (bool checked) {
              setState(() {
                _is24Hr = checked;
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
        child: DigitalClock(ValueNotifier<ClockModel>(_model)),
      )
    ];

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
