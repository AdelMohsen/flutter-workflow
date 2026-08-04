// ignore_for_file: avoid_relative_lib_imports

import 'package:flutter_test/flutter_test.dart';

import '../lib/core/debug/app_logger.dart';

void main() {
  test('redacts nested sensitive values', () {
    final sanitized =
        AppLogger.sanitize({
              'Authorization': 'Bearer secret',
              'nested': {
                'password': 'secret',
                'x-api-key': 'secret',
                'message': 'safe',
              },
            })
            as Map<String, Object?>;

    expect(sanitized['Authorization'], '<redacted>');
    expect(
      (sanitized['nested'] as Map<String, Object?>)['password'],
      '<redacted>',
    );
    expect(
      (sanitized['nested'] as Map<String, Object?>)['x-api-key'],
      '<redacted>',
    );
    expect((sanitized['nested'] as Map<String, Object?>)['message'], 'safe');
  });
}
