// Task 6.2 - Path parameters
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter _createRouter() => GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const _HomeScreen()),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) =>
              _ProductScreen(id: state.pathParameters['id']!),
        ),
      ],
    );

void main() => runApp(const Task62());

class Task62 extends StatefulWidget {
  const Task62({super.key});

  @override
  State<Task62> createState() => _Task62State();
}

class _Task62State extends State<Task62> {
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

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final id in [1, 2, 3])
              Padding(
                padding: const EdgeInsets.all(6),
                child: ElevatedButton(
                  onPressed: () => context.push('/product/$id'),
                  child: Text('Product $id'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProductScreen extends StatelessWidget {
  final String id;
  const _ProductScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product')),
      body: Center(
        child: Text('Product #$id', style: const TextStyle(fontSize: 32)),
      ),
    );
  }
}
