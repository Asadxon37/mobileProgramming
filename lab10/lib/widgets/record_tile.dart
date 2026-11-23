import 'package:flutter/material.dart';

import '../models/classification_record.dart';
import '../theme/app_theme.dart';
import 'app_card.dart';
import 'prediction_row.dart';

String timeText(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

class RecordTile extends StatelessWidget {
  const RecordTile({super.key, required this.record, required this.onTap});

  final ClassificationRecord record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.s),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radius / 2),
            child: Image.memory(
              record.bytes,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              cacheWidth: 128,
              gaplessPlayback: true,
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.top.label,
                    style: theme.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('${percentText(record.top.confidence)} · ${timeText(record.createdAt)}',
                    style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s),
            child: Tooltip(
              message: record.source.label,
              child: Icon(record.source.icon, color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
