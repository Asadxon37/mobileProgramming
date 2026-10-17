// Task 3.4 - Pick a colour (result goes back with pop)
import 'package:flutter/material.dart';

void main() => runApp(const Task34());

class Task34 extends StatelessWidget {
  const Task34({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _HomeScreen(),
      );
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  Color _color = Colors.grey;

  Future<void> _choose() async {
    final c = await Navigator.push<Color>(
      context,
      MaterialPageRoute(builder: (_) => const _PickerScreen()),
    );
    if (!mounted) return; // never use context/setState after await unchecked
    if (c != null) setState(() => _color = c);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Current colour')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 150, height: 150, color: _color),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _choose,
              child: const Text('Choose colour'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerScreen extends StatelessWidget {
  const _PickerScreen();

  Widget _btn(BuildContext context, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size(200, 48),
        ),
        onPressed: () => Navigator.pop(context, color),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick a colour')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _btn(context, 'Red', Colors.red),
            _btn(context, 'Green', Colors.green),
            _btn(context, 'Blue', Colors.blue),
          ],
        ),
      ),
    );
  }
}
