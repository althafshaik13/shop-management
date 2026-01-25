import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../errors/app_error.dart';

class ApiClient {
  late final Dio _dio;
  final Logger _logger = Logger();
  final SharedPreferences _prefs;

  ApiClient(this._prefs) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: AppConstants.connectionTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: AppConstants.receiveTimeout,
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _prefs.getString(AppConstants.authTokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          _logger.d('Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d(
            'Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger.e('Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> uploadFile(
    String path,
    String filePath,
    String folderType,
  ) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        'folderType': folderType,
      });

      return await _dio.post(
        path,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AppError _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppError(
          message: 'Connection timeout. Please try again.',
          type: ErrorType.networkError,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message =
            error.response?.data['message'] ??
            error.response?.data['error'] ??
            'Something went wrong';

        if (statusCode == 401) {
          return AppError(
            message: 'Unauthorized. Please login again.',
            type: ErrorType.authError,
          );
        } else if (statusCode == 404) {
          return AppError(
            message: 'Resource not found',
            type: ErrorType.notFound,
          );
        } else if (statusCode! >= 500) {
          return AppError(
            message: 'Server error. Please try again later.',
            type: ErrorType.serverError,
          );
        }

        return AppError(message: message, type: ErrorType.apiError);
      case DioExceptionType.cancel:
        return AppError(
          message: 'Request cancelled',
          type: ErrorType.cancelError,
        );
      default:
        return AppError(
          message: 'No internet connection',
          type: ErrorType.networkError,
        );
    }
  }
}
