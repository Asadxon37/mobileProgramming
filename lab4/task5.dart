import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Task5()));

class Task5 extends StatefulWidget {
  const Task5({super.key});

  @override
  State<Task5> createState() => _Task5State();
}

class _Task5State extends State<Task5> {
  String result = 'Nothing yet';

  // 5.1
  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete item?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    setState(() => result = confirmed == true ? 'Item deleted' : 'Delete cancelled');
  }

  // 5.2
  void _showShareSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final options = {
          'Email': Icons.email,
          'Message': Icons.message,
          'Copy link': Icons.link,
        };
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.entries
                .map(
                  (e) => ListTile(
                    leading: Icon(e.value),
                    title: Text(e.key),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() => result = 'Shared via ${e.key}');
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dialogs & Modals')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(result, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _confirmDelete,
              child: const Text('Delete Item'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showShareSheet,
              child: const Text('Share'),
            ),
          ],
        ),
      ),
    );
  }
}
