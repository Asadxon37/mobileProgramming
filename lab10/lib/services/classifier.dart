import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import 'labels.dart';

class Prediction {
  const Prediction(this.label, this.confidence);
  final String label;
  final double confidence; 
}

class ModelLoadException implements Exception {
  ModelLoadException(this.assetPath, this.detail);

  final String assetPath;
  final String detail;

  String get message =>
      'Could not load "$assetPath".\n'
      'Expected the file in assets/model/ and declared in pubspec.yaml '
      'under flutter: assets: - assets/model/\n\nDetails: $detail';

  @override
  String toString() => message;
}

class Classifier {
  Classifier._(this._interpreter, this.labels);

  final Interpreter _interpreter;
  final List<String> labels;

  static const modelAsset = 'assets/model/model_unquant.tflite';
  static const labelsAsset = 'assets/model/labels.txt';
  static const inputSize = 224;

  static Future<Classifier> load() async {
    final String rawLabels;
    try {
      rawLabels = await rootBundle.loadString(labelsAsset);
    } catch (e) {
      throw ModelLoadException(labelsAsset, '$e');
    }

    final Interpreter interpreter;
    try {
      interpreter = await Interpreter.fromAsset(modelAsset);
    } catch (e) {
      throw ModelLoadException(modelAsset, '$e');
    }

    final labels = parseLabels(rawLabels);
    final outputClasses = interpreter.getOutputTensor(0).shape.last;
    if (labels.isEmpty || outputClasses != labels.length) {
      interpreter.close();
      throw ModelLoadException(
        labelsAsset,
        'labels.txt has ${labels.length} lines but the model outputs '
        '$outputClasses classes. Re-export both files from the same project.',
      );
    }
    return Classifier._(interpreter, labels);
  }

  /// Returns one [Prediction] per label, sorted from highest to lowest.
  /// Throws [FormatException] if [bytes] are not a readable image.
  List<Prediction> classify(Uint8List bytes) {
    img.Image? decoded;
    try {
      decoded = img.decodeImage(bytes);
    } catch (_) {
      decoded = null;
    }
    if (decoded == null) throw const FormatException('Not a readable image');

    final square = img.copyResizeCropSquare(
      img.bakeOrientation(decoded),
      size: inputSize,
    );

    final input = [
      List.generate(
        inputSize,
        (y) => List.generate(inputSize, (x) {
          final p = square.getPixel(x, y);
          return [p.r / 127.5 - 1, p.g / 127.5 - 1, p.b / 127.5 - 1];
        }),
      ),
    ];

    final output = [List<double>.filled(labels.length, 0)];
    _interpreter.run(input, output);

    return [
      for (var i = 0; i < labels.length; i++)
        Prediction(labels[i], output.first[i]),
    ]..sort((a, b) => b.confidence.compareTo(a.confidence));
  }

  void close() => _interpreter.close();
}
