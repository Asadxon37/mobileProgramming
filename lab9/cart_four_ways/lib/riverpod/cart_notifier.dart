import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';

final checkoutApiProvider = Provider<CheckoutApi>((ref) => CheckoutApi());

class CartNotifier extends Notifier<CartState> {
  /// T5: private history. Not part of state, so the UI cannot observe it directly.
  final _history = <CartState>[];

  @override
  CartState build() {
    _history.clear(); // build() re-runs on invalidate: start clean
    return const CartState();
  }

  bool get canUndo => _history.isNotEmpty;

  void _edit(CartState Function(CartState s) f) {
    final next = f(state);
    if (next == state) return;
    _history.add(state); // push BEFORE assigning, so listeners see canUndo == true
    state = next;
  }

  void add(Product p) => _edit((s) => s.withProduct(p));
  void changeQty(String id, int delta) => _edit((s) => s.changeQty(id, delta));
  void applyCoupon(String code) => _edit((s) => s.applyCoupon(code));

  void undo() {
    if (_history.isEmpty) return;
    state = state.restoreFrom(_history.removeLast());
  }

  Future<void> checkout() async {
    if (!state.canCheckout) return;
    final api = ref.read(checkoutApiProvider); // injected, so tests can override it
    state = state.submitting();
    try {
      final id = await api.submit(state.total);
      // Not needed while the provider lives in the root ProviderScope (it outlives
      // every page). It becomes necessary if cartProvider is made autoDispose.
      if (!ref.mounted) return;
      _history.clear();
      state = state.succeeded(id);
    } on CheckoutException catch (e) {
      if (!ref.mounted) return;
      state = state.failed(e.message);
    }
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(CartNotifier.new);
// T5 experiment: NotifierProvider.autoDispose<CartNotifier, CartState>(CartNotifier.new)

/// canUndo is not state, so the provider must watch cartProvider (to recompute after
/// every change) and then read the answer from the notifier.
final canUndoProvider = Provider<bool>((ref) {
  ref.watch(cartProvider);
  return ref.read(cartProvider.notifier).canUndo;
});
