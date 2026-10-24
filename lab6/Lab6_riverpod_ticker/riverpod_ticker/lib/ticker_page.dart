import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/tick.dart';
import 'providers/ticker_providers.dart';
import 'widgets/tick_row.dart';

class TickerPage extends ConsumerWidget {
  const TickerPage({super.key});

  /// Scrollable list of rows with pull-to-refresh. Shared by every arm that shows prices.
  Widget _rows(WidgetRef ref, List<Tick> ticks) => RefreshIndicator(
    onRefresh: () => _refresh(ref),
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [for (final t in ticks) TickRow(t, key: ValueKey(t.symbol))],
    ),
  );

  /// refresh(...future) returns a Future that completes when the rebuilt provider has its next
  /// value, so the RefreshIndicator spinner stays visible exactly as long as the reload takes.
  Future<void> _refresh(WidgetRef ref) async {
    try {
      await ref.refresh(tickerProvider.future);
    } catch (_) {
      // The reload failed. The error is already shown by the page's AsyncError arms.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticks = ref.watch(tickerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live ticker'),
        actions: [
          IconButton(
            tooltip: 'Simulate feed failure after 5 ticks',
            icon: const Icon(Icons.bug_report),
            onPressed: () => ref.read(failAfterProvider.notifier).set(5),
          ),
          IconButton(
            tooltip: 'Restore a healthy feed',
            icon: const Icon(Icons.wifi),
            onPressed: () => ref.read(failAfterProvider.notifier).set(null),
          ),
        ],
      ),
      // Arm order is a priority list: specific arms must sit above the general ones.
      body: switch (ticks) {
        // Error with stale data: show rows dimmed, banner on top.
        AsyncError(:final error, :final value?) => Column(
          children: [
            MaterialBanner(
              content: Text('Feed error: $error — showing last prices'),
              actions: [
                TextButton(
                  onPressed: () => ref.invalidate(tickerProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
            Expanded(
              child: Opacity(opacity: 0.5, child: _rows(ref, value)),
            ),
          ],
        ),
        // Error with nothing to show.
        AsyncError(:final error) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Could not load ticker\n$error', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(tickerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        // Refresh/reload in progress and old data exists: keep rows, show a thin progress bar.
        AsyncValue(:final value?, isLoading: true) => Column(
          children: [
            const LinearProgressIndicator(),
            Expanded(child: _rows(ref, value)),
          ],
        ),
        // Content-based arms (exercise 3.4). They must come before the general AsyncData arm,
        // otherwise the general arm would match first and these would never run.
        AsyncData(value: []) => const Center(child: Text('No symbols subscribed')),
        AsyncData(value: [final only]) => Center(child: TickRow(only)),
        AsyncData(:final value) => _rows(ref, value),
        // Cold start: nothing has ever been shown.
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
