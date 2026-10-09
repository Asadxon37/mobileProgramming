import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Task1()));

class Task1 extends StatefulWidget {
  const Task1({super.key});

  @override
  State<Task1> createState() => _Task1State();
}

class _Task1State extends State<Task1> {
  bool darkMode = false;
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: darkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Column(
          children: [
            // 1.1
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: darkMode,
              onChanged: (v) => setState(() => darkMode = v),
            ),
            CheckboxListTile(
              title: const Text('Agree to Terms'),
              value: agreed,
              onChanged: (v) => setState(() => agreed = v ?? false),
            ),
            const SizedBox(height: 16),
            // 1.2
            ElevatedButton(
              onPressed: agreed
                  ? () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Accepted')),
                      )
                  : null,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
