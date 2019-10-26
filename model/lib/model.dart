import 'package:flutter/foundation.dart';

/// This is the model that contains the options for the clock.
///
/// It is a [ChangeNotifier], so use [ChangeNotifier.addListener] to listen to
/// changes to the model. Be sure to call [ChangeNotifier.removeListener] in
/// your `dispose` method.
class ClockModel extends ChangeNotifier {
  get is24HourFormat => _is24HourFormat;
  bool _is24HourFormat = true;
  set is24HourFormat(bool is24HourFormat) {
    if (_is24HourFormat != is24HourFormat) {
      _is24HourFormat = is24HourFormat;
      notifyListeners();
    }
  }

  get mode => _mode;
  Mode _mode = Mode.light;
  set mode(Mode mode) {
    if (_mode != mode) {
      _mode = mode;
      notifyListeners();
    }
  }
}

enum Mode {
  light,
  dark,
}

/// This is a model for the weather portion of the
class WeatherModel extends ChangeNotifier {
  /// Current temperature string. For example: 59°
  get temperature => _convertFromCelsius(_temperature);
  // Stored in degrees celsius, and converted based on the current unit setting.
  num _temperature = 22;
  set temperature(num temperature) {
    temperature = _convertToCelsius(temperature);
    if (temperature != _temperature) {
      _temperature = temperature;
      notifyListeners();
    }
  }

  /// Daily high temperature. For example: 65°F
  get high  => _convertFromCelsius(_high);
  // Stored in degrees celsius, and converted based on the current unit setting.
  num _high = 65;
  set high(num high) {
    high = _convertToCelsius(high);
    if (high != _high) {
      _high = high;
      notifyListeners();
    }
  }

  /// Daily low temperature. For example: 54°F
  get low  => _convertFromCelsius(_low);
  num _low = 54;
  set low(num low) {
    low = _convertToCelsius(low);
    if (low != _low) {
      _low = low;
      notifyListeners();
    }
  }

  /// Weather condition text for current weather. Example: Cloudy, Sunny, etc.
  get weatherCondition => _weatherCondition;
  WeatherCondition _weatherCondition = WeatherCondition.sunny;
  set weatherCondition(WeatherCondition weatherCondition) {
    if (weatherCondition != _weatherCondition) {
      _weatherCondition = weatherCondition;
      notifyListeners();
    }
  }

  /// Temperature unit. For example: Fahrenheit.
  get unit => _unit;
  TemperatureUnit _unit = TemperatureUnit.fahrenheit;
  set unit(TemperatureUnit unit) {
    if (unit != _unit) {
      _unit = unit;
      notifyListeners();
    }
  }

  String get temperatureString {
    return '${temperature.toStringAsFixed(1)}$unitString';
  }

  String get highString {
    return '${high.toStringAsFixed(1)}$unitString';
  }

  String get lowString {
    return '${low.toStringAsFixed(1)}$unitString';
  }

  String get unitString {
    switch (unit) {
      case TemperatureUnit.fahrenheit:
        return '°F';
      case TemperatureUnit.celsius:
      default:
        return '°C';
    }
  }

  num _convertFromCelsius(num degreesCelsius) {
    switch (unit) {
      case TemperatureUnit.fahrenheit:
        return 32.0 + degreesCelsius * 9.0 / 5.0;
      case TemperatureUnit.celsius:
      default:
        return degreesCelsius;
        break;
    }
  }

  num _convertToCelsius(num degrees) {
    switch (unit) {
      case TemperatureUnit.fahrenheit:
        return (degrees - 32.0) * 5.0 / 9.0;
      case TemperatureUnit.celsius:
      default:
        return degrees;
        break;
    }
  }
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
