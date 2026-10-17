// Task 4.5 - Result from a named route
// If the user returns with the back arrow, pushNamed completes with null.
// Home then keeps the previous state (here: "Not rated yet" or old rating).
import 'package:flutter/material.dart';

void main() => runApp(const Task45());

class Task45 extends StatelessWidget {
  const Task45({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (c) => const _HomeScreen(),
          '/rate': (c) => const _RateScreen(),
        },
      );
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  static const _movie = 'Inception';
  int? _rating;

  Future<void> _rate() async {
    final rating =
        await Navigator.pushNamed<int>(context, '/rate', arguments: _movie);
    if (!mounted) return;
    if (rating != null) setState(() => _rating = rating);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(_movie, style: TextStyle(fontSize: 26)),
            const SizedBox(height: 8),
            Text(
              _rating == null ? 'Not rated yet' : 'Movie: $_rating/5',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _rate, child: const Text('Rate it')),
          ],
        ),
      ),
    );
  }
}

class _RateScreen extends StatelessWidget {
  const _RateScreen();

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text('Rate: $movie')),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 1; i <= 5; i++)
              IconButton(
                iconSize: 40,
                color: Colors.amber,
                icon: Icon(Icons.star, semanticLabel: '$i stars'),
                onPressed: () => Navigator.pop(context, i),
              ),
          ],
        ),
      ),
    );
  }
}
