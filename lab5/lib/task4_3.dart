// Task 4.3 - User profile (object as a named-route argument)
import 'package:flutter/material.dart';

class _User {
  final String name;
  final int age;
  final String city;
  const _User(this.name, this.age, this.city);
}

const _users = [
  _User('Alice', 25, 'Tashkent'),
  _User('Bob', 31, 'Samarkand'),
  _User('Carol', 28, 'Bukhara'),
  _User('David', 40, 'Khiva'),
];

void main() => runApp(const Task43());

class Task43 extends StatelessWidget {
  const Task43({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (c) => const _UserListScreen(),
          '/profile': (c) => const _ProfileScreen(),
        },
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
        ],
      ),
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as _User;
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
