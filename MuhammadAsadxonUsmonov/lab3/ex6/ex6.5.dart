// Problem 6.7

class Rectangle {
  final double width;
  final double height;

  Rectangle(this.width, this.height);

  // Redirect to the primary constructor
  Rectangle.square(double side) : this(side, side);
  Rectangle.unit() : this.square(1);
  Rectangle.fromList(List<double> sides) : this(sides[0], sides[1]);

  double get area => width * height;

  @override
  String toString() => 'Rectangle(${width}x$height, area: $area)';
}

void main() {
  print(Rectangle(4, 5));
  print(Rectangle.square(3));
  print(Rectangle.unit());
  print(Rectangle.fromList([2, 10]));
}
