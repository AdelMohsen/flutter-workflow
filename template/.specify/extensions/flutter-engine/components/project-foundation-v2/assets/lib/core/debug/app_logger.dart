import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

abstract final class AppLogger {
  static const _sensitiveKeys = {
    'authorization',
    'cookie',
    'password',
    'token',
    'access_token',
    'refresh_token',
    'api_key',
    'apikey',
    'x-api-key',
    'otp',
    'secret',
  };

  static void debug(String tag, String message, {Object? data}) =>
      _write(tag, message, data: data);

  static void info(String tag, String message, {Object? data}) =>
      _write(tag, message, data: data, level: 800);

  static void warning(String tag, String message, {Object? data}) =>
      _write(tag, message, data: data, level: 900);

  static void error(
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Object? data,
  }) => _write(
    tag,
    message,
    data: data,
    level: 1000,
    error: error,
    stackTrace: stackTrace,
  );

  static Object? sanitize(Object? value, {String? key}) {
    if (key != null && _isSensitiveKey(key)) {
      return '<redacted>';
    }
    return switch (value) {
      Map<Object?, Object?> map => {
        for (final entry in map.entries)
          entry.key.toString(): sanitize(
            entry.value,
            key: entry.key.toString(),
          ),
      },
      Iterable<Object?> values => values.map(sanitize).toList(growable: false),
      _ => value,
    };
  }

  static bool _isSensitiveKey(String key) {
    final normalized = key.toLowerCase().replaceAll('-', '_');
    return _sensitiveKeys.contains(key.toLowerCase()) ||
        _sensitiveKeys.any(normalized.contains);
  }

  static void _write(
    String tag,
    String message, {
    Object? data,
    int level = 500,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;
    developer.log(
      data == null ? message : '$message | ${sanitize(data)}',
      name: tag,
      level: level,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
