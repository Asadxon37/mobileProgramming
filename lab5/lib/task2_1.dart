// Task 2.1 - Route table and pushNamed (SAMPLE)
import 'package:flutter/material.dart';

class _AppRoutes {
  static const home = '/';
  static const settings = '/settings';
}

void main() => runApp(const Task21());

class Task21 extends StatelessWidget {
  const Task21({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: _AppRoutes.home,
        routes: {
          _AppRoutes.home: (context) => const _HomeScreen(),
          _AppRoutes.settings: (context) => const _SettingsScreen(),
        },
      );
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Settings'),
          onPressed: () => Navigator.pushNamed(context, _AppRoutes.settings),
        ),
      ),
    );
  }
}

class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Back'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
