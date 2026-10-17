// Task 1.2 - Three-screen chain (A -> B -> C)
// System back button: on C it returns to B, on B to A, on A the app closes
// (A is the root of the stack, there is nothing below it).
import 'package:flutter/material.dart';

void main() => runApp(const Task12());

class Task12 extends StatelessWidget {
  const Task12({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _Screen(0),
      );
}

class _Screen extends StatelessWidget {
  final int index;
  const _Screen(this.index);

  static const _names = ['A', 'B', 'C'];
  static const _colors = [Colors.red, Colors.green, Colors.blue];

  @override
  Widget build(BuildContext context) {
    final isLast = index == _names.length - 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen ${_names[index]}'),
        backgroundColor: _colors[index],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: isLast
            ? ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back'),
              )
            : ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => _Screen(index + 1)),
                ),
                child: const Text('Next'),
              ),
      ),
    );
  }
}
