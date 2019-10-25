import 'dart:math' as math;

import 'package:flutter/material.dart';

/// An analog clock hand drawing widget.
///
/// This only draws one hand of the analog clock. Put them in a Stack to have
/// more than one hand.
class Hand extends StatelessWidget {
  final Color _color;
  final double _thickness;
  final double _size;
  final double _angleRadians;

  /// Create a const clock [Hand].
  ///
  /// The `color` is the color of the hand.
  ///
  /// The `thickness` specifies how thick the hand should be drawn, in logical
  /// pixels.
  ///
  /// The `size` is a percentage of the overall size of the smallest side of the
  /// rectangle the clock is in.
  ///
  /// The `angleRadians` is the angle from vertical to draw the hand at, in
  /// radians.
  ///
  /// All of the parameters are required and must not be null.
  const Hand({
    @required Color color,
    @required double thickness,
    @required double size,
    @required double angleRadians,
  })  : assert(color != null),
        assert(thickness != null),
        assert(size != null),
        assert(angleRadians != null),
        _color = color,
        _thickness = thickness,
        _size = size,
        _angleRadians = angleRadians;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _HandPainter(
            handSize: _size,
            lineWidth: _thickness,
            angleRadians: _angleRadians,
            color: _color,
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
    final Offset center = (Offset.zero & size).center;
    // We want to start at the top, not the x-axis, so add pi/2.
    final angle = angleRadians - math.pi / 2.0;
    final length = size.shortestSide * 0.5 * handSize;
    final Offset position = center + Offset(math.cos(angle), math.sin(angle)) * length;
    final Paint linePaint = Paint()
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
