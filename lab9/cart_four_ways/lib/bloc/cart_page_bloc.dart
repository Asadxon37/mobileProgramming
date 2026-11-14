import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';
import '../widgets/cart_body.dart';
import 'cart_bloc.dart';
import 'cart_event.dart';

class BlocCartPage extends StatelessWidget {
  const BlocCartPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => CartBloc(CheckoutApi()),
        child: BlocListener<CartBloc, CartState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, s) =>
              showCheckoutFeedback(context, status: s.status, orderId: s.orderId, error: s.checkoutError),
          child: Scaffold(
            appBar: AppBar(title: const Text('Cart · Bloc'), actions: [
              BlocSelector<CartBloc, CartState, bool>(
                selector: (s) => s.canUndo,
                builder: (context, canUndo) => UndoButton(
                    enabled: canUndo, onPressed: () => context.read<CartBloc>().add(const CartUndone())),
              ),
            ]),
            body: BlocBuilder<CartBloc, CartState>(
              buildWhen: (p, c) => p.lines != c.lines,
              builder: (context, state) => CartBody(
                lines: state.lines,
                onAdd: (p) => context.read<CartBloc>().add(CartProductAdded(p)),
                onQtyChanged: (id, d) => context.read<CartBloc>().add(CartQtyChanged(id, d)),
                coupon: BlocSelector<CartBloc, CartState, String?>(
                  selector: (s) => s.couponError,
                  builder: (context, error) => CouponField(
                      error: error,
                      onApply: (code) => context.read<CartBloc>().add(CartCouponApplied(code))),
                ),
                summary: const _BlocSummary(),
                checkout: BlocBuilder<CartBloc, CartState>(
                  buildWhen: (p, c) => p.status != c.status || p.lines != c.lines,
                  builder: (context, s) => CheckoutButton(
                    submitting: s.status == CheckoutStatus.submitting,
                    enabled: s.canCheckout,
                    onPressed: () => context.read<CartBloc>().add(const CartCheckoutRequested()),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _BlocSummary extends StatelessWidget {
  const _BlocSummary();
  @override
  Widget build(BuildContext context) => BlocSelector<CartBloc, CartState, CartTotals>(
        selector: (s) => s.totals,
        builder: (context, totals) {
          debugPrint('Bloc summary rebuilt');
          return SummaryCard(totals: totals);
        },
      );
}
