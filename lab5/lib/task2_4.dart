// Task 2.4 - Drawer navigation
// pushReplacementNamed keeps the stack at one screen when switching sections.
import 'package:flutter/material.dart';

void main() => runApp(const Task24());

class Task24 extends StatelessWidget {
  const Task24({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (c) => const _Section('Home', Icons.home),
          '/profile': (c) => const _Section('Profile', Icons.person),
          '/messages': (c) => const _Section('Messages', Icons.message),
          '/about': (c) => const _Section('About', Icons.info),
        },
      );
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  const _Section(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const _AppDrawer(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 12),
            Text('Can pop: ${Navigator.canPop(context)}'),
          ],
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  static const _items = <(String, String, IconData)>[
    ('/', 'Home', Icons.home),
    ('/profile', 'Profile', Icons.person),
    ('/messages', 'Messages', Icons.message),
    ('/about', 'About', Icons.info),
  ];

  @override
  Widget build(BuildContext context) {
    final current = ModalRoute.of(context)?.settings.name;
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text('Menu', style: TextStyle(fontSize: 24)),
          ),
          for (final (route, label, icon) in _items)
            ListTile(
              leading: Icon(icon),
              title: Text(label),
              selected: route == current,
              onTap: () {
                Navigator.pop(context); // close the drawer first
                if (route != current) {
                  Navigator.pushReplacementNamed(context, route);
                }
              },
            ),
        ],
      ),
    );
  }
}
