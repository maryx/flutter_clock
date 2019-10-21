import 'package:flutter/material.dart';

import 'package:model/model.dart';

enum _Element {
  background,
  text,
}

const _light = {
  _Element.background: Colors.white,
  _Element.text: Colors.black,
};

const _dark = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
};

const _themes = {
  Mode.LIGHT: _light,
  Mode.DARK: _dark,
};

class ClockTheme {
  Mode mode = Mode.light;

  Color get background => _themes[mode][_Element.background];
  Color get text => _themes[mode][_Element.text];
}
