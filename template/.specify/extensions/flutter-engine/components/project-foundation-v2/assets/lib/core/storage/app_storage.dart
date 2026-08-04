import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../debug/app_logger.dart';

final class AppStorage {
  AppStorage({required String namespace}) : _namespace = namespace;

  final String _namespace;
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  String _key(String key) => '${_namespace}_$key';

  Future<void> write(String key, String value) async {
    await _storage.write(key: _key(key), value: value);
    AppLogger.debug('STORAGE', 'Wrote encrypted key', data: {'key': key});
  }

  Future<String?> read(String key) async {
    final value = await _storage.read(key: _key(key));
    AppLogger.debug('STORAGE', 'Read encrypted key', data: {'key': key});
    return value;
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: _key(key));
    AppLogger.debug('STORAGE', 'Deleted encrypted key', data: {'key': key});
  }

  Future<void> clear() => _storage.deleteAll();

  Future<Map<String, String>> authHeaders() async {
    final token = await read('access_token');
    return token == null ? const {} : {'Authorization': 'Bearer $token'};
  }
}
