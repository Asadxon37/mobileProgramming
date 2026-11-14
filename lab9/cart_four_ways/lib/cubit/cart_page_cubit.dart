import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';
import '../widgets/cart_body.dart';
import 'cart_cubit.dart';

class CubitCartPage extends StatelessWidget {
  const CubitCartPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => CartCubit(CheckoutApi()), // scoped to this page, closed on dispose
        child: BlocListener<CartCubit, CartState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, s) =>
              showCheckoutFeedback(context, status: s.status, orderId: s.orderId, error: s.checkoutError),
          child: Scaffold(
            appBar: AppBar(title: const Text('Cart · Cubit'), actions: [
              BlocSelector<CartCubit, CartState, bool>(
                selector: (s) => s.canUndo,
                builder: (context, canUndo) =>
                    UndoButton(enabled: canUndo, onPressed: context.read<CartCubit>().undo),
              ),
            ]),
            body: BlocBuilder<CartCubit, CartState>(
              buildWhen: (p, c) => p.lines != c.lines,
              builder: (context, state) => CartBody(
                lines: state.lines,
                onAdd: context.read<CartCubit>().add,
                onQtyChanged: context.read<CartCubit>().changeQty,
                coupon: BlocSelector<CartCubit, CartState, String?>(
                  selector: (s) => s.couponError,
                  builder: (context, error) =>
                      CouponField(error: error, onApply: context.read<CartCubit>().applyCoupon),
                ),
                summary: const _CubitSummary(),
                checkout: BlocBuilder<CartCubit, CartState>(
                  buildWhen: (p, c) => p.status != c.status || p.lines != c.lines,
                  builder: (context, s) => CheckoutButton(
                    submitting: s.status == CheckoutStatus.submitting,
                    enabled: s.canCheckout,
                    onPressed: context.read<CartCubit>().checkout,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

/// T3: rebuilds only when the totals change.
class _CubitSummary extends StatelessWidget {
  const _CubitSummary();
  @override
  Widget build(BuildContext context) => BlocSelector<CartCubit, CartState, CartTotals>(
        selector: (s) => s.totals,
        builder: (context, totals) {
          debugPrint('Cubit summary rebuilt');
          return SummaryCard(totals: totals);
        },
      );
}
