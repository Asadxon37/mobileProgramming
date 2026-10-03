// Problem 9.2

abstract interface class DBConnector {
  void connect();
  void disconnect();
  List<Map<String, dynamic>> query(String sql);
}

class MySQLConnector implements DBConnector {
  final String host;
  bool _connected = false;

  MySQLConnector(this.host);

  @override
  void connect() {
    _connected = true;
    print('Connected to MySQL at $host');
  }

  @override
  void disconnect() {
    _connected = false;
    print('Disconnected from MySQL');
  }

  @override
  List<Map<String, dynamic>> query(String sql) {
    if (!_connected) throw StateError('Not connected');
    print('Running: $sql');
    return [
      {'id': 1, 'name': 'Asad'},
      {'id': 2, 'name': 'Dilnoza'},
    ];
  }
}

void main() {
  final DBConnector db = MySQLConnector('localhost:3306');
  db.connect();
  final rows = db.query('SELECT * FROM students');
  for (final row in rows) {
    print(row);
  }
  db.disconnect();
}
