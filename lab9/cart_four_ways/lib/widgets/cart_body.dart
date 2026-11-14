import 'package:flutter/material.dart';
import '../models/cart.dart';

/// Dumb UI shared by all four styles: data + callbacks in, widgets out.
/// Coupon / summary / checkout are slots so each style can plug in its own
/// separately-subscribed widget (needed for the selective-rebuild tasks).
class CartBody extends StatelessWidget {
  const CartBody({
    super.key,
    required this.lines,
    required this.onAdd,
    required this.onQtyChanged,
    required this.coupon,
    required this.summary,
    required this.checkout,
  });
  final List<CartLine> lines;
  final void Function(Product) onAdd;
  final void Function(String productId, int delta) onQtyChanged;
  final Widget coupon;
  final Widget summary;
  final Widget checkout;

  @override
  Widget build(BuildContext context) => Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(spacing: 8, children: [
            for (final p in catalog)
              ActionChip(
                  label: Text('${p.name} · ${p.price.toStringAsFixed(0)}'),
                  onPressed: () => onAdd(p)),
          ]),
        ),
        Expanded(
          child: lines.isEmpty
              ? const Center(child: Text('Cart is empty'))
              : ListView(children: [
                  for (final l in lines)
                    ListTile(
                      key: ValueKey(l.product.id),
                      title: Text(l.product.name),
                      subtitle: Text('× ${l.qty}'),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => onQtyChanged(l.product.id, -1)),
                        IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => onQtyChanged(l.product.id, 1)),
                      ]),
                    ),
                ]),
        ),
        coupon,
        summary,
        Padding(padding: const EdgeInsets.all(12), child: checkout),
      ]);
}

class CouponField extends StatefulWidget {
  const CouponField({super.key, required this.onApply, this.error});
  final void Function(String code) onApply;
  final String? error;
  @override
  State<CouponField> createState() => _CouponFieldState();
}

class _CouponFieldState extends State<CouponField> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Coupon code',
                isDense: true,
                errorText: widget.error, // shown in red under the field
              ),
              onSubmitted: widget.onApply,
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.tonal(
              onPressed: () => widget.onApply(_controller.text), child: const Text('Apply')),
        ]),
      );
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.totals});
  final CartTotals totals;

  Widget _row(String label, String value, {bool bold = false}) {
    final style = bold ? const TextStyle(fontWeight: FontWeight.bold) : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label, style: style), Text(value, style: style)]),
    );
  }

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            _row('Items', '${totals.itemCount}'),
            _row('Subtotal', totals.subtotal.toStringAsFixed(2)),
            _row('Discount', '-${totals.discount.toStringAsFixed(2)}'),
            _row('Total', totals.total.toStringAsFixed(2), bold: true),
          ]),
        ),
      );
}

class CheckoutButton extends StatelessWidget {
  const CheckoutButton(
      {super.key, required this.submitting, required this.enabled, required this.onPressed});
  final bool submitting;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: enabled ? onPressed : null,
          child: submitting
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Checkout'),
        ),
      );
}

class UndoButton extends StatelessWidget {
  const UndoButton({super.key, required this.enabled, required this.onPressed});
  final bool enabled;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => IconButton(
      tooltip: 'Undo', icon: const Icon(Icons.undo), onPressed: enabled ? onPressed : null);
}

/// Shared presentation of checkout results (SnackBar on success, MaterialBanner on failure).
void showCheckoutFeedback(BuildContext context,
    {required CheckoutStatus status, String? orderId, String? error}) {
  final m = ScaffoldMessenger.of(context);
  switch (status) {
    case CheckoutStatus.submitting:
      m.hideCurrentMaterialBanner();
    case CheckoutStatus.success:
      m.hideCurrentMaterialBanner();
      m.showSnackBar(SnackBar(content: Text('Order $orderId placed')));
    case CheckoutStatus.failure:
      m.showMaterialBanner(MaterialBanner(
        content: Text(error ?? 'Checkout failed'),
        actions: [TextButton(onPressed: m.hideCurrentMaterialBanner, child: const Text('Dismiss'))],
      ));
    case CheckoutStatus.idle:
      break;
  }
}
