import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/classifier.dart';

enum PhotoSource { camera, gallery, download }

extension PhotoSourceX on PhotoSource {
  String get label => switch (this) {
        PhotoSource.camera => 'Camera',
        PhotoSource.gallery => 'Gallery',
        PhotoSource.download => 'Download',
      };

  IconData get icon => switch (this) {
        PhotoSource.camera => Icons.photo_camera_outlined,
        PhotoSource.gallery => Icons.photo_library_outlined,
        PhotoSource.download => Icons.cloud_download_outlined,
      };
}

class ClassificationRecord {
  ClassificationRecord({
    required this.bytes,
    required this.predictions,
    required this.source,
    required this.inferenceMs,
  }) : createdAt = DateTime.now();

  final Uint8List bytes;
  final List<Prediction> predictions; 
  final PhotoSource source;
  final int inferenceMs;
  final DateTime createdAt;

  Prediction get top => predictions.first;
}
