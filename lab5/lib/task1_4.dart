// Task 1.4 - Back to the start
// popUntil removes Steps 2-4 from the stack at once.
import 'package:flutter/material.dart';

void main() => runApp(const Task14());

class Task14 extends StatelessWidget {
  const Task14({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _Step(1),
      );
}

class _Step extends StatelessWidget {
  final int step;
  const _Step(this.step);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Step $step')),
      body: Center(
        child: step < 4
            ? ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => _Step(step + 1)),
                ),
                child: const Text('Next'),
              )
            : ElevatedButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Finish'),
              ),
      ),
    );
  }
}
