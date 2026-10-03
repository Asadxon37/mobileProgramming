// Problem 6.5

class BankAccount {
  double _balance = 0;
  String _owner;

  BankAccount(this._owner);

  double get balance => _balance;

  // Rejects negative balances
  set balance(double value) {
    if (value < 0) {
      throw ArgumentError('Balance cannot be negative: $value');
    }
    _balance = value;
  }

  String get owner => _owner;

  set owner(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Owner name cannot be empty');
    }
    _owner = value.trim();
  }

  bool get isEmpty => _balance == 0;
}

void main() {
  final BankAccount acc = BankAccount('Asad');
  print('Empty? ${acc.isEmpty}');

  acc.balance = 250.0;
  print('Balance: ${acc.balance}');

  try {
    acc.balance = -10;
  } on ArgumentError catch (e) {
    print('Rejected: ${e.message}');
  }

  try {
    acc.owner = '   ';
  } on ArgumentError catch (e) {
    print('Rejected: ${e.message}');
  }

  acc.owner = '  Asadxon ';
  print('Owner: ${acc.owner}');
}
