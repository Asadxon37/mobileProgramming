// Problem 10.6

abstract interface class DiscountStrategy {
  double apply(double price);
}

class NoDiscount implements DiscountStrategy {
  @override
  double apply(double price) => price;
}

class PercentageDiscount implements DiscountStrategy {
  final double percent;
  PercentageDiscount(this.percent);

  @override
  double apply(double price) => price * (1 - percent / 100);
}

class FixedDiscount implements DiscountStrategy {
  final double amount;
  FixedDiscount(this.amount);

  @override
  double apply(double price) {
    final double result = price - amount;
    return result < 0 ? 0.0 : result;
  }
}

// Delegates to the strategy
class Checkout {
  DiscountStrategy strategy;

  Checkout(this.strategy);

  double pay(double price) => strategy.apply(price);
}

void main() {
  final Checkout checkout = Checkout(NoDiscount());
  print('No discount:  \$${checkout.pay(200).toStringAsFixed(2)}');

  checkout.strategy = PercentageDiscount(15);
  print('15% off:      \$${checkout.pay(200).toStringAsFixed(2)}');

  checkout.strategy = FixedDiscount(50);
  print('\$50 off:      \$${checkout.pay(200).toStringAsFixed(2)}');

  checkout.strategy = FixedDiscount(500);
  print('\$500 off:     \$${checkout.pay(200).toStringAsFixed(2)}');
}
