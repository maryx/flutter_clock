import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:clock_customizer/clock_customizer.dart';

// TODO: If you want to use your own clock package, import it here and
// in pubspec.yaml
import 'package:digital_clock/digital_clock.dart';
import 'package:model/model.dart';

// TODO: If you want to use your own clock, replace `DigitalClock(model)`
// with your clock widget.
void main() {
  /// A temporary measure until TargetPlatform supports macOS.
  if (Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  runApp(
    MaterialApp(
      title: 'Digital Clock with Customizer',
      home: Scaffold(
        body: ClockCustomizer((ClockModel model) => DigitalClock(model)),
      ),
    ),
  );
}
