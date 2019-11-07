import 'dart:io';

import 'package:flutter_clock_helper/clock_customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'digital_clock.dart';

// TODO: If you want to use your own clock, replace `DigitalClock(model)`
// with your clock widget.
void main() {
  // A temporary measure until Platform supports web and TargetPlatform supports macOS.
  if (!kIsWeb && Platform.isMacOS) {
    // TODO(gspencergoog): Update this when TargetPlatform includes macOS. https://github.com/flutter/flutter/issues/31366
    // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  runApp(ClockCustomizer((ClockModel model) => DigitalClock(model)));
}
