// Problem 12.3

void greet(String? name) {
  if (name == null) {
    throw ArgumentError.notNull('name');
  }
  if (name.trim().isEmpty) {
    throw ArgumentError.value(name, 'name', 'must not be empty');
  }
  print('Hello, ${name.trim()}!');
}

void main() {
  final List<String?> inputs = ['Asad', '', '   ', null];

  for (final String? input in inputs) {
    try {
      greet(input);
    } on ArgumentError catch (e) {
      print('ArgumentError for ${input == null ? 'null' : '"$input"'}: $e');
    }
  }
}
