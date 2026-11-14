import 'package:bloc_test/bloc_test.dart';
import 'package:cart_four_ways/bloc/cart_bloc.dart';
import 'package:cart_four_ways/bloc/cart_event.dart';
import 'package:cart_four_ways/models/cart.dart';
import 'package:cart_four_ways/services/checkout_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckoutApi extends Mock implements CheckoutApi {}

void main() {
  final keyboard = catalog[0];
  late MockCheckoutApi mockApi;
  setUp(() => mockApi = MockCheckoutApi());
  CartState seeded() => CartState(lines: [CartLine(product: keyboard, qty: 1)]);

  blocTest<CartBloc, CartState>(
    'add, add, coupon emits exactly three states',
    build: () => CartBloc(mockApi),
    act: (b) => b
      ..add(CartProductAdded(keyboard))
      ..add(CartProductAdded(keyboard))
      ..add(const CartCouponApplied('SAVE10')),
    expect: () => [
      isA<CartState>().having((s) => s.itemCount, 'itemCount', 1),
      isA<CartState>().having((s) => s.itemCount, 'itemCount', 2),
      isA<CartState>()
          .having((s) => s.coupon, 'coupon', 'SAVE10')
          .having((s) => s.total, 'total', closeTo(88.2, 0.001)),
    ],
  );

  blocTest<CartBloc, CartState>(
    'failed checkout emits submitting then failure and keeps lines',
    setUp: () => when(() => mockApi.submit(any()))
        .thenAnswer((_) async => throw const CheckoutException('Card declined')),
    build: () => CartBloc(mockApi),
    seed: seeded,
    act: (b) => b.add(const CartCheckoutRequested()),
    expect: () => [
      isA<CartState>().having((s) => s.status, 'status', CheckoutStatus.submitting),
      isA<CartState>()
          .having((s) => s.status, 'status', CheckoutStatus.failure)
          .having((s) => s.lines, 'lines', isNotEmpty),
    ],
  );

  blocTest<CartBloc, CartState>(
    'droppable(): two checkout requests submit once',
    setUp: () => when(() => mockApi.submit(any())).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      return 'ORD-1';
    }),
    build: () => CartBloc(mockApi),
    seed: seeded,
    act: (b) => b
      ..add(const CartCheckoutRequested())
      ..add(const CartCheckoutRequested()),
    wait: const Duration(milliseconds: 150),
    expect: () => [
      isA<CartState>().having((s) => s.status, 'status', CheckoutStatus.submitting),
      isA<CartState>().having((s) => s.status, 'status', CheckoutStatus.success),
    ],
    verify: (_) => verify(() => mockApi.submit(any())).called(1),
  );
}
