// TODO: If you want to use your own clock package, import it here and
// in pubspec.yaml
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:clock_customizer/clock_customizer.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';

// TODO: If you want to use your own clock, replace
// `AnalogClock(model: model, weatherModel: weatherModel)` with your clock widget.
void main() {
  /// A temporary measure until TargetPlatform supports macOS.
  if (Platform.isMacOS) {
    // TODO(gspencergoog): Update this when TargetPlatform includes macOS. https://github.com/flutter/flutter/issues/31366
    // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  runApp(ClockCustomizer((ClockModel model, WeatherModel weatherModel) => AnalogClock(model, weatherModel)));
}
