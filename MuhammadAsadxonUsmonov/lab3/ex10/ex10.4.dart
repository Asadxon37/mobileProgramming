// Problem 10.5

sealed class PaymentResult {}

class Success extends PaymentResult {
  final String transactionId;
  Success(this.transactionId);
}

class Failure extends PaymentResult {
  final String reason;
  Failure(this.reason);
}

class Pending extends PaymentResult {
  final int secondsLeft;
  Pending(this.secondsLeft);
}

// Exhaustive: sealed class
String message(PaymentResult result) => switch (result) {
      Success(transactionId: final id) => 'Payment OK, id: $id',
      Failure(reason: final r) => 'Payment failed: $r',
      Pending(secondsLeft: final s) => 'Please wait $s seconds...',
    };

void main() {
  final List<PaymentResult> results = [
    Success('TX-1001'),
    Failure('Insufficient funds'),
    Pending(30),
  ];

  for (final PaymentResult r in results) {
    print(message(r));
  }
}
