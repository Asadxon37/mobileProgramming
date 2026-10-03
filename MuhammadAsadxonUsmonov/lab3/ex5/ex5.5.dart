// Problem 5.6

/// Temperature conversion.
library;

/// Temperature units.
enum TemperatureUnit {
  /// °C.
  celsius,

  /// °F.
  fahrenheit,

  /// K.
  kelvin,
}

/// Converts between [TemperatureUnit]s.
class TemperatureConverter {
  /// Absolute zero in °C.
  static const double absoluteZeroCelsius = -273.15;

  /// Creates a converter.
  const TemperatureConverter();

  /// Converts [value] from [from] to [to].
  ///
  /// Throws [ArgumentError] if below absolute zero.
  double convert(double value, TemperatureUnit from, TemperatureUnit to) {
    final double celsius = _toCelsius(value, from);
    if (celsius < absoluteZeroCelsius) {
      throw ArgumentError.value(value, 'value', 'is below absolute zero');
    }
    return _fromCelsius(celsius, to);
  }

  double _toCelsius(double v, TemperatureUnit unit) => switch (unit) {
        TemperatureUnit.celsius => v,
        TemperatureUnit.fahrenheit => (v - 32) * 5 / 9,
        TemperatureUnit.kelvin => v - 273.15,
      };

  double _fromCelsius(double c, TemperatureUnit unit) => switch (unit) {
        TemperatureUnit.celsius => c,
        TemperatureUnit.fahrenheit => c * 9 / 5 + 32,
        TemperatureUnit.kelvin => c + 273.15,
      };
}

void main() {
  const converter = TemperatureConverter();
  print(converter.convert(
      100, TemperatureUnit.celsius, TemperatureUnit.fahrenheit));
  print(converter.convert(0, TemperatureUnit.celsius, TemperatureUnit.kelvin));

  try {
    converter.convert(-500, TemperatureUnit.celsius, TemperatureUnit.kelvin);
  } on ArgumentError catch (e) {
    print('Error: $e');
  }
}
