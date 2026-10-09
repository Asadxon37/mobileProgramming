import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Task3()));

class Task3 extends StatefulWidget {
  const Task3({super.key});

  @override
  State<Task3> createState() => _Task3State();
}

class _Task3State extends State<Task3> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$counter', style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            // 3.2
            OutlinedButton(
              onPressed: () => setState(() => counter = 0),
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
      // 3.1
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => counter++),
        child: const Icon(Icons.add),
      ),
    );
  }
}
