class ClockModel {
  bool is24HrFormat = true;
  Mode mode = Mode.LIGHT;
  WeatherModel weatherModel = WeatherModel();
}

enum Mode {
  LIGHT,
  DARK,
}

class WeatherModel {
  /// Current temperature string. For example: 59°
  int temperature = 59;

  /// Daily high temperature. For example: 65°
  int high = 65;

  /// Daily low temperature. For example: 54°
  int low = 54;

  /// Weather condition text for current weather. Example: Cloudy, Sunny, etc.
  WeatherCondition weatherCondition = WeatherCondition.SUNNY;

  /// Temperature unit. For example: FARENHEIT.
  TemperatureUnit unit = TemperatureUnit.FARENHEIT;
}

/// Weather condition in English.
enum WeatherCondition {
  SUNNY,
  WINDY,
  CLOUDY,
  SNOWY,
  RAINY,
  THUNDERSTORM,
}

/// Temperature unit.
enum TemperatureUnit {
  CELCIUS,
  FARENHEIT,
}
