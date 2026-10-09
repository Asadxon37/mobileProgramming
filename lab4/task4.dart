import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Task4()));

class Task4 extends StatefulWidget {
  const Task4({super.key});

  @override
  State<Task4> createState() => _Task4State();
}

class _Task4State extends State<Task4> {
  bool loading = false;
  String status = 'Idle';

  Future<void> _run() async {
    setState(() {
      loading = true;
      status = 'Loading...';
    });
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() {
      loading = false;
      status = 'Completed';
    });
    // 4.2
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Operation completed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() => status = 'Undone'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Indicators & Feedback')),
      body: Center(
        // 4.1
        child: loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(status, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _run,
                    child: const Text('Start Operation'),
                  ),
                ],
              ),
      ),
    );
  }
}
