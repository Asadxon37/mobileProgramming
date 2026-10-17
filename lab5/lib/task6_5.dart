// Task 6.5 - Transition in go_router
// One helper (buildPage) gives every route the same slide + scale transition.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Reusable page with a slide-from-right + scale transition.
/// state.pageKey is passed so go_router can tell pages apart.
CustomTransitionPage<void> buildPage(Widget child, GoRouterState state) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
      final slide = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(curved);
      final scale = Tween<double>(begin: 0.9, end: 1.0).animate(curved);
      return SlideTransition(
        position: slide,
        child: ScaleTransition(scale: scale, child: child),
      );
    },
  );
}

GoRouter _createRouter() => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              buildPage(const _HomeScreen(), state),
        ),
        GoRoute(
          path: '/details',
          pageBuilder: (context, state) =>
              buildPage(const _SimpleScreen('Details'), state),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) =>
              buildPage(const _SimpleScreen('Settings'), state),
        ),
      ],
    );

void main() => runApp(const Task65());

class Task65 extends StatefulWidget {
  const Task65({super.key});

  @override
  State<Task65> createState() => _Task65State();
}

class _Task65State extends State<Task65> {
  final _router = _createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
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
              onPressed: () => context.push('/details'),
              child: const Text('Details'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.push('/settings'),
              child: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleScreen extends StatelessWidget {
  final String title;
  const _SimpleScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.pop(),
          child: const Text('Back'),
        ),
      ),
    );
  }
}
