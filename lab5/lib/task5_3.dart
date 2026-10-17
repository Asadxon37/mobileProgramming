// Task 5.3 - Slide from the bottom ("sheet")
import 'package:flutter/material.dart';

void main() => runApp(const Task53());

class Task53 extends StatelessWidget {
  const Task53({super.key});

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const _DetailsScreen('Normal')),
              ),
              child: const Text('Open (default)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text('Open as a sheet'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    reverseTransitionDuration:
                        const Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const _DetailsScreen('Sheet'),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      final curved = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      );
                      final offset = Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(curved);
                      return SlideTransition(position: offset, child: child);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsScreen extends StatelessWidget {
  final String kind;
  const _DetailsScreen(this.kind);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$kind screen')),
      body: Center(child: Text('Opened as: $kind')),
    );
  }
}
