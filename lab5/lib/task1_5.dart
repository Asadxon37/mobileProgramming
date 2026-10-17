// Task 1.5 - Smart back button
import 'package:flutter/material.dart';

void main() => runApp(const Task15());

class Task15 extends StatelessWidget {
  const Task15({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _RootScreen(),
      );
}

/// Shows "Back" if there is something to go back to, otherwise it is disabled.
class BackOrExitButton extends StatelessWidget {
  const BackOrExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return ElevatedButton(
      onPressed: canPop ? () => Navigator.pop(context) : null,
      child: Text(canPop ? 'Back' : 'Nothing to go back to'),
    );
  }
}

class _RootScreen extends StatelessWidget {
  const _RootScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Root screen')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BackOrExitButton(), // disabled here
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const _PushedScreen()),
              ),
              child: const Text('Open pushed screen'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PushedScreen extends StatelessWidget {
  const _PushedScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pushed screen')),
      body: const Center(child: BackOrExitButton()), // enabled here
    );
  }
}
