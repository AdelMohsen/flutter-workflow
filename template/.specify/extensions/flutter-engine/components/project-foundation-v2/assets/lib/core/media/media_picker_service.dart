import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

final class MediaSelection {
  const MediaSelection({
    required this.name,
    required this.size,
    this.path,
    this.bytes,
  });

  final String name;
  final int size;
  final String? path;
  final Uint8List? bytes;
}

final class MediaPickException implements Exception {
  const MediaPickException(this.message);
  final String message;

  @override
  String toString() => message;
}

final class MediaPickerService {
  MediaPickerService({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  Future<MediaSelection?> pickImage({
    ImageSource source = ImageSource.gallery,
    int maxBytes = 10 * 1024 * 1024,
  }) async {
    final file = await _imagePicker.pickImage(source: source);
    if (file == null) return null;
    final size = await file.length();
    _validateSize(size, maxBytes);
    return MediaSelection(
      name: file.name,
      path: kIsWeb ? null : file.path,
      bytes: kIsWeb ? await file.readAsBytes() : null,
      size: size,
    );
  }

  Future<MediaSelection?> pickFile({
    List<String>? allowedExtensions,
    int maxBytes = 20 * 1024 * 1024,
  }) async {
    final result = await FilePicker.pickFiles(
      type: allowedExtensions == null ? FileType.any : FileType.custom,
      allowedExtensions: allowedExtensions,
      withData: kIsWeb,
    );
    final file = result?.files.singleOrNull;
    if (file == null) return null;
    _validateSize(file.size, maxBytes);
    return MediaSelection(
      name: file.name,
      path: file.path,
      bytes: file.bytes,
      size: file.size,
    );
  }

  void _validateSize(int size, int maximum) {
    if (size > maximum) {
      throw MediaPickException('Selected file exceeds $maximum bytes');
    }
  }
}
