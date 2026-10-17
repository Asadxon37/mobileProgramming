// Navigation & Routing in Flutter - Lab 5
// Launcher that lists all 30 tasks. Tap a task to run it; use the round
// menu button (bottom-left) to come back to this list.
//
// Setup:  flutter pub add go_router     (needed for Category 6)
// Run one task alone:  flutter run -t lib/task1_2.dart
import 'package:flutter/material.dart';

import 'task1_1.dart' as t11;
import 'task1_2.dart' as t12;
import 'task1_3.dart' as t13;
import 'task1_4.dart' as t14;
import 'task1_5.dart' as t15;
import 'task2_1.dart' as t21;
import 'task2_2.dart' as t22;
import 'task2_3.dart' as t23;
import 'task2_4.dart' as t24;
import 'task2_5.dart' as t25;
import 'task3_1.dart' as t31;
import 'task3_2.dart' as t32;
import 'task3_3.dart' as t33;
import 'task3_4.dart' as t34;
import 'task3_5.dart' as t35;
import 'task4_1.dart' as t41;
import 'task4_2.dart' as t42;
import 'task4_3.dart' as t43;
import 'task4_4.dart' as t44;
import 'task4_5.dart' as t45;
import 'task5_1.dart' as t51;
import 'task5_2.dart' as t52;
import 'task5_3.dart' as t53;
import 'task5_4.dart' as t54;
import 'task5_5.dart' as t55;
import 'task6_1.dart' as t61;
import 'task6_2.dart' as t62;
import 'task6_3.dart' as t63;
import 'task6_4.dart' as t64;
import 'task6_5.dart' as t65;

void main() => runApp(const LabRoot());

class _Task {
  final String id;
  final String title;
  final int stars; // 0 = solved sample
  final int points;
  final Widget Function() build;
  const _Task(this.id, this.title, this.stars, this.points, this.build);
}

class _Category {
  final String title;
  final List<_Task> tasks;
  const _Category(this.title, this.tasks);
}

final List<_Category> _categories = [
  _Category('1. Navigator: push and pop', [
    _Task('1.1', 'Two screens with push and pop', 0, 0, () => const t11.Task11()),
    _Task('1.2', 'Three-screen chain', 1, 10, () => const t12.Task12()),
    _Task('1.3', 'Replace, do not stack', 1, 10, () => const t13.Task13()),
    _Task('1.4', 'Back to the start', 2, 15, () => const t14.Task14()),
    _Task('1.5', 'Smart back button', 2, 15, () => const t15.Task15()),
  ]),
  _Category('2. Named routes', [
    _Task('2.1', 'Route table and pushNamed', 0, 0, () => const t21.Task21()),
    _Task('2.2', 'Menu with four routes', 1, 10, () => const t22.Task22()),
    _Task('2.3', 'Page not found', 2, 15, () => const t23.Task23()),
    _Task('2.4', 'Drawer navigation', 2, 15, () => const t24.Task24()),
    _Task('2.5', 'Log out', 3, 20, () => const t25.Task25()),
  ]),
  _Category('3. Passing arguments with constructors', [
    _Task('3.1', 'Product list to product details', 0, 0, () => const t31.Task31()),
    _Task('3.2', 'Greeting', 1, 10, () => const t32.Task32()),
    _Task('3.3', 'Contact card', 2, 15, () => const t33.Task33()),
    _Task('3.4', 'Pick a colour (result back)', 2, 20, () => const t34.Task34()),
    _Task('3.5', 'Edit a counter', 3, 20, () => const t35.Task35()),
  ]),
  _Category('4. Passing arguments with named routes', [
    _Task('4.1', 'ScreenArguments class', 0, 0, () => const t41.Task41()),
    _Task('4.2', 'Send a number', 1, 10, () => const t42.Task42()),
    _Task('4.3', 'User profile', 2, 15, () => const t43.Task43()),
    _Task('4.4', 'onGenerateRoute', 3, 20, () => const t44.Task44()),
    _Task('4.5', 'Result from a named route', 3, 20, () => const t45.Task45()),
  ]),
  _Category('5. Simple transition animations', [
    _Task('5.1', 'Fade transition', 0, 0, () => const t51.Task51()),
    _Task('5.2', 'Slide from the right', 1, 10, () => const t52.Task52()),
    _Task('5.3', 'Slide from the bottom', 2, 15, () => const t53.Task53()),
    _Task('5.4', 'Scale and fade together', 2, 15, () => const t54.Task54()),
    _Task('5.5', 'Reusable route and global theme', 3, 20, () => const t55.Task55()),
  ]),
  _Category('6. go_router', [
    _Task('6.1', 'First router: go, push and pop', 0, 0, () => const t61.Task61()),
    _Task('6.2', 'Path parameters', 1, 10, () => const t62.Task62()),
    _Task('6.3', 'Passing an object with extra', 2, 15, () => const t63.Task63()),
    _Task('6.4', 'Named routes and 404 page', 2, 15, () => const t64.Task64()),
    _Task('6.5', 'Transition in go_router', 3, 20, () => const t65.Task65()),
  ]),
];

/// Shows the task list, or the selected task (a full MaterialApp of its own).
class LabRoot extends StatefulWidget {
  const LabRoot({super.key});

  @override
  State<LabRoot> createState() => _LabRootState();
}

class _LabRootState extends State<LabRoot> {
  Widget? _active;

  @override
  Widget build(BuildContext context) {
    final active = _active;
    if (active == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Navigation Lab',
        theme: ThemeData(colorSchemeSeed: Colors.indigo),
        home: _Launcher(onOpen: (t) => setState(() => _active = t.build())),
      );
    }
    final bottom = MediaQueryData.fromView(View.of(context)).padding.bottom;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        fit: StackFit.expand,
        children: [
          active,
          Positioned(
            left: 8,
            bottom: 8 + bottom,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => setState(() => _active = null),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.apps, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Launcher extends StatelessWidget {
  final void Function(_Task) onOpen;
  const _Launcher({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation & Routing Lab')),
      body: ListView(
        children: [
          for (final cat in _categories)
            ExpansionTile(
              title: Text(cat.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              initiallyExpanded: cat == _categories.first,
              children: [
                for (final t in cat.tasks)
                  ListTile(
                    leading: CircleAvatar(child: Text(t.id)),
                    title: Text(t.title),
                    subtitle: Text(t.stars == 0
                        ? 'Solved sample'
                        : '${'\u2605' * t.stars}  \u2022  ${t.points} pts'),
                    trailing: const Icon(Icons.play_arrow),
                    onTap: () => onOpen(t),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
