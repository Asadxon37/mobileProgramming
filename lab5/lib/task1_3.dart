// Task 1.3 - Replace, do not stack
// pushReplacement removes Login from the stack, so Home has no back arrow.
// A normal push keeps Login underneath, so the user can go back to it.
import 'package:flutter/material.dart';

void main() => runApp(const Task13());

class Task13 extends StatelessWidget {
  const Task13({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _LoginScreen(),
      );
}

class _LoginScreen extends StatelessWidget {
  const _LoginScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const _HomeScreen()),
              ),
              child: const Text('Sign in (pushReplacement)'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const _HomeScreen()),
              ),
              child: const Text('Sign in (plain push, for comparison)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Text(
          'Welcome! Can you go back? ${Navigator.canPop(context)}',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
