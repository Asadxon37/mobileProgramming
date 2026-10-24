import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tick.dart';
import '../services/tick_feed.dart';

/// Holds the "simulate a failure after N ticks" setting (null = never fail).
///
/// The lab sheet uses StateProvider, but flutter_riverpod 3.x moved StateProvider to a legacy
/// import. A Notifier is the 3.x-native equivalent and behaves the same way.
class FailAfterNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void set(int? value) => state = value;
}

final failAfterProvider = NotifierProvider<FailAfterNotifier, int?>(FailAfterNotifier.new);

/// Overridable in tests and in the error demo.
final tickFeedProvider = Provider<TickFeed>((ref) {
  return TickFeed(failAfter: ref.watch(failAfterProvider));
});

final tickerProvider = StreamProvider.autoDispose<List<Tick>>(
  (ref) => ref.watch(tickFeedProvider).watch(),
  // Riverpod 3.x automatically retries failed providers. This lab wants the error to STAY visible
  // (banner over dimmed rows) until the user presses Retry, so automatic retry is switched off.
  retry: (retryCount, error) => null,
);
