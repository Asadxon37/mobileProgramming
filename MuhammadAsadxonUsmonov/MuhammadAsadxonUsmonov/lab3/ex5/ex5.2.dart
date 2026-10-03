// Problem 5.3

/// Static input validators.
class Validator {
  Validator._();

  /// Returns `true` if [email] looks like `name@domain.tld`.
  static bool isValidEmail(String email) {
    final RegExp pattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    return pattern.hasMatch(email.trim());
  }

  /// Parses [input] as an age.
  ///
  /// Throws [FormatException] if not a number, [RangeError] if outside `0..120`.
  static int parseAge(String input) {
    final int age = int.parse(input.trim());
    if (age < 0 || age > 120) {
      throw RangeError.range(age, 0, 120, 'age');
    }
    return age;
  }
}

void main() {
  print(Validator.isValidEmail('asad@example.com'));
  print(Validator.isValidEmail('not-an-email'));

  for (final String text in ['21', 'abc', '500']) {
    try {
      print('Age: ${Validator.parseAge(text)}');
    } on FormatException catch (e) {
      print('Format problem: ${e.message}');
    } on RangeError catch (e) {
      print('Range problem: $e');
    }
  }
}
