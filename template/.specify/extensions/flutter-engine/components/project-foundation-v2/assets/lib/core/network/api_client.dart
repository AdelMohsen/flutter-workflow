import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../app/app_config.dart';
import '../debug/app_logger.dart';
import '../errors/app_error.dart';

typedef HeaderProvider = Future<Map<String, String>> Function();

final class ApiClient {
  ApiClient({required AppConfig config, required HeaderProvider headers})
    : _config = config,
      _headers = headers,
      _dio = Dio(
        BaseOptions(
          baseUrl: config.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          contentType: Headers.jsonContentType,
          headers: const {'Accept': Headers.jsonContentType},
        ),
      ) {
    _dio.interceptors.add(_SafeLogInterceptor(config.traceNetworkBodies));
  }

  final AppConfig _config;
  final HeaderProvider _headers;
  final Dio _dio;

  bool get isConfigured => _config.hasConfiguredApi;

  Future<AppResult<T>> request<T>(
    String path, {
    String method = 'GET',
    Object? data,
    Map<String, dynamic>? query,
    required T Function(Object? json) decode,
  }) async {
    if (!_config.hasConfiguredApi) {
      return const AppFailureResult(
        AppFailure(message: 'API base URL is not configured'),
      );
    }

    try {
      final response = await _dio.request<Object?>(
        path,
        data: data,
        queryParameters: query,
        options: Options(method: method, headers: await _headers()),
      );
      return AppSuccess(decode(response.data));
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'HTTP',
        'Request failed',
        error: error.type,
        stackTrace: stackTrace,
        data: {
          'method': method,
          'path': path,
          'status': error.response?.statusCode,
        },
      );
      final raw = error.response?.data;
      final apiError = ApiErrorModel.fromJson(
        raw is Map<String, dynamic> ? raw : {'message': error.message},
        statusCode: error.response?.statusCode,
      );
      return AppFailureResult(AppFailure.fromApi(apiError));
    }
  }
}

final class _SafeLogInterceptor extends Interceptor {
  _SafeLogInterceptor(this.traceBodies);

  final bool traceBodies;
  final _startedAt = <int, DateTime>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _startedAt[options.hashCode] = DateTime.now();
      AppLogger.debug(
        'HTTP',
        '${options.method} ${options.path}',
        data: {
          'headers': options.headers,
          'query_keys': options.queryParameters.keys.toList(growable: false),
          if (traceBodies) 'body': options.data,
        },
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<Object?> response,
    ResponseInterceptorHandler handler,
  ) {
    final started = _startedAt.remove(response.requestOptions.hashCode);
    AppLogger.debug(
      'HTTP',
      '${response.statusCode} ${response.requestOptions.path}',
      data: {
        if (started != null)
          'duration_ms': DateTime.now().difference(started).inMilliseconds,
        if (traceBodies) 'body': response.data,
      },
    );
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    _startedAt.remove(error.requestOptions.hashCode);
    handler.next(error);
  }
}
