import 'dart:async' show TimeoutException;
import 'dart:io' show SocketException;
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageSourceException implements Exception {
  ImageSourceException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ImageSources {
  final _picker = ImagePicker();

  Future<Uint8List?> fromCamera() => _pick(ImageSource.camera);

  Future<Uint8List?> fromGallery() => _pick(ImageSource.gallery);

  Future<Uint8List?> _pick(ImageSource source) async {
    try {

      final file = await _picker.pickImage(source: source, maxWidth: 1024);
      return file == null ? null : await file.readAsBytes();
    } catch (_) {
      throw ImageSourceException(
        source == ImageSource.camera
            ? 'The camera could not be opened. Check the camera permission '
                'in the phone settings.'
            : 'The gallery could not be opened. Check the photo permission '
                'in the phone settings.',
      );
    }
  }

  Future<Uint8List> fromUrl(String url) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null ||
        !(uri.scheme == 'http' || uri.scheme == 'https') ||
        uri.host.isEmpty) {
      throw ImageSourceException(
        'That is not a valid web address. It must start with http:// or https://',
      );
    }

    final http.Response response;
    try {
      response = await http
          .get(uri, headers: const {'User-Agent': 'SpotIt/1.0 (student lab app)'})
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw ImageSourceException(
        'The download took longer than 15 seconds. Try a smaller picture or a better connection.',
      );
    } on SocketException {
      throw ImageSourceException(
        'No network connection. Check your internet and try again.',
      );
    } on http.ClientException {
      throw ImageSourceException(
        'The server could not be reached. Check the address and your internet connection.',
      );
    } catch (_) {
      throw ImageSourceException('The download failed. Check the address and try again.');
    }

    if (response.statusCode != 200) {
      throw ImageSourceException(
        'The server answered with status ${response.statusCode} instead of 200. Check the address.',
      );
    }
    final type = (response.headers['content-type'] ?? '').toLowerCase();
    if (!type.startsWith('image/')) {
      throw ImageSourceException(
        'That address returned ${type.isEmpty ? 'unknown content' : type} instead of a picture. '
        'Use a direct link to an image file (.jpg or .png).',
      );
    }
    if (response.bodyBytes.isEmpty) {
      throw ImageSourceException('The server sent an empty file.');
    }
    return response.bodyBytes;
  }
}
