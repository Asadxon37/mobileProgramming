import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';
import '../widgets/cart_body.dart';

class SetStateCartPage extends StatefulWidget {
  const SetStateCartPage({super.key, CheckoutApi? api}) : _api = api;
  final CheckoutApi? _api;

  @override
  State<SetStateCartPage> createState() => _SetStateCartPageState();
}

class _SetStateCartPageState extends State<SetStateCartPage> {
  late final CheckoutApi _api = widget._api ?? CheckoutApi();
  CartState _state = const CartState(); // state is a field on the State object
  final List<CartState> _history = []; // T5: dies with this State (and on hot restart)

  /// Every user edit goes through here: skip no-ops, push history, then setState.
  void _edit(CartState Function(CartState s) f) {
    final next = f(_state);
    if (next == _state) return;
    setState(() {
      _history.add(_state);
      _state = next;
    });
  }

  void _add(Product p) => _edit((s) => s.withProduct(p));
  void _changeQty(String id, int delta) => _edit((s) => s.changeQty(id, delta));
  void _applyCoupon(String code) => _edit((s) => s.applyCoupon(code));

  void _undo() {
    if (_history.isEmpty) return;
    setState(() => _state = _state.restoreFrom(_history.removeLast()));
  }

  Future<void> _checkout() async {
    if (!_state.canCheckout) return;
    setState(() => _state = _state.submitting()); // status changes are NOT undoable
    try {
      final id = await _api.submit(_state.total);
      // Without this guard: if the user popped the page during the 1.5 s await,
      // setState on a disposed State throws, and `context` is no longer valid.
      if (!mounted) return;
      setState(() {
        _state = _state.succeeded(id);
        _history.clear();
      });
      showCheckoutFeedback(context, status: CheckoutStatus.success, orderId: id);
    } on CheckoutException catch (e) {
      if (!mounted) return;
      setState(() => _state = _state.failed(e.message));
      showCheckoutFeedback(context, status: CheckoutStatus.failure, error: e.message);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Cart · setState'),
          actions: [UndoButton(enabled: _history.isNotEmpty, onPressed: _undo)],
        ),
        body: CartBody(
          lines: _state.lines,
          onAdd: _add,
          onQtyChanged: _changeQty,
          coupon: CouponField(error: _state.couponError, onApply: _applyCoupon),
          summary: SummaryCard(totals: _state.totals),
          checkout: CheckoutButton(
            submitting: _state.status == CheckoutStatus.submitting,
            enabled: _state.canCheckout,
            onPressed: _checkout,
          ),
        ),
      );
}
