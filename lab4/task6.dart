import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Task6()));

class Task6 extends StatefulWidget {
  const Task6({super.key});

  @override
  State<Task6> createState() => _Task6State();
}

class _Task6State extends State<Task6> {
  double volume = 50;
  DateTime? selectedDate;

  String _format(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd.$mm.${d.year}';
  }

  // 6.2
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sliders & Pickers')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 6.1
            const Icon(Icons.volume_up, size: 48),
            Text(
              'Volume: ${volume.round()}%',
              style: const TextStyle(fontSize: 22),
            ),
            Slider(
              value: volume,
              min: 0,
              max: 100,
              divisions: 100,
              label: '${volume.round()}%',
              onChanged: (v) => setState(() => volume = v),
            ),
            const SizedBox(height: 32),
            // 6.2
            ElevatedButton(
              onPressed: _pickDate,
              child: const Text('Pick Date'),
            ),
            const SizedBox(height: 12),
            Text(
              selectedDate == null
                  ? 'No date selected'
                  : 'Selected: ${_format(selectedDate!)}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
