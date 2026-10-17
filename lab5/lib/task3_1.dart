// Task 3.1 - Product list to product details (SAMPLE)
import 'package:flutter/material.dart';

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

void main() => runApp(const Task31());

class Task31 extends StatelessWidget {
  const Task31({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _ProductListScreen(),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _ProductScreen(product: p),
                  ),
                );
              },
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
