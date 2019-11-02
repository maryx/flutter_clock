import 'package:flutter/material.dart';

import 'package:model/model.dart';

enum _Element {
  background,
  text,
  shadow,
}

const _light = {
  _Element.background: Colors.blue,
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

const _dark = {
  _Element.background: Colors.blue,
  _Element.text: Colors.black,
  _Element.shadow: Colors.white30,
};

const _themes = {
  Mode.light: _light,
  Mode.dark: _dark,
};

class ClockTheme {
  Mode mode = Mode.light;

  Color get background => _themes[mode][_Element.background];
  Color get text => _themes[mode][_Element.text];
  Color get shadow => _themes[mode][_Element.shadow];
}
