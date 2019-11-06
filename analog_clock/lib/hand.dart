// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A base class for an analog clock hand-drawing widget.
///
/// This only draws one hand of the analog clock. Put them in a [Stack] to have
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

class DrawnHand extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const DrawnHand({
    @required Color color,
    @required this.thickness,
    @required double size,
    @required double angleRadians,
  })  : assert(color != null),
        assert(thickness != null),
        assert(size != null),
        assert(angleRadians != null),
        super(
          color: color,
          size: size,
          angleRadians: angleRadians,
        );

  /// How thick the hand should be drawn, in logical pixels.
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _HandPainter(
            handSize: size,
            lineWidth: thickness,
            angleRadians: angleRadians,
            color: color,
          ),
        ),
      ),
    );
  }
}

// A CustomPainter that draws the clock hands.
class _HandPainter extends CustomPainter {
  _HandPainter({
    @required this.handSize,
    @required this.lineWidth,
    @required this.angleRadians,
    @required this.color,
  })  : assert(handSize != null),
        assert(lineWidth != null),
        assert(angleRadians != null),
        assert(color != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  double handSize;
  double lineWidth;
  double angleRadians;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    // We want to start at the top, not the x-axis, so add pi/2.
    final angle = angleRadians - math.pi / 2.0;
    final length = size.shortestSide * 0.5 * handSize;
    final position = center + Offset(math.cos(angle), math.sin(angle)) * length;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, position, linePaint);
  }

  @override
  bool shouldRepaint(_HandPainter oldDelegate) {
    return oldDelegate.handSize != handSize ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}

/// An analog clock hand drawing widget that uses its child as the clock hand.
///
/// This only draws one hand of the analog clock. Put them in a Stack to have
/// more than one hand.
class ContainerHand extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const ContainerHand({
    @required Color color,
    @required double size,
    @required double angleRadians,
    this.child,
  })  : assert(size != null),
        assert(angleRadians != null),
        super(
          color: color,
          size: size,
          angleRadians: angleRadians,
        );

  /// The child widget that will be used as the clock hand and rotated by
  /// [angleRadians].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: Transform.rotate(
          angle: angleRadians,
          alignment: Alignment.center,
          child: Transform.scale(
            scale: size,
            alignment: Alignment.center,
            child: Container(
              color: color,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
