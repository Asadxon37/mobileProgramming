import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Task8()));

class Task8 extends StatelessWidget {
  const Task8({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Colors.primaries;
    final icons = [
      Icons.landscape,
      Icons.beach_access,
      Icons.park,
      Icons.pets,
      Icons.local_florist,
      Icons.camera_alt,
      Icons.flight,
      Icons.directions_bike,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      // 8.1
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        padding: const EdgeInsets.all(12),
        children: List.generate(8, (i) {
          final color = colors[i % colors.length];
          final icon = icons[i];
          final tile = Container(
            decoration: BoxDecoration(
              color: color.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Icon(icon, size: 56, color: Colors.white)),
          );
          // 8.2
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullscreenPreview(
                    color: color.shade300,
                    icon: icon,
                    title: 'Image ${i + 1}',
                  ),
                ),
              );
            },
            child: Hero(tag: 'item$i', child: tile),
          );
        }),
      ),
    );
  }
}

class FullscreenPreview extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;

  const FullscreenPreview({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: SizedBox.expand(
          child: Center(child: Icon(icon, size: 160, color: Colors.white)),
        ),
      ),
    );
  }
}
