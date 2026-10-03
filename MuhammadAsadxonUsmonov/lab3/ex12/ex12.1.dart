// Problem 12.2

int divide(int a, int b) {
  if (b == 0) {
    throw UnsupportedError('Division by zero is not supported');
  }
  return a ~/ b;
}

void safeDivide(int a, int b) {
  try {
    print('$a ~/ $b = ${divide(a, b)}');
  } on UnsupportedError catch (e) {
    print('Cannot divide $a by $b -> ${e.message}');
  }
}

void main() {
  safeDivide(10, 2);
  safeDivide(7, 3);
  safeDivide(5, 0);
}
