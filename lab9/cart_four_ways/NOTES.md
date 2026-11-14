# Lab 9 notes: One Cart, Four Ways

## Setup
```
flutter create cart_four_ways --empty
cd cart_four_ways
flutter pub add flutter_riverpod flutter_bloc bloc bloc_concurrency
flutter pub add --dev flutter_test bloc_test mocktail
# then copy lib/ and test/ from this folder over the generated ones
flutter analyze && flutter test
```
`bloc_concurrency` is the one extra package (needed for `droppable()` in Part 5).

---
## Part 1: Shared code
**Why is CartLine immutable with copyWith?** Riverpod, Cubit and Bloc decide whether to notify by comparing new state with old (`==`). If you mutate `qty` in place and re-assign the same object/list, old and new are the same, so nothing is notified and the UI goes stale. Only `setState` would "work" with mutation, because it rebuilds unconditionally. That is the trap: the bug stays hidden until you move to another style. It also breaks undo (history entries would change retroactively) and `==`-based selective rebuilds.

**Why does CartBody take callbacks?** It stays independent of any state-management library, so all four styles reuse it unchanged. It is trivial to test and it can't secretly read global state.

## Part 2: setState
- **After T4, how would a second page read the cart?** It can't: state is a field of one `State` object. I'd have to lift the state above both pages (an InheritedWidget, or a provider) or pass it down via constructors/callbacks. Basically, move it out of the State object, which is what Parts 3–5 do.
- **Where does `_history` live? Hot reload vs restart?** It's a field of `_SetStateCartPageState`. Hot reload keeps State objects, so history survives. Hot restart re-runs `main`, so the State is recreated and history (and the cart) is empty.
- **T3: why must `total` be a getter?** A stored `total` duplicates information. Any code path that changes lines or coupon but forgets to update it leaves a stale total (e.g. undo, qty change, coupon). A getter can't disagree with its inputs.
- **T4: what happens without `if (!mounted) return;`?** If the user leaves during the 1.5 s await, `setState` runs on a disposed State and throws ("setState() called after dispose()"), and `context` for the SnackBar is no longer valid.

## Part 3: Riverpod
- **Where ref.read / ref.watch are used (and why).**
  `ref.watch`: page lines `select`; undo button (`canUndoProvider`); coupon error `select`; summary totals `select`; checkout button `select`. All are display, so they must subscribe.
  `ref.read`: `cartProvider.notifier` for method handles in the page, the coupon field, the undo button and the checkout button (callbacks, no subscription needed); `ref.read(cartProvider)` inside the `ref.listen` callback (one-off peek at orderId/error); `ref.read(checkoutApiProvider)` inside `checkout()` (a dependency lookup, not a subscription); `ref.read(cartProvider.notifier)` inside `canUndoProvider` after it `watch`ed the state.
- **Why does the summary rebuild less than in setState?** In setState the whole page rebuilds on any change. Here the summary watches `select((s) => s.totals)`, a record with value equality, so it rebuilds only when item count, subtotal, discount or total changes. Applying an invalid coupon (only `couponError` changes) doesn't touch it. The debugPrint "Riverpod summary rebuilt" shows this.
- **T2:** with `==`/`hashCode` on `CartState`, `applyCoupon('SAVE10')` twice notifies once. Without them each `copyWith` creates an unequal object and every call notifies.
- **T4: why no mounted check?** The provider lives in the root `ProviderContainer`, which outlives the page, so setting `state` after the page is popped is fine. (If you make it `autoDispose`, the notifier can be disposed mid-await, so I check `ref.mounted`.)
- **T5:** `canUndoProvider` must `watch(cartProvider)` so it recomputes after every change, then read `canUndo` from the notifier. With `autoDispose`, popping the page disposes the notifier (nobody listens), so coming back runs `build()` again: empty cart, empty history.

