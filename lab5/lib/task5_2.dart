// Task 5.2 - Slide from the right
import 'package:flutter/material.dart';

void main() => runApp(const Task52());

class Task52 extends StatelessWidget {
  const Task52({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _HomeScreen(),
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
          child: const Text('Open with slide'),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const _DetailsScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  final offset = Tween<Offset>(
                    begin: const Offset(1, 0), // fully off-screen on the right
                    end: Offset.zero,
                  ).animate(animation);
                  return SlideTransition(position: offset, child: child);
                },
              ),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: const Center(child: Text('I slid in from the right!')),
    );
  }
}
