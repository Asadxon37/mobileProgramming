import 'package:flutter/material.dart';

import '../models/classification_record.dart';
import '../services/image_sources.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/message_banner.dart';
import 'result_screen.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final _controller = TextEditingController();
  String? _stage; 
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final app = AppScope.of(context);
    FocusScope.of(context).unfocus();
    setState(() {
      _error = null;
      _stage = 'Downloading…';
    });
    try {
      final bytes = await app.sources.fromUrl(_controller.text);
      if (!mounted) return;
      setState(() => _stage = 'Classifying…');
      final record = await app.classify(bytes, PhotoSource.download);
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => ResultScreen(record: record)),
      );
      return; 
    } on ImageSourceException catch (e) {
      _error = e.message;
    } on FormatException {
      _error = 'The download worked, but the file is not a picture the app can read.';
    } catch (e) {
      _error = 'Something went wrong: $e';
    }
    if (mounted) setState(() => _stage = null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final busy = _stage != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Download an image')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.m),
          children: [
            Text(
              'Paste a direct link to a picture (it must end up as an image, '
              'not a web page).',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.m),
            TextField(
              controller: _controller,
              enabled: !busy,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.go,
              onSubmitted: (_) => _start(),
              decoration: const InputDecoration(
                labelText: 'Image address',
                hintText: 'https://example.com/photo.jpg',
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            if (_error != null) ...[
              MessageBanner(message: _error!),
              const SizedBox(height: AppSpacing.m),
            ],
            if (busy) ...[
              const LinearProgressIndicator(),
              const SizedBox(height: AppSpacing.s),
              Text(_stage!, style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.m),
            ],
            FilledButton.icon(
              onPressed: busy ? null : _start,
              icon: const Icon(Icons.cloud_download_outlined),
              label: const Text('Download and classify'),
            ),
          ],
        ),
      ),
    );
  }
}
