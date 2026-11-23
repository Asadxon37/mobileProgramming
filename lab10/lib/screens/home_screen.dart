import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/classification_record.dart';
import '../services/image_sources.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/message_banner.dart';
import '../widgets/record_tile.dart';
import 'download_screen.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _busy = false;
  String? _error;

  Future<void> _run(PhotoSource source, Future<Uint8List?> Function() pick) async {
    final app = AppScope.of(context);
    setState(() => _error = null);
    try {
      final bytes = await pick();
      if (bytes == null) return; 
      if (!mounted) return;
      setState(() => _busy = true);
      final record = await app.classify(bytes, source);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => ResultScreen(record: record)),
      );
    } on ImageSourceException catch (e) {
      _showError(e.message);
    } on FormatException {
      _showError('That file is not a picture the app can read. Try a JPEG or PNG.');
    } catch (e) {
      _showError('Something went wrong: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(String message) {
    if (mounted) setState(() => _error = message);
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final theme = Theme.of(context);
    final latest = app.latest;

    return Scaffold(
      appBar: AppBar(title: const Text('SpotIt')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(AppSpacing.m),
            children: [
              Text('What are we looking at?', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.m),
              if (_error != null) ...[
                MessageBanner(message: _error!, onDismiss: () => setState(() => _error = null)),
                const SizedBox(height: AppSpacing.m),
              ],
              _ActionCard(
                icon: PhotoSource.camera.icon,
                title: 'Take a photo',
                subtitle: 'Use the phone camera',
                onTap: () => _run(PhotoSource.camera, app.sources.fromCamera),
              ),
              const SizedBox(height: AppSpacing.s),
              _ActionCard(
                icon: PhotoSource.gallery.icon,
                title: 'Choose from gallery',
                subtitle: 'Pick a picture you already have',
                onTap: () => _run(PhotoSource.gallery, app.sources.fromGallery),
              ),
              const SizedBox(height: AppSpacing.s),
              _ActionCard(
                icon: PhotoSource.download.icon,
                title: 'Download an image',
                subtitle: 'Paste a link to a picture',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const DownloadScreen()),
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Text('Latest result', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.s),
              if (latest == null)
                Text('Nothing classified yet.', style: theme.textTheme.bodyMedium)
              else
                RecordTile(
                  record: latest,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => ResultScreen(record: latest)),
                  ),
                ),
            ],
          ),
          if (_busy)
            Positioned.fill(
              child: ColoredBox(
                color: theme.colorScheme.surface,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: AppSpacing.m),
                      Text('Classifying…', style: theme.textTheme.bodyLarge),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: Icon(icon, color: scheme.onPrimaryContainer),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                Text(subtitle, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: scheme.outline),
        ],
      ),
    );
  }
}
