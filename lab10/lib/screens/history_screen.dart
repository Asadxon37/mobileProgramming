import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/record_tile.dart';
import 'result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final items = app.history;

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history, size: 64, color: scheme.outline),
                    const SizedBox(height: AppSpacing.m),
                    Text('No classifications yet', style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      'Take a photo, pick one from the gallery or download an image. '
                      'Every result shows up here.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.m),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s),
              itemBuilder: (context, i) => RecordTile(
                record: items[i],
                
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => ResultScreen(record: items[i])),
                ),
              ),
            ),
    );
  }
}
