// Task 1.1 - Two screens with push and pop (SAMPLE)
import 'package:flutter/material.dart';

void main() => runApp(const Task11());

class Task11 extends StatelessWidget {
  const Task11({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _HomeScreen(),
      );
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open details'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const _DetailsScreen()),
            );
          },
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
          child: const Text('Go back'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
