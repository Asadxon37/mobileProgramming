import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Task9()));

class Task9 extends StatelessWidget {
  const Task9({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Controls')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BottomNavDemo()),
              ),
              child: const Text('BottomNavigationBar Demo'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TabBarDemo()),
              ),
              child: const Text('TabBar Demo'),
            ),
          ],
        ),
      ),
    );
  }
}

// 9.1
class BottomNavDemo extends StatefulWidget {
  const BottomNavDemo({super.key});

  @override
  State<BottomNavDemo> createState() => _BottomNavDemoState();
}

class _BottomNavDemoState extends State<BottomNavDemo> {
  int index = 0;

  final pages = const [
    Center(child: Text('Home View', style: TextStyle(fontSize: 24))),
    Center(child: Text('Search View', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profile View', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bottom Navigation')),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// 9.2
class TabBarDemo extends StatelessWidget {
  const TabBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Top Tabs'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat), text: 'Chats'),
              Tab(icon: Icon(Icons.call), text: 'Calls'),
              Tab(icon: Icon(Icons.group), text: 'Groups'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Chats Tab', style: TextStyle(fontSize: 24))),
            Center(child: Text('Calls Tab', style: TextStyle(fontSize: 24))),
            Center(child: Text('Groups Tab', style: TextStyle(fontSize: 24))),
          ],
        ),
      ),
    );
  }
}
