// Task 6.1 - First router: go, push and pop (SAMPLE)
// go   -> replaces the stack with the new location (no back arrow, pop has nothing to pop)
// push -> adds the page on top of the current stack (back arrow, pop works)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter _createRouter() => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const _HomeScreen()),
        GoRoute(
          path: '/details',
          builder: (context, state) => const _DetailsScreen(),
        ),
      ],
    );

void main() => runApp(const Task61());

class Task61 extends StatefulWidget {
  const Task61({super.key});

  @override
  State<Task61> createState() => _Task61State();
}

class _Task61State extends State<Task61> {
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
            ElevatedButton(
              onPressed: () => context.go('/details'),
              child: const Text('go (replace stack)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.push('/details'),
              child: const Text('push (add to stack)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsScreen extends StatelessWidget {
  const _DetailsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: ElevatedButton(
          // After go() there is nothing below to pop; check first.
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/'),
          child: const Text('pop'),
        ),
      ),
    );
  }
}
