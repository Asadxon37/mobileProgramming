// Task 4.2 - Send a number (plain int as argument)
import 'package:flutter/material.dart';

void main() => runApp(const Task42());

class Task42 extends StatelessWidget {
  const Task42({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (c) => const _HomeScreen(),
          '/square': (c) => const _SquareScreen(),
        },
      );
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick a number')),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final n in [1, 2, 3])
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/square', arguments: n),
                  child: Text('$n'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SquareScreen extends StatelessWidget {
  const _SquareScreen();

  @override
  Widget build(BuildContext context) {
    final n = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(title: const Text('Square')),
      body: Center(
        child: Text('Number: $n\nSquare: ${n * n}',
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 32)),
      ),
    );
  }
}
