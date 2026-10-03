// Problem 11.6

import 'dart:async';

Future<void> main() async {
  final StreamController<int> controller = StreamController<int>();

  final Stream<int> pipeline = controller.stream
      // Handles only FormatException
      .handleError(
        (Object error) => print('Ignored format problem: $error'),
        test: (Object error) => error is FormatException,
      )
      .map((int n) => n * 10);

  final Completer<void> done = Completer<void>();

  pipeline.listen(
    (int value) => print('Value: $value'),
    onError: (Object error) => print('Unhandled error reached listener: $error'),
    onDone: () {
      print('Stream finished.');
      done.complete();
    },
  );

  controller.add(1);
  controller.add(2);
  controller.addError(const FormatException('bad number "x"'));
  controller.add(3);
  controller.addError(StateError('database lost'));
  controller.add(4);
  await controller.close();

  await done.future;
}
