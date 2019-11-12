// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// A base class for an analog clock hand-drawing widget.
///
/// This only draws one hand of the analog clock. Put it in a [Stack] to have
/// more than one hand.
abstract class Hand extends StatelessWidget {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const Hand({
    @required this.color,
    @required this.size,
    @required this.angleRadians,
  })  : assert(color != null),
        assert(size != null),
        assert(angleRadians != null);

  /// The color to draw the hand in.
  final Color color;

  /// The length that the hand will be, as a percentage of the smallest side of
  /// the rectangle the clock is in.
  final double size;

  /// The angle from vertical to draw the hand at, in radians.
  final double angleRadians;
}
