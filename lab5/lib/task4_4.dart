// Task 4.4 - onGenerateRoute (no routes table)
// The route table is replaced by one function. It checks the argument type
// and builds ProfileScreen through its constructor, so the screen itself
// stays type-safe and does not need ModalRoute.
import 'package:flutter/material.dart';

class User {
  final String name;
  final int age;
  final String city;
  const User(this.name, this.age, this.city);
}

const _users = [
  User('Alice', 25, 'Tashkent'),
  User('Bob', 31, 'Samarkand'),
  User('Carol', 28, 'Bukhara'),
  User('David', 40, 'Khiva'),
];

void main() => runApp(const Task44());

class Task44 extends StatelessWidget {
  const Task44({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute(
                settings: settings, builder: (c) => const _UserListScreen());
          }
          if (settings.name == '/profile') {
            final args = settings.arguments;
            if (args is User) {
              return MaterialPageRoute(
                settings: settings,
                builder: (c) => _ProfileScreen(user: args),
              );
            }
            // Wrong or missing argument: show an error instead of crashing.
            return MaterialPageRoute(
              builder: (c) => const _ErrorScreen('Profile needs a User argument'),
            );
          }
          return null; // unknown route -> onUnknownRoute below
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (c) => _ErrorScreen('No route for ${settings.name}'),
        ),
      );
}

class _UserListScreen extends StatelessWidget {
  const _UserListScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: ListView(
        children: [
          for (final u in _users)
            ListTile(
              leading: CircleAvatar(child: Text(u.name[0])),
              title: Text(u.name),
              onTap: () =>
                  Navigator.pushNamed(context, '/profile', arguments: u),
            ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Open /profile with a wrong argument'),
            onTap: () =>
                Navigator.pushNamed(context, '/profile', arguments: 'oops'),
          ),
        ],
      ),
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  final User user;
  const _ProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user.name}', style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 8),
            Text('Age: ${user.age}', style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 8),
            Text('City: ${user.city}', style: const TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final String message;
  const _ErrorScreen(this.message);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(message)),
      );
}
