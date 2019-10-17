import 'package:flutter/material.dart';
import 'package:clock_customizer/clock_customizer.dart';
import 'package:digital_clock/digital_clock.dart';
import 'package:model/model.dart';

void main() => runApp(MaterialApp(
      title: 'Digital Clock with Customizer',
      home: Scaffold(
          body: ClockCustomizer(
              (ValueNotifier<ClockModel> model) => DigitalClock(model))),
    ));
