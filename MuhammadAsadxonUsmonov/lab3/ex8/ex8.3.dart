// Problem 8.4

import 'dart:math';

abstract class Shape {
  String get name;
  double area();
  double perimeter();

  void describe() {
    print('$name: area = ${area().toStringAsFixed(2)}, '
        'perimeter = ${perimeter().toStringAsFixed(2)}');
  }
}

abstract class Polygon extends Shape {
  final int numberOfSides;

  Polygon(this.numberOfSides);

  @override
  void describe() {
    super.describe();
    print('  -> polygon with $numberOfSides sides');
  }
}

class Triangle extends Polygon {
  final double a, b, c;

  Triangle(this.a, this.b, this.c) : super(3);

  @override
  String get name => 'Triangle';

  @override
  double perimeter() => a + b + c;

  @override
  // Heron's formula
  double area() {
    final double s = perimeter() / 2;
    return sqrt(s * (s - a) * (s - b) * (s - c));
  }
}

class Square extends Polygon {
  final double side;

  Square(this.side) : super(4);

  @override
  String get name => 'Square';

  @override
  double area() => side * side;

  @override
  double perimeter() => 4 * side;
}

void main() {
  final Triangle t = Triangle(3, 4, 5);
  t.describe();

  Square(2.5).describe();

  print(t is Polygon);
  print(t is Shape);
}
