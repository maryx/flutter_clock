// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'analog_clock.dart';

void main() {
  // A temporary measure until Platform supports web and TargetPlatform supports macOS.
  if (!kIsWeb && Platform.isMacOS) {
    // TODO(gspencergoog): Update this when TargetPlatform includes macOS. https://github.com/flutter/flutter/issues/31366
    // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  // This creates a clock that allows you to customize it.
  //
  // The [ClockCustomizer] takes in a [ClockBuilder], comprising:
  //  - a clock widget (in this case, [AnalogClock])
  //  - a model (provided to you via [ClockModel])
  // For more details, see the flutter_clock_helper package.
  //
  // Your job is to edit [AnalogClock] (Look in analog_clock.dart for more
  // details!), or replace it with your own clock widget.
  runApp(ClockCustomizer((ClockModel model) => AnalogClock(model)));
}
