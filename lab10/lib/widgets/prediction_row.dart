import 'package:flutter/material.dart';

import '../services/classifier.dart';
import '../theme/app_theme.dart';

String percentText(double confidence) => '${(confidence * 100).toStringAsFixed(1)} %';

/// One row: label name, bar, percentage. The top row is [emphasized].
class PredictionRow extends StatelessWidget {
  const PredictionRow({super.key, required this.prediction, this.emphasized = false});

  final Prediction prediction;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final base = emphasized ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium;
    final style = base?.copyWith(
      fontWeight: emphasized ? FontWeight.w700 : FontWeight.w400,
      color: emphasized ? scheme.primary : scheme.onSurface,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(prediction.label, style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radius),
              child: LinearProgressIndicator(
                value: prediction.confidence.clamp(0.0, 1.0).toDouble(),
                minHeight: emphasized ? 12 : 8,
                color: emphasized ? scheme.primary : scheme.outline,
                backgroundColor: scheme.surfaceContainerHighest,
              ),
            ),
          ),
          SizedBox(
            width: 76,
            child: Text(percentText(prediction.confidence), textAlign: TextAlign.right, style: style),
          ),
        ],
      ),
    );
  }
}