## Part 4: Cubit
- **What breaks if BlocProvider is inside CartBody?** `CartBody` is the dumb widget, and the page's `BlocBuilder`/`context.read` sit above it, so their context can't find the provider (ProviderNotFoundException). It would also couple the dumb UI to the cubit and create a new cubit whenever it rebuilds.
- **Riverpod equivalents:** BlocProvider ↔ `ProviderScope`/provider declaration (scoped override via nested `ProviderScope`); BlocBuilder ↔ `ref.watch` in a `Consumer`/`ConsumerWidget`; BlocListener ↔ `ref.listen`; `context.read` ↔ `ref.read`; `buildWhen` ↔ `ref.watch(p.select(...))`.
- **T5:** a `canUndo` getter on the cubit isn't observable (BlocBuilder only rebuilds on emitted states), so history went into `CartState`.
- **T2:** the second identical coupon: `recorded()` returns the same state, so `emit` drops it (see `onChange` log: only one line).

## Part 5: Bloc
- **When is the event layer worth it?** Worth it for checkout: `droppable()` gives declarative duplicate-tap protection, and `BlocObserver.onTransition` shows `state --CartCheckoutRequested--> state`. Pure overhead for coupon/add/qty: one-line synchronous handlers where an event class adds ceremony but no behavior. (It does give a named, traceable event, and the sealed `_undoable` switch.)
- **Which style gives "drop duplicate taps" declaratively?** Bloc (`transformer: droppable()`). In the others: setState: guard on `status == submitting`; Riverpod/Cubit: `if (state.status == submitting) return;` (my `canCheckout` guard does this). The imperative guard is fine for one action, but Bloc's transformer scales to debounce/restartable.
- **T5 decision:** undoable = add, qty change, coupon. Not undoable = checkout (status changes, success clears the cart and history) and undo itself.
- **T4:** with a Cubit there is no event queue, so three quick taps call `checkout()` three times (the `canCheckout` guard is what prevents it). The test verifies the API is called once.

---
## Checkpoint questions
1. **Where state lives / when it dies.** setState: field of the `State`, dies when the widget leaves the tree. Riverpod: in the `ProviderContainer`, lives for the app (or until last listener leaves if `autoDispose`). Cubit: in the cubit owned by `BlocProvider`, dies when that provider is disposed (`close()`). Bloc: same as Cubit.
2. **Single public mutation API.** Riverpod Notifier: its public methods (setting `state`). Cubit: its public methods (`emit`). Bloc: `add(event)` only. setState has none; any code in the State calls `setState`.
3. **Mapping.** `ref.watch` ↔ `BlocBuilder`/`context.watch`/`BlocSelector`; `ref.read` ↔ `context.read`; `ref.listen` ↔ `BlocListener`. `setState` is the "no subscription" case: mutation and rebuild are one call, the whole widget rebuilds.
4. **Why skip on `==`, and what must CartState have?** Skipping avoids redundant rebuilds. To make it work the state must be immutable (so old and new can't be the same mutated object) and must override `==` and `hashCode` (value equality, including lists via `listEquals`). Otherwise either nothing notifies (mutation) or everything notifies (identity equality).
5. **Guards after `await`.** setState: `mounted` (State can be disposed, context invalid). Riverpod: nothing while the provider is root-scoped (`ref.mounted` if autoDispose). Cubit: `isClosed` (emit after close throws). Bloc: `emit.isDone` (the handler's emitter is done once the bloc closes). They differ because the lifetime differs: widget tree vs container vs BlocProvider vs handler.

## Comparison table
Line counts are whole files for the full feature (T1–T5), including blanks; shared model/widgets/service (~365 lines) excluded.

| Style | Files | Feature LOC (T1–T5) | Test LOC | Strength | Weakness |
|---|---|---|---|---|---|
| setState | 1 | 77 | 20 | Least code, nothing to learn | State dies with the widget; logic mixed with UI; test is mostly finding widgets |
| Riverpod | 2 | 140 | 38 | Global, no BuildContext needed, `select` and DI via overrides; tests need no widgets | More concepts (read/watch/listen), easy to misuse `ref.read` in build |
| Cubit | 2 | 94 | 46 | Small, explicit, `blocTest` asserts emitted sequence | Needs `BlocProvider` placement; getters aren't observable |
| Bloc | 3 | 134 | 66 | Traceable events, transformers (`droppable`, debounce), exhaustive sealed events | Most boilerplate; overkill for simple synchronous actions |

## Not done / for you to do
Git tags `p1-shared` … `p5-bloc` (commit after each part), live demonstration to the instructor, screen recording, running `flutter analyze` / `flutter test`, and the stretch goals.
