// Task 4.1 - ScreenArguments class (SAMPLE)
import 'package:flutter/material.dart';

class _ScreenArguments {
  final String title;
  final String message;
  const _ScreenArguments(this.title, this.message);
}

void main() => runApp(const Task41());

class Task41 extends StatelessWidget {
  const Task41({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const _HomeScreen(),
          '/details': (context) => const _DetailsScreen(),
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
          child: const Text('Send arguments'),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/details',
              arguments: const _ScreenArguments('Welcome', 'Sent from Home'),
            );
          },
        ),
      ),
    );
  }
}

class _DetailsScreen extends StatelessWidget {
  const _DetailsScreen();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as _ScreenArguments;
    return Scaffold(
      appBar: AppBar(title: Text(args.title)),
      body: Center(child: Text(args.message)),
    );
  }
}
