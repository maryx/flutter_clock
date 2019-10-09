import 'package:flutter/material.dart';

import 'selector/clock_selector.dart';

void main() => runApp(ClockDemo());

class ClockDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Clock Demo',
        home: Scaffold(
          body: ClockSelector(),
        ),
      );
}
