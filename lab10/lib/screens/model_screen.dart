import 'package:flutter/material.dart';

import '../services/classifier.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';

class ModelScreen extends StatelessWidget {
  const ModelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = AppScope.of(context).classifier.labels;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Model')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: [
          AppCard(
            child: Column(
              children: [
                _Fact(label: 'Classes', value: '${labels.length}'),
                _Fact(
                  label: 'Input size',
                  value: '${Classifier.inputSize} × ${Classifier.inputSize} × 3',
                ),
                _Fact(label: 'Model file', value: Classifier.modelAsset.split('/').last),
                _Fact(label: 'Labels file', value: Classifier.labelsAsset.split('/').last),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.l),
          Text('Labels', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              for (var i = 0; i < labels.length; i++) Chip(label: Text('$i  ${labels[i]}')),
            ],
          ),
          const SizedBox(height: AppSpacing.l),
          Text('Design credit', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s),
          AppCard(child: Text(DesignCredit.text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
