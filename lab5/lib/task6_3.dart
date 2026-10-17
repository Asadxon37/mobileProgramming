// Task 6.3 - Passing an object with extra
//
// Q: What happens with extra when the app is reloaded in a browser? Why is a
//    path parameter safer?
// A: extra lives only in memory, it is NOT part of the URL. After a browser
//    reload (or opening a copied link) it is null, so the screen has no data.
//    A path parameter (/product/3) is in the URL, so it survives reloads,
//    can be bookmarked/shared, and the screen can re-load the data by id.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _Product {
  final String name;
  final double price;
  const _Product(this.name, this.price);
}

const _products = [
  _Product('Laptop', 999.0),
  _Product('Phone', 599.5),
  _Product('Headphones', 79.9),
];

GoRouter _createRouter() => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const _ProductListScreen(),
        ),
        GoRoute(
          path: '/product-details',
          builder: (context, state) {
            final product = state.extra as _Product?; // null after a reload
            if (product == null) return const _MissingScreen();
            return _ProductScreen(product: product);
          },
        ),
      ],
    );

void main() => runApp(const Task63());

class Task63 extends StatefulWidget {
  const Task63({super.key});

  @override
  State<Task63> createState() => _Task63State();
}

class _Task63State extends State<Task63> {
  final _router = _createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
      );
}

class _ProductListScreen extends StatelessWidget {
  const _ProductListScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: ListView(
        children: [
          for (final p in _products)
            ListTile(
              title: Text(p.name),
              subtitle: Text('\$${p.price}'),
              onTap: () => context.push('/product-details', extra: p),
            ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Open details WITHOUT extra (simulates reload)'),
            onTap: () => context.push('/product-details'),
          ),
        ],
      ),
    );
  }
}

class _ProductScreen extends StatelessWidget {
  final _Product product;
  const _ProductScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Center(
        child: Text('Price: \$${product.price}',
            style: const TextStyle(fontSize: 28)),
      ),
    );
  }
}

class _MissingScreen extends StatelessWidget {
  const _MissingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('No data')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('The product object (extra) was lost.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Back to list'),
            ),
          ],
        ),
      ),
    );
  }
}
