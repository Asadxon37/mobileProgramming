# Lab 6 – Real-Time Data Ticker with AsyncValue – NOTES

Student: ______________________   Partner: ______________________

## Part 2 – inline questions

**Why is the feed behind its own Provider instead of being constructed inside `tickerProvider`?**
So it can be swapped without touching the code that uses it (dependency injection). Tests and the
error demo override `tickFeedProvider` with a `TickFeed(failAfter: ...)` or `TickFeed(symbols: [])`.
It also lets the feed depend on other state (`failAfterProvider`): when that changes, a new feed is
built and `tickerProvider` rebuilds automatically. If the feed were created inside `tickerProvider`,
none of that could be controlled from outside.

**What does `autoDispose` do when the user navigates away mid-stream?**
When the last listener goes away (the page is removed), Riverpod disposes the provider: the stream
subscription is cancelled, the `async*` feed stops, and the state is thrown away. Coming back builds
it again from scratch, so the user sees the loading state and the 800 ms delay again.

**What `AsyncValue` does `tickerProvider` hold during the 800 ms delay, and what is `hasValue`?**
An `AsyncLoading` (no previous data). `hasValue` is `false`, and `isLoading` is `true`.

## Part 3 – exercises

**3.3 Exact analyzer diagnostic when the `AsyncLoading()` arm is commented out**
Paste the line from your own `flutter analyze` output here: `____________________________`
(It is an error of the form: *"The type 'AsyncValue<List<Tick>>' is not exhaustively matched by the
switch cases since it doesn't match 'AsyncLoading<List<Tick>>()'. Try adding a wildcard pattern or
cases that match 'AsyncLoading<List<Tick>>()'."* – rule `non_exhaustive_switch_expression`.)
This is the guarantee: because `AsyncValue` is sealed, the compiler refuses to build until every
subtype is handled.

**3.4 Why must `AsyncData(value: [])` and `AsyncData(value: [final only])` come before `AsyncData(:final value)`?**
Switch arms are tried top to bottom and the first match wins. `AsyncData(:final value)` matches every
`AsyncData`, so if it came first the two specific arms could never be reached (the analyzer even
flags them as unreachable cases).

## Part 4 – exercises

**4.3 `ref.refresh(tickerProvider.future)` vs `ref.invalidate(tickerProvider)` in a `RefreshIndicator`**
Observation to confirm on your device: ______________________
In both cases Riverpod carries the previous value into the new loading state, so the rows stay on
screen while the stream restarts (that is what the `AsyncValue(:final value?, isLoading: true)` arm
shows with the thin progress bar). The difference is the return value: `invalidate` returns `void`
and only marks the provider dirty (it rebuilds later), so `onRefresh` finishes at once and the
pull-down spinner disappears immediately. `refresh(...future)` rebuilds right away and returns a
`Future` that completes when the rebuilt provider produces its next value, so the spinner lasts exactly
as long as the reload. `refresh(...future)` returns something awaitable because the provider's
`.future` is a `Future` of its next value, and `refresh` hands back whatever you refreshed.

**4.4 Reconnect vs first load, and `isRefreshing` vs `isReloading`**
The arms already handle it: `AsyncValue(:final value?, isLoading: true)` sits above `AsyncLoading()`,
so the full-screen spinner only shows when there is no previous value (cold start).
`isRefreshing` means the state is loading again after a manual refresh (`ref.refresh`, `ref.invalidate`,
pull-to-refresh) while data or an error already exists; `isReloading` means the provider is loading
again because it was rebuilt (for example a watched provider changed) and the new `AsyncLoading`
still carries the previous data or error.

## Checkpoint questions

1. **Which three subtypes make `AsyncValue` sealed, and what does the analyzer report when a switch misses one?**
   `AsyncData`, `AsyncLoading` and `AsyncError`. A switch expression that misses one gives a
   compile-time error (`non_exhaustive_switch_expression`) naming the unmatched subtype.

2. **When does `AsyncError.value` carry a non-null value, and when is it null?**
   Non-null when data existed before the error (for example the stream emitted ticks and then failed,
   or the provider was reloaded from a data state). Null when the error happens before any data was
   ever received (cold start).

3. **`ref.refresh(provider)` vs `ref.refresh(provider.future)` vs `ref.invalidate(provider)`?**
   - `ref.refresh(provider)`: invalidates and immediately rebuilds, returning the new state (for an
     async provider, the new `AsyncValue`, loading with the previous value).
   - `ref.refresh(provider.future)`: same rebuild, but returns the `Future` that completes with the
     provider's next value, so it can be awaited (for example by `RefreshIndicator.onRefresh`).
   - `ref.invalidate(provider)`: only marks the provider as outdated and returns `void`; the rebuild
     happens lazily when it is next read or watched.

4. **Why must `AsyncValue(:final value?, isLoading: true)` sit above `AsyncData(:final value)`?**
   A reload can leave the old data in place while `isLoading` is true. The general `AsyncData` arm
   would match that state first, so the refresh arm (and its progress bar) would never run. More
   generally, arm order is a priority list: specific arms above general ones.

5. **One reason to prefer `switch` over `.when(...)`, and one case where `.when` is convenient.**
   - Prefer `switch`: it can match on content and combined state (`value?` together with `isLoading`,
     empty list, single item), and the compiler still checks it is exhaustive. `.when` only splits
     by the three callbacks.
   - `.when` is convenient for a quick, simple widget where you just want data/loading/error
     callbacks without patterns.
