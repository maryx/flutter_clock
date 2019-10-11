import 'dart:math' as math;

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';

class Hand extends StatelessWidget {
  final Color _color;
  final double _width;
  final double _length;
  final ValueListenable<double> _angle;

  const Hand({
    @required Color color,
    @required double width,
    @required double length,
    @required ValueListenable<double> angle,
    @required int offset,
    int overflow = 0,
  })  : _color = color,
        _width = width,
        _length = length,
        _angle = angle;

  @override
  Widget build(BuildContext context) {
    final hand = Container(
      width: _width,
      height: _length,
      color: _color,
    );

    final transformedHand = AnimatedBuilder(
      animation: _angle,
      builder: (BuildContext context, Widget child) {
        return Container(
          // TODO why do I have to add another pi?
          transform: Matrix4.rotationZ(_angle.value + math.pi),
          child: hand,
        );
      },
    );

    // Center the hand after it has been translated.
    // TODO why is this off-center?
    return Positioned(
      top: 238,
      left: 398,
      child: transformedHand,
    );
  }
}
