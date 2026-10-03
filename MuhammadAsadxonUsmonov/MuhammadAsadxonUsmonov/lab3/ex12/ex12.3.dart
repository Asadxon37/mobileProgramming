// Problem 12.4

class NegativeNumberException implements Exception {
  final int value;
  NegativeNumberException(this.value);

  @override
  String toString() => 'NegativeNumberException: $value is negative';
}

int parsePositive(String text) {
  final int n = int.parse(text);
  if (n < 0) throw NegativeNumberException(n);
  if (n == 0) throw StateError('Zero is not allowed');
  return n;
}

void main() {
  for (final String text in ['42', 'abc', '-7', '0']) {
    try {
      print('Parsed: ${parsePositive(text)}');
    } on FormatException catch (e) {
      print('"$text" is not a number (${e.message})');
    } on NegativeNumberException catch (e) {
      print('Custom handler: $e');
    } catch (e) {
      // Any other exception
      print('Generic handler caught: $e');
    }
  }
}
