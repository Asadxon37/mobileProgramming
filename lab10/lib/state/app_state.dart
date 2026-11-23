import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

import '../models/classification_record.dart';
import '../services/classifier.dart';
import '../services/image_sources.dart';

enum LoadStatus { loading, ready, failed }

class AppState extends ChangeNotifier {
  LoadStatus status = LoadStatus.loading;
  String? loadError;

  Classifier? _classifier;
  final ImageSources sources = ImageSources();
  final List<ClassificationRecord> _history = [];

  /// Only valid once [status] is [LoadStatus.ready].
  Classifier get classifier => _classifier!;

  List<ClassificationRecord> get history => List.unmodifiable(_history);
  ClassificationRecord? get latest => _history.isEmpty ? null : _history.first;

  Future<void> load() async {
    status = LoadStatus.loading;
    loadError = null;
    notifyListeners();
    try {
      _classifier = await Classifier.load();
      status = LoadStatus.ready;
    } on ModelLoadException catch (e) {
      status = LoadStatus.failed;
      loadError = e.message;
    } catch (e) {
      status = LoadStatus.failed;
      loadError = 'Unexpected error while loading the model: $e';
    }
    notifyListeners();
    if (status == LoadStatus.ready && kDebugMode) {
      await _smokeTest();
    }
  }

  Future<void> _smokeTest() async {
    try {
      final data = await rootBundle.load('assets/model/sample.jpg');
      final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      final watch = Stopwatch()..start();
      final result = _classifier!.classify(bytes);
      watch.stop();
      var total = 0.0;
      for (final p in result) {
        debugPrint('${p.label}: ${(p.confidence * 100).toStringAsFixed(1)} %');
        total += p.confidence;
      }
      debugPrint('SMOKE TEST: ${result.length} labels, '
          'sum = ${total.toStringAsFixed(3)}, ${watch.elapsedMilliseconds} ms');
    } catch (e) {
      debugPrint('Smoke test skipped (add assets/model/sample.jpg to run it): $e');
    }
  }

  /// bytes -> classify -> history. Throws [FormatException] for unreadable images.
  Future<ClassificationRecord> classify(Uint8List bytes, PhotoSource source) async {

    await Future<void>.delayed(const Duration(milliseconds: 60));
    final watch = Stopwatch()..start();
    final predictions = classifier.classify(bytes);
    watch.stop();
    final record = ClassificationRecord(
      bytes: bytes,
      predictions: predictions,
      source: source,
      inferenceMs: watch.elapsedMilliseconds,
    );
    _history.insert(0, record);
    notifyListeners();
    return record;
  }

  @override
  void dispose() {
    _classifier?.close();
    super.dispose();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope found in the widget tree');
    return scope!.notifier!;
  }
}
