// Task 5.5 - Reusable route and global theme
//
// Part 1: FadeRoute - any push becomes Navigator.push(context, FadeRoute(page)).
// Part 2: ThemeData.pageTransitionsTheme changes the transition of every
//         MaterialPageRoute in the app. Here Android uses the iOS (Cupertino)
//         slide + swipe-back gesture. Compare "Default route" (theme applies)
//         with "FadeRoute" (custom route ignores the theme).
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const Task55());

/// Part 1: reusable fade route.
class FadeRoute extends PageRouteBuilder {
  FadeRoute(Widget page)
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
}

class Task55 extends StatelessWidget {
  const Task55({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        // Part 2: global transition for MaterialPageRoute.
        theme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              // Every platform, so the effect is also visible on desktop/Chrome.
              for (final p in TargetPlatform.values)
                p: const CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        home: const _HomeScreen(),
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
                FadeRoute(const _DetailsScreen('FadeRoute (custom)')),
              ),
              child: const Text('Open with FadeRoute'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const _DetailsScreen('MaterialPageRoute + theme'),
                ),
              ),
              child: const Text('Open with default route (theme)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsScreen extends StatelessWidget {
  final String label;
  const _DetailsScreen(this.label);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(child: Text(label)),
    );
  }
}
