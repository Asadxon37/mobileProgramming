// Problem 12.5

void level3() {
  throw StateError('Something broke in level3');
}

void level2() => level3();

void level1() => level2();

void main() {
  try {
    level1();
  } catch (e, stackTrace) {
    // Full stack trace
    print('Error: $e');
    print('Stack trace:');
    print(stackTrace);
  }

  print('--- Current stack trace ---');
  print(StackTrace.current);

  try {
    level1();
  } catch (e, st) {
    final List<String> lines = st.toString().split('\n');
    print('First 3 frames:');
    for (final String line in lines.take(3)) {
      print(line);
    }
  }
}
