// Problem 5.4

/// A **shopping cart**.
///
/// * Add items
/// * Get the total
///
/// ```dart
/// final cart = ShoppingCart()..add('Book', 12.5);
/// ```
class ShoppingCart {
  final Map<String, double> _items = {};

  /// Adds an item; throws [ArgumentError] if [price] is negative.
  void add(String name, double price) {
    if (price < 0) throw ArgumentError('Price cannot be negative');
    _items[name] = price;
  }

  /// Sum of all prices.
  double get total => _items.values.fold(0.0, (sum, p) => sum + p);

  /// Total after [percent] off.
  double totalWithDiscount(double percent) => total * (1 - percent / 100);
}

void main() {
  final cart = ShoppingCart();
  cart.add('Book', 12.5);
  cart.add('Pen', 1.5);
  print('Total: ${cart.total}');
  print('With 10% discount: ${cart.totalWithDiscount(10)}');
}
