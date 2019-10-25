// TODO: If you want to use your own clock package, import it here and
// in pubspec.yaml
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:clock_customizer/clock_customizer.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';

// TODO: If you want to use your own clock, replace `AnalogClock(model)`
// with your clock widget.
void main() {
  /// A temporary measure until TargetPlatform supports macOS.
  if (Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  runApp(MaterialApp(
    title: 'Analog Clock with Customizer',
    home: Scaffold(
      body: SafeArea(
        child: ClockCustomizer((ClockModel model) => AnalogClock(model)),
      ),
    ),
  ));
}
