import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'hand.dart';

/// Total distance travelled by a second/minute hand, each second/minute.
final radiansPerTick = radians(360 / 60);

/// Total distance travelled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// A very basic analog clock.
///
/// You can do better than this!
class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  var _temperature = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Just need to rebuild here
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hms().format(DateTime.now());

    // There are several ways to theme your clock. Some ways:
    //  - Inherit the parent Theme (see ClockCustomizer in the
    //    flutter-clock-helper package)
    //  - Override the Theme.of(context).colorScheme
    //  - Create your own [ThemeData], demonstrated in [AnalogClock].
    //  - Create a map of [Color]s to custom keys, demonstrated in
    //    [DigitalClock].
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: Color(0xFF4285F4),
            // Minute hand.
            highlightColor: Color(0xFF8AB4F8),
            // Second hand.
            accentColor: Color(0xFF669DF6),
            backgroundColor: Color(0xFFD2E3FC),
          )
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFFD2E3FC),
            highlightColor: Color(0xFF4285F4),
            accentColor: Color(0xFF8AB4F8),
            backgroundColor: Color(0xFF3C4043),
          );

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        color: customTheme.backgroundColor,
        child: Stack(
          children: [
            // Example of hand drawn with [CustomPainter].
            DrawnHand(
              color: customTheme.accentColor,
              thickness: 4,
              size: 1,
              angleRadians: _now.second * radiansPerTick,
            ),
            DrawnHand(
              color: customTheme.highlightColor,
              thickness: 16,
              size: 0.9,
              angleRadians: _now.minute * radiansPerTick,
            ),
            // Example of hand drawn with [Container].
            // Note that this hand does not scale the way that DrawnHand does.
            ContainerHand(
              color: Colors.transparent,
              size: 0.5,
              angleRadians: _now.hour * radiansPerHour +
                  (_now.minute / 60) * radiansPerHour,
              child: Transform.translate(
                offset: Offset(0.0, -60.0),
                child: Container(
                  width: 32,
                  height: 150,
                  decoration: BoxDecoration(
                    color: customTheme.primaryColor,
                    //borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _temperature,
                  style: TextStyle(color: customTheme.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
