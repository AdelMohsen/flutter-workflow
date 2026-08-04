sealed class AppResult<T> {
  const AppResult();
}

final class AppSuccess<T> extends AppResult<T> {
  const AppSuccess(this.value);
  final T value;
}

final class AppFailureResult<T> extends AppResult<T> {
  const AppFailureResult(this.failure);
  final AppFailure failure;
}

final class ApiErrorModel {
  const ApiErrorModel({
    required this.message,
    this.code,
    this.statusCode,
    this.fieldErrors = const {},
    this.raw = const {},
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json, {int? statusCode}) {
    final errors = json['errors'];
    return ApiErrorModel(
      message: (json['message'] ?? json['error'] ?? 'Request failed')
          .toString(),
      code: json['code']?.toString(),
      statusCode: statusCode,
      fieldErrors: errors is Map
          ? errors.map((key, value) => MapEntry(key.toString(), value))
          : const {},
      raw: Map.unmodifiable(json),
    );
  }

  final String message;
  final String? code;
  final int? statusCode;
  final Map<String, dynamic> fieldErrors;
  final Map<String, dynamic> raw;
}

final class AppFailure {
  const AppFailure({
    required this.message,
    this.code,
    this.statusCode,
    this.fieldErrors = const {},
  });

  factory AppFailure.fromApi(ApiErrorModel error) => AppFailure(
    message: error.message,
    code: error.code,
    statusCode: error.statusCode,
    fieldErrors: error.fieldErrors,
  );

  final String message;
  final String? code;
  final int? statusCode;
  final Map<String, dynamic> fieldErrors;
}
