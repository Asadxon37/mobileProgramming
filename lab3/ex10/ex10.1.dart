// Problem 10.2

import 'dart:math';

abstract class Shape {
  double area();
}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);

  @override
  double area() => pi * radius * radius;
}

class Rectangle extends Shape {
  final double width, height;
  Rectangle(this.width, this.height);

  @override
  double area() => width * height;
}

void main() {
  final List<Shape> shapes = [
    Circle(3),
    Rectangle(4, 5),
    Circle(1.5),
    Rectangle(2, 2),
  ];

  double total = 0;
  for (final Shape s in shapes) {
    print('${s.runtimeType}: area = ${s.area().toStringAsFixed(2)}');
    total += s.area();
  }
  print('Total area: ${total.toStringAsFixed(2)}');
}
