import 'package:flutter/material.dart';

import 'task1.dart';
import 'task2.dart';
import 'task3.dart';
import 'task4.dart';
import 'task5.dart';
import 'task6.dart';
import 'task7.dart';
import 'task8.dart';
import 'task9.dart';
import 'task10.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 4')),
      body: ListView(
        children: [
          ListTile(title: const Text('Task 1'), onTap: () => open(context, const Task1())),
          ListTile(title: const Text('Task 2'), onTap: () => open(context, const Task2())),
          ListTile(title: const Text('Task 3'), onTap: () => open(context, const Task3())),
          ListTile(title: const Text('Task 4'), onTap: () => open(context, const Task4())),
          ListTile(title: const Text('Task 5'), onTap: () => open(context, const Task5())),
          ListTile(title: const Text('Task 6'), onTap: () => open(context, const Task6())),
          ListTile(title: const Text('Task 7'), onTap: () => open(context, const Task7())),
          ListTile(title: const Text('Task 8'), onTap: () => open(context, const Task8())),
          ListTile(title: const Text('Task 9'), onTap: () => open(context, const Task9())),
          ListTile(title: const Text('Task 10'), onTap: () => open(context, const Task10())),
        ],
      ),
    );
  }
}
