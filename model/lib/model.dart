class ClockModel {
  bool is24HourFormat = true;
  Mode mode = Mode.light;
  WeatherModel weatherModel = WeatherModel();
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
