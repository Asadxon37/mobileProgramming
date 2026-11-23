import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/message_banner.dart';
import 'app_shell.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                ),
                child: Icon(Icons.center_focus_strong, size: 40, color: scheme.onPrimaryContainer),
              ),
              const SizedBox(height: AppSpacing.l),
              Text('SpotIt', style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Point your phone at an object and SpotIt tells you which of your '
                'own trained classes it sees. Everything runs offline on this device.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.l),
              switch (app.status) {
                LoadStatus.loading => Row(
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Text('Loading model…', style: theme.textTheme.bodyMedium),
                    ],
                  ),
                LoadStatus.failed => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MessageBanner(message: app.loadError ?? 'The model could not be loaded.'),
                      const SizedBox(height: AppSpacing.m),
                      OutlinedButton.icon(
                        onPressed: app.load,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try again'),
                      ),
                    ],
                  ),
                LoadStatus.ready => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('It recognises ${app.classifier.labels.length} things:',
                          style: theme.textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.s),
                      Wrap(
                        spacing: AppSpacing.s,
                        runSpacing: AppSpacing.s,
                        children: [for (final l in app.classifier.labels) Chip(label: Text(l))],
                      ),
                    ],
                  ),
              },
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: app.status == LoadStatus.ready
                    ? () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(builder: (_) => const AppShell()),
                        )
                    : null,
                child: const Text('Get started'),
              ),
              const SizedBox(height: AppSpacing.l),
              Text('Design: ${DesignCredit.name} by ${DesignCredit.author}',
                  style: theme.textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}
