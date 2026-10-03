// Problem 7.3

enum OrderStatus { pending, shipped, delivered, cancelled }

// Exhaustive switch
String statusLabel(OrderStatus status) => switch (status) {
      OrderStatus.pending => '⏳ Waiting for confirmation',
      OrderStatus.shipped => '🚚 On the way',
      OrderStatus.delivered => '✅ Delivered',
      OrderStatus.cancelled => '❌ Cancelled',
    };

void main() {
  for (final OrderStatus s in OrderStatus.values) {
    print('${s.name.padRight(10)} -> ${statusLabel(s)}');
  }
}
