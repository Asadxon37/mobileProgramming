// Task 3.2 - Greeting (data passed through the constructor)
import 'package:flutter/material.dart';

void main() => runApp(const Task32());

class Task32 extends StatelessWidget {
  const Task32({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _InputScreen(),
      );
}

class _InputScreen extends StatefulWidget {
  const _InputScreen();

  @override
  State<_InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<_InputScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your name')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final name = _controller.text.trim();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        _GreetScreen(name: name.isEmpty ? 'stranger' : name),
                  ),
                );
              },
              child: const Text('Greet'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GreetScreen extends StatelessWidget {
  final String name;
  const _GreetScreen({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Greeting')),
      body: Center(
        child: Text('Hello, $name!', style: const TextStyle(fontSize: 32)),
      ),
    );
  }
}
