// Task 2.5 - Log out (clear the whole stack)
import 'package:flutter/material.dart';

void main() => runApp(const Task25());

class Task25 extends StatelessWidget {
  const Task25({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (c) => const _LoginScreen(),
          '/home': (c) => const _HomeScreen(),
          '/profile': (c) => const _ProfileScreen(),
        },
      );
}

class _LoginScreen extends StatelessWidget {
  const _LoginScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          child: const Text('Sign in'),
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
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/profile'),
          child: const Text('Open profile'),
        ),
      ),
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ElevatedButton(
          // (route) => false removes every route below the new one.
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false),
          child: const Text('Log out'),
        ),
      ),
    );
  }
}
