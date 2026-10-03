// Problem 12.6

void readConfig() {
  throw FormatException('Config file is corrupted');
}

void loadSettings() {
  try {
    readConfig();
  } on FormatException catch (e) {
    print('[loadSettings] logging error: ${e.message}');
    // Keeps original stack trace
    rethrow;
  } finally {
    print('[loadSettings] cleanup finished');
  }
}

void main() {
  try {
    loadSettings();
  } on FormatException catch (e, st) {
    print('[main] caught rethrown exception: ${e.message}');
    print('[main] original stack trace has '
        '${st.toString().split('\n').length} lines');
  }
}
