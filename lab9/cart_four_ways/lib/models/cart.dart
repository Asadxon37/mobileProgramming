import 'package:flutter/foundation.dart';

class Product {
  const Product({required this.id, required this.name, required this.price});
  final String id;
  final String name;
  final double price;

  @override
  bool operator ==(Object other) =>
      other is Product && other.id == id && other.name == name && other.price == price;
  @override
  int get hashCode => Object.hash(id, name, price);
}

const catalog = [
  Product(id: 'p1', name: 'Keyboard', price: 49),
  Product(id: 'p2', name: 'Mouse', price: 25),
  Product(id: 'p3', name: 'Monitor', price: 199),
];

class CartLine {
  const CartLine({required this.product, required this.qty});
  final Product product;
  final int qty;

  double get subtotal => product.price * qty;
  CartLine copyWith({int? qty}) => CartLine(product: product, qty: qty ?? this.qty);

  @override
  bool operator ==(Object other) => other is CartLine && other.product == product && other.qty == qty;
  @override
  int get hashCode => Object.hash(product, qty);
}

/// Pure, style-independent cart logic on lines. Every state holder calls these.
extension CartLines on List<CartLine> {
  List<CartLine> withProduct(Product p) {
    final i = indexWhere((l) => l.product.id == p.id);
    if (i == -1) return [...this, CartLine(product: p, qty: 1)];
    return [for (final l in this) l.product.id == p.id ? l.copyWith(qty: l.qty + 1) : l];
  }

  List<CartLine> without(String productId) =>
      [for (final l in this) if (l.product.id != productId) l];

  /// T1: changes qty by [delta]; a line that would drop to 0 or below is removed.
  List<CartLine> changeQty(String productId, int delta) => [
        for (final l in this)
          if (l.product.id != productId)
            l
          else if (l.qty + delta > 0)
            l.copyWith(qty: l.qty + delta)
      ];

  double get subtotal => fold(0, (s, l) => s + l.subtotal);
  int get itemCount => fold(0, (s, l) => s + l.qty);
}

enum CheckoutStatus { idle, submitting, success, failure }

const couponCode = 'SAVE10';
const _unset = Object(); // lets copyWith distinguish "not passed" from "set to null"

typedef CartTotals = ({int itemCount, double subtotal, double discount, double total});

/// Whole cart state. Value equality (==/hashCode) is REQUIRED: Riverpod, Cubit and
/// Bloc all skip notifying when new == old, and a hand-written == makes "same coupon
/// twice" a no-op instead of a spurious rebuild.
@immutable
class CartState {
  const CartState({
    this.lines = const [],
    this.coupon,
    this.couponError,
    this.status = CheckoutStatus.idle,
    this.orderId,
    this.checkoutError,
    this.history = const [],
  });

  final List<CartLine> lines;
  final String? coupon;
  final String? couponError;
  final CheckoutStatus status;
  final String? orderId;
  final String? checkoutError;

  /// Used by Cubit and Bloc (history lives in the state so the UI can observe canUndo).
  /// setState and Riverpod keep their own private history list instead.
  final List<CartState> history;

  // ---- T3: derived values are getters, never stored fields ----
  int get itemCount => lines.itemCount;
  double get subtotal => lines.subtotal;
  double get discount => coupon == couponCode ? subtotal * 0.10 : 0;
  double get total => subtotal - discount;
  bool get canUndo => history.isNotEmpty;
  bool get canCheckout => lines.isNotEmpty && status != CheckoutStatus.submitting;
  CartTotals get totals =>
      (itemCount: itemCount, subtotal: subtotal, discount: discount, total: total);

  CartState copyWith({
    List<CartLine>? lines,
    Object? coupon = _unset,
    Object? couponError = _unset,
    CheckoutStatus? status,
    Object? orderId = _unset,
    Object? checkoutError = _unset,
    List<CartState>? history,
  }) =>
      CartState(
        lines: lines ?? this.lines,
        coupon: identical(coupon, _unset) ? this.coupon : coupon as String?,
        couponError: identical(couponError, _unset) ? this.couponError : couponError as String?,
        status: status ?? this.status,
        orderId: identical(orderId, _unset) ? this.orderId : orderId as String?,
        checkoutError:
            identical(checkoutError, _unset) ? this.checkoutError : checkoutError as String?,
        history: history ?? this.history,
      );

  // ---- pure transitions shared by all four styles ----
  CartState withProduct(Product p) => copyWith(lines: lines.withProduct(p));
  CartState changeQty(String id, int delta) => copyWith(lines: lines.changeQty(id, delta));
  CartState applyCoupon(String code) {
    final c = code.trim().toUpperCase();
    if (c == couponCode) return copyWith(coupon: c, couponError: null);
    return copyWith(couponError: 'Invalid coupon code');
  }

  CartState submitting() =>
      copyWith(status: CheckoutStatus.submitting, checkoutError: null, orderId: null);
  CartState succeeded(String id) => copyWith(
      lines: const [],
      coupon: null,
      couponError: null,
      status: CheckoutStatus.success,
      orderId: id,
      history: const []);
  CartState failed(String message) =>
      copyWith(status: CheckoutStatus.failure, checkoutError: message);

  /// Undo restores only the user-editable parts, never checkout status.
  CartState restoreFrom(CartState prev) =>
      copyWith(lines: prev.lines, coupon: prev.coupon, couponError: prev.couponError);

  /// History-in-state helpers (Cubit / Bloc). If [edit] changes nothing the same
  /// state comes back, so the emit is dropped and no history entry is pushed.
  CartState recorded(CartState Function(CartState s) edit) {
    final next = edit(this);
    if (next == this) return this;
    return next.copyWith(history: [...history, copyWith(history: const [])]);
  }

  CartState undone() {
    if (history.isEmpty) return this;
    return restoreFrom(history.last).copyWith(history: history.sublist(0, history.length - 1));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartState &&
          listEquals(lines, other.lines) &&
          coupon == other.coupon &&
          couponError == other.couponError &&
          status == other.status &&
          orderId == other.orderId &&
          checkoutError == other.checkoutError &&
          listEquals(history, other.history);

  @override
  int get hashCode => Object.hash(Object.hashAll(lines), coupon, couponError, status, orderId,
      checkoutError, Object.hashAll(history));
}
