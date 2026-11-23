import 'package:flutter/material.dart';

import '../models/classification_record.dart';
import '../theme/app_theme.dart';
import '../widgets/prediction_row.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.record});

  final ClassificationRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxImageHeight = MediaQuery.sizeOf(context).height * 0.5;
    final total = record.predictions.fold<double>(0, (sum, p) => sum + p.confidence * 100);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.m),
            child: Chip(
              avatar: Icon(record.source.icon, size: 18),
              label: Text(record.source.label),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxImageHeight),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radius),
                    child: Image.memory(record.bytes, fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                'Source: ${record.source.label} · classified in ${record.inferenceMs} ms',
                style: theme.textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.l),
              Text('Classification', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              for (var i = 0; i < record.predictions.length; i++)
                PredictionRow(prediction: record.predictions[i], emphasized: i == 0),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Total: ${total.toStringAsFixed(1)} %',
                style: theme.textTheme.labelMedium,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
