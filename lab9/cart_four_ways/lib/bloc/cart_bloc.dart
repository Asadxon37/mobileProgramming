import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';
import 'cart_event.dart';

/// Which events push to history. Exhaustive: adding a new event is a compile error
/// until you decide. Checkout status changes and undo itself are NOT undoable.
bool _undoable(CartEvent e) => switch (e) {
      CartProductAdded() || CartQtyChanged() || CartCouponApplied() => true,
      CartCheckoutRequested() || CartUndone() => false,
    };

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._api) : super(const CartState()) {
    on<CartProductAdded>((e, emit) => _mutate(e, emit, (s) => s.withProduct(e.product)));
    on<CartQtyChanged>((e, emit) => _mutate(e, emit, (s) => s.changeQty(e.productId, e.delta)));
    on<CartCouponApplied>((e, emit) => _mutate(e, emit, (s) => s.applyCoupon(e.code)));
    on<CartUndone>((e, emit) => emit(state.undone()));
    // droppable: taps that arrive while a checkout is running are ignored
    on<CartCheckoutRequested>(_onCheckout, transformer: droppable());
  }
  final CheckoutApi _api;

  void _mutate(CartEvent e, Emitter<CartState> emit, CartState Function(CartState s) f) =>
      emit(_undoable(e) ? state.recorded(f) : f(state));

  Future<void> _onCheckout(CartCheckoutRequested e, Emitter<CartState> emit) async {
    if (state.lines.isEmpty) return;
    emit(state.submitting());
    try {
      final id = await _api.submit(state.total);
      if (emit.isDone) return; // bloc closed during the await
      emit(state.succeeded(id));
    } on CheckoutException catch (x) {
      if (emit.isDone) return;
      emit(state.failed(x.message));
    }
  }
}
