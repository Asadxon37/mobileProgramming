// Problem 7.4

abstract interface class Priced {
  double get basePrice;
  double priceWithTax(double taxRate);
}

enum PizzaSize implements Priced {
  small(diameter: 25, basePrice: 6.0),
  medium(diameter: 30, basePrice: 9.0),
  large(diameter: 40, basePrice: 12.5);

  final int diameter;

  @override
  final double basePrice;

  const PizzaSize({required this.diameter, required this.basePrice});

  @override
  double priceWithTax(double taxRate) => basePrice * (1 + taxRate);

  double get area => 3.14159 * (diameter / 2) * (diameter / 2);
  double get pricePerCm2 => basePrice / area;
}

void main() {
  for (final PizzaSize size in PizzaSize.values) {
    print('${size.name}: base \$${size.basePrice}, '
        'with 12% tax \$${size.priceWithTax(0.12).toStringAsFixed(2)}, '
        'area ${size.area.toStringAsFixed(1)} cm2, '
        '\$${size.pricePerCm2.toStringAsFixed(4)} per cm2');
  }
}
