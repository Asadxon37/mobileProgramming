// Problem 5.2
import 'dart:math';

void main() {
  const double a = 1, b = -3, c = 2;

  /* D = b^2 - 4ac: D > 0 two roots, D == 0 one root, D < 0 none */
  final double d = b * b - 4 * a * c;

  if (d > 0) {
    // x = (-b +/- sqrt(D)) / 2a
    final double x1 = (-b + sqrt(d)) / (2 * a);
    final double x2 = (-b - sqrt(d)) / (2 * a);
    print('Two roots: x1 = $x1, x2 = $x2');
  } else if (d == 0) {
    final double x = -b / (2 * a);
    print('One root: x = $x');
  } else {
    print('No real roots');
  }
}
