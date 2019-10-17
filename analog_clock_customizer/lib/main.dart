import 'package:analog_clock/analog_clock.dart';
import 'package:clock_customizer/clock_customizer.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';

void main() => runApp(MaterialApp(
      title: 'Analog Clock with Customizer',
      home: Scaffold(
          body: ClockCustomizer(
              (ValueNotifier<ClockModel> model) => AnalogClock(model))),
    ));
