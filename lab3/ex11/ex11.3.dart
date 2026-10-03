// Problem 11.4

import 'dart:async';

Future<void> main() async {
  int received = 0;
  final Completer<void> finished = Completer<void>();

  final Stream<int> ticks =
      Stream.periodic(const Duration(milliseconds: 500), (i) => i + 1);

  late final StreamSubscription<int> subscription;
  subscription = ticks.listen(
    (int value) async {
      received++;
      print('Tick #$value');

      // Cancel after 5 ticks
      if (received == 5) {
        await subscription.cancel();
        print('Subscription cancelled after 5 emissions.');
        finished.complete();
      }
    },
    onDone: () => print('Stream closed.'),
  );

  await finished.future;
}
