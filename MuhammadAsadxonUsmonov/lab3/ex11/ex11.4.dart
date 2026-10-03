// Problem 11.5

Future<void> main() async {
  final Stream<int> source =
      Stream.fromIterable([1, 2, 2, 3, 4, 4, 5, 6, 6, 7, 8]);

  final Stream<int> result = source
      .where((int n) => n.isEven)
      .map((int n) => n * n)
      .distinct();

  await for (final int value in result) {
    print(value);
  }

  final List<String> labels = await Stream.fromIterable([3, 3, 1, 1, 2])
      .distinct()
      .map((int n) => 'Item $n')
      .toList();
  print(labels);
}
