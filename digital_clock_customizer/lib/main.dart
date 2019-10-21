import 'package:flutter/material.dart';
import 'package:clock_customizer/clock_customizer.dart';
// TODO: If you want to use your own clock package, import it here and
// in pubspec.yaml
import 'package:digital_clock/digital_clock.dart';
import 'package:model/model.dart';

// TODO: If you want to use your own clock, replace `DigitalClock(model)`
// with your clock widget.
void main() => runApp(MaterialApp(
      title: 'Digital Clock with Customizer',
      home: Scaffold(
          body: ClockCustomizer(
              (ValueNotifier<ClockModel> model) => DigitalClock(model))),
    ));
