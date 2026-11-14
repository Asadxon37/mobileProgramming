import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart.dart';
import '../widgets/cart_body.dart';
import 'cart_notifier.dart';

class RiverpodCartPage extends ConsumerWidget {
  const RiverpodCartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch: rebuild only when the list of lines itself changes
    final lines = ref.watch(cartProvider.select((s) => s.lines));
    final cart = ref.read(cartProvider.notifier); // handle for callbacks, no subscription

    // T2: observe notifications (second identical coupon does not print thanks to ==)
    ref.listen(cartProvider, (prev, next) => debugPrint('Riverpod state changed'));

    // T4: side effects live in listen, never in build
    ref.listen(cartProvider.select((s) => s.status), (prev, next) {
      final s = ref.read(cartProvider);
      showCheckoutFeedback(context, status: next, orderId: s.orderId, error: s.checkoutError);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Cart · Riverpod'), actions: const [_UndoAction()]),
      body: CartBody(
        lines: lines,
        onAdd: cart.add,
        onQtyChanged: cart.changeQty,
        coupon: const _CouponSection(),
        summary: const RiverpodSummary(),
        checkout: const _CheckoutAction(),
      ),
    );
  }
}

class _UndoAction extends ConsumerWidget {
  const _UndoAction();
  @override
  Widget build(BuildContext context, WidgetRef ref) => UndoButton(
        enabled: ref.watch(canUndoProvider),
        onPressed: ref.read(cartProvider.notifier).undo,
      );
}

class _CouponSection extends ConsumerWidget {
  const _CouponSection();
  @override
  Widget build(BuildContext context, WidgetRef ref) => CouponField(
        error: ref.watch(cartProvider.select((s) => s.couponError)),
        onApply: ref.read(cartProvider.notifier).applyCoupon,
      );
}

/// T3: rebuilds only when one of the four totals changes (record equality).
class RiverpodSummary extends ConsumerWidget {
  const RiverpodSummary({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('Riverpod summary rebuilt');
    return SummaryCard(totals: ref.watch(cartProvider.select((s) => s.totals)));
  }
}

class _CheckoutAction extends ConsumerWidget {
  const _CheckoutAction();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(cartProvider.select(
        (s) => (submitting: s.status == CheckoutStatus.submitting, enabled: s.canCheckout)));
    return CheckoutButton(
      submitting: v.submitting,
      enabled: v.enabled,
      onPressed: ref.read(cartProvider.notifier).checkout,
    );
  }
}
