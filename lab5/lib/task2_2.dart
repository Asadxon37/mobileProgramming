// Task 2.2 - Menu with four routes
import 'package:flutter/material.dart';

class _AppRoutes {
  static const home = '/';
  static const profile = '/profile';
  static const messages = '/messages';
  static const about = '/about';
}

void main() => runApp(const Task22());

class Task22 extends StatelessWidget {
  const Task22({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: _AppRoutes.home,
        routes: {
          _AppRoutes.home: (c) => const _HomeScreen(),
          _AppRoutes.profile: (c) => const _SimpleScreen('Profile'),
          _AppRoutes.messages: (c) => const _SimpleScreen('Messages'),
          _AppRoutes.about: (c) => const _SimpleScreen('About'),
        },
      );
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () => Navigator.pushNamed(context, _AppRoutes.profile),
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Messages'),
            onTap: () => Navigator.pushNamed(context, _AppRoutes.messages),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () => Navigator.pushNamed(context, _AppRoutes.about),
          ),
        ],
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
      body: Center(child: Text('$title screen', style: const TextStyle(fontSize: 24))),
    );
  }
}
