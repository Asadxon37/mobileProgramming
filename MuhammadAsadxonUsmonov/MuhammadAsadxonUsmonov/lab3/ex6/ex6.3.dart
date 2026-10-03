// Problem 6.4

class AppConfig {
  // Created once (thread-safe)
  static final AppConfig _instance = AppConfig._internal();

  String appName = 'Mobile Programming';
  int counter = 0;

  AppConfig._internal() {
    print('AppConfig created (only once!)');
  }

  // Returns the same instance
  factory AppConfig() => _instance;
}

void main() {
  final AppConfig a = AppConfig();
  final AppConfig b = AppConfig();

  a.counter = 5;
  b.counter++;

  print('a.counter = ${a.counter}');
  print('b.counter = ${b.counter}');
  print('Same object? ${identical(a, b)}');
}
