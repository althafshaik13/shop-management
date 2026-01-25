enum ErrorType {
  networkError,
  serverError,
  authError,
  apiError,
  notFound,
  cancelError,
  validationError,
  unknown,
}

class AppError implements Exception {
  final String message;
  final ErrorType type;
  final int? statusCode;
  final dynamic data;

  AppError({
    required this.message,
    required this.type,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => message;
}
