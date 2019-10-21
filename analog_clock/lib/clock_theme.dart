import 'package:flutter/material.dart';

import 'package:model/model.dart';

enum _Element {
  background,
  hand,
}

const _light = {
  _Element.background: Colors.white,
  _Element.hand: Colors.black,
};

const _dark = {
  _Element.background: Colors.black,
  _Element.hand: Colors.white,
};

const _themes = {
  Mode.light: _light,
  Mode.dark: _dark,
};

class ClockTheme {
  Mode mode = Mode.light;

  Color get background => _themes[mode][_Element.background];
  Color get hand => _themes[mode][_Element.hand];
}
