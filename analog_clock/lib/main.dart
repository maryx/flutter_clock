// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter_clock_helper/clock_customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'analog_clock.dart';

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
