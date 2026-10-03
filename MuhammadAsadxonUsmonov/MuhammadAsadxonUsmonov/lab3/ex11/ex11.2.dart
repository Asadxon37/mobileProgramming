// Problem 11.3

Future<int> task(String name, int seconds, int result) async {
  print('$name started');
  await Future.delayed(Duration(seconds: seconds));
  print('$name finished after $seconds s');
  return result;
}

Future<void> main() async {
  final Stopwatch sw = Stopwatch()..start();

  // Runs concurrently
  final List<int> results = await Future.wait([
    task('Task A', 1, 10),
    task('Task B', 2, 20),
    task('Task C', 3, 30),
  ]);

  sw.stop();
  print('Results: $results');
  print('Sum: ${results.reduce((a, b) => a + b)}');
  print('Elapsed: ${(sw.elapsedMilliseconds / 1000).toStringAsFixed(1)} s');
}
