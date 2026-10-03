// Problem 6.3

class Student {
  final String name;
  final int age;
  final double gpa;

  // Validates before assigning
  Student(String name, int age, double gpa)
      : assert(age > 0, 'age must be positive'),
        name = _checkName(name),
        age = _checkRange(age, 16, 100, 'age'),
        gpa = _checkRange(gpa, 0.0, 4.0, 'gpa');

  static String _checkName(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('name must not be empty');
    }
    return value.trim();
  }

  static T _checkRange<T extends num>(T value, T min, T max, String field) {
    if (value < min || value > max) {
      throw RangeError('$field must be between $min and $max, got $value');
    }
    return value;
  }

  @override
  String toString() => 'Student($name, age: $age, gpa: $gpa)';
}

void main() {
  print(Student('  Asad ', 20, 3.8));

  final List<List<Object>> badInputs = [
    ['', 20, 3.0],
    ['Ali', 10, 3.0],
    ['Vali', 20, 5.0],
  ];

  for (final input in badInputs) {
    try {
      print(Student(input[0] as String, input[1] as int, input[2] as double));
    } catch (e) {
      print('Invalid input $input -> $e');
    }
  }
}
