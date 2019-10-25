import 'package:flutter/foundation.dart';

/// This is the model that contains the options for the clock.
///
/// It is a [ChangeNotifier], so use [ChangeNotifier.addListener] to listen to
/// changes to the model. Be sure to call [ChangeNotifier.removeListener] in
/// your `dispose` method.
class ClockModel extends ChangeNotifier {
  bool get is24HourFormat => _is24HourFormat;
  bool _is24HourFormat = true;
  set is24HourFormat(bool is24HourFormat) {
    if (_is24HourFormat != is24HourFormat) {
      _is24HourFormat = is24HourFormat;
      notifyListeners();
    }
  }

  Mode get mode => _mode;
  Mode _mode = Mode.light;
  set mode(Mode mode) {
    if (_mode != mode) {
      _mode = mode;
      notifyListeners();
    }
  }

  WeatherModel get weatherModel => _weatherModel;
  WeatherModel _weatherModel = WeatherModel();
  set weatherModel(WeatherModel weatherModel) {
    if (_weatherModel != weatherModel) {
      _weatherModel = weatherModel;
      notifyListeners();
    }
  }
}

enum Mode {
  light,
  dark,
}

class WeatherModel {
  /// Current temperature string. For example: 59°
  int temperature = 59;

  /// Daily high temperature. For example: 65°
  int high = 65;

  /// Daily low temperature. For example: 54°
  int low = 54;

  /// Weather condition text for current weather. Example: Cloudy, Sunny, etc.
  WeatherCondition weatherCondition = WeatherCondition.sunny;

  /// Temperature unit. For example: Fahrenheit.
  TemperatureUnit unit = TemperatureUnit.fahrenheit;
}

/// Weather condition in English.
enum WeatherCondition {
  sunny,
  windy,
  cloudy,
  snowy,
  rainy,
  thunderstorm,
}

/// Temperature unit.
enum TemperatureUnit {
  celsius,
  fahrenheit,
}
