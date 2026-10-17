// Task 3.3 - Contact card (pass the whole object)
import 'package:flutter/material.dart';

class _Contact {
  final String name;
  final String phone;
  final String email;
  const _Contact(this.name, this.phone, this.email);
}

const _contacts = [
  _Contact('Alice Johnson', '+1 555 0101', 'alice@example.com'),
  _Contact('Bob Smith', '+1 555 0102', 'bob@example.com'),
  _Contact('Carol White', '+1 555 0103', 'carol@example.com'),
  _Contact('David Brown', '+1 555 0104', 'david@example.com'),
  _Contact('Eve Davis', '+1 555 0105', 'eve@example.com'),
];

void main() => runApp(const Task33());

class Task33 extends StatelessWidget {
  const Task33({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _ContactListScreen(),
      );
}

class _ContactListScreen extends StatelessWidget {
  const _ContactListScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: ListView(
        children: [
          for (final c in _contacts)
            ListTile(
              leading: CircleAvatar(child: Text(c.name[0])),
              title: Text(c.name),
              subtitle: Text(c.phone),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => _ContactScreen(contact: c)),
              ),
            ),
        ],
      ),
    );
  }
}

class _ContactScreen extends StatelessWidget {
  final _Contact contact;
  const _ContactScreen({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(contact.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 12),
                  Text(contact.name, style: const TextStyle(fontSize: 22)),
                ]),
                const Divider(height: 28),
                Row(children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 12),
                  Text(contact.phone),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  const Icon(Icons.email),
                  const SizedBox(width: 12),
                  Text(contact.email),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
