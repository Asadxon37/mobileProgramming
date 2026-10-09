import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Task10()));

class Task10 extends StatelessWidget {
  const Task10({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = {
      'What is Flutter?':
          'Flutter is an open-source UI toolkit by Google for building natively compiled apps for mobile, web and desktop from a single codebase.',
      'What language does Flutter use?':
          'Flutter apps are written in Dart, a client-optimized language that compiles to native ARM code.',
      'What is a widget?':
          'A widget is a description of part of the user interface. Everything in Flutter, from layout to styling, is a widget.',
      'Stateless vs Stateful?':
          'A StatelessWidget never changes after being built, while a StatefulWidget holds mutable state and rebuilds with setState.',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Structural Containers')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // 10.1
          Card(
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.info, size: 36, color: Colors.blue),
              title: const Text(
                'Information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Learn more about Flutter widgets'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Action pressed')),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              'FAQ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          // 10.2
          ...faqs.entries.map(
            (e) => Card(
              child: ExpansionTile(
                title: Text(e.key),
                childrenPadding: const EdgeInsets.all(16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(e.value)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
