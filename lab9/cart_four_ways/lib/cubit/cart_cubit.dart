import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._api) : super(const CartState());
  final CheckoutApi _api;

  // History lives in CartState (a getter on the cubit would not be observable).
  // recorded() returns the same state for a no-op, so emit() drops it.
  void _edit(CartState Function(CartState s) f) => emit(state.recorded(f));

  void add(Product p) => _edit((s) => s.withProduct(p));
  void changeQty(String id, int delta) => _edit((s) => s.changeQty(id, delta));
  void applyCoupon(String code) => _edit((s) => s.applyCoupon(code));
  void undo() => emit(state.undone());

  Future<void> checkout() async {
    if (!state.canCheckout) return;
    emit(state.submitting());
    try {
      final id = await _api.submit(state.total);
      if (isClosed) return; // emit after close() throws
      emit(state.succeeded(id));
    } on CheckoutException catch (e) {
      if (isClosed) return;
      emit(state.failed(e.message));
    }
  }
}
