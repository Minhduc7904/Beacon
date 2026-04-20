import 'package:dio/dio.dart';
import '../errors/exceptions.dart';
import 'api_response.dart';

typedef ApiErrorMessageMapper = String? Function(String code);

class ApiHandler {
  ApiHandler._();
  /// {
  /// "success": true,
  /// "message": "Login successful",
  /// "data": {
  ///   "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMjM0NTY3ODkwIiwiaWF0IjoxNjg4ODg4ODg4LCJleHAiOjE2ODg4OTI0ODh9.abc123def456ghi789jkl012mno345pqr678stu901vwx234yz567890",
  ///   "refreshToken": "def456ghi789jkl012mno345pqr678stu901vwx234yz567890abc123",
  ///  "user": {
  ///  "id": "1234567890",
  /// "email": "
  /// }
  /// }

  /// Parse [Response] thành [ApiResponse<T>].
  ///
  /// - Nếu `success == true`  → trả về [ApiResponse<T>]
  /// - Nếu `success == false` → throw exception theo status code
  static ApiResponse<T> handle<T>(
    Response response, {
    T Function(dynamic json)? fromJsonT,
    ApiErrorMessageMapper? codeMessageMapper,
  }) {
    final statusCode = response.statusCode ?? 0;
    final body = response.data;

    if (body is! Map<String, dynamic>) {
      throw ServerException(
        message: 'Invalid response format',
        statusCode: statusCode,
      );
    }

    final apiResponse = ApiResponse<T>.fromJson(body, fromJsonT);

    if (!apiResponse.success) {
      final resolvedMessage = _resolveErrorMessage(
        statusCode: statusCode,
        code: apiResponse.code,
        apiMessage: apiResponse.message,
        codeMessageMapper: codeMessageMapper,
      );
      _throwByStatusCode(statusCode, resolvedMessage);
    }

    return apiResponse;
  }

  static Never rethrowDioException(
    DioException exception, {
    ApiErrorMessageMapper? codeMessageMapper,
  }) {
    final isNetworkLayerError =
        exception.type == DioExceptionType.connectionError ||
        exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.sendTimeout;

    if (isNetworkLayerError) {
      throw const NetworkException(message: 'Không thể kết nối đến máy chủ');
    }

    final statusCode = exception.response?.statusCode ?? 0;
    final responseBody = exception.response?.data;

    String apiMessage = '';
    String? code;
    if (responseBody is Map<String, dynamic>) {
      apiMessage = responseBody['message']?.toString() ?? '';
      code = responseBody['code']?.toString();
    }

    final resolvedMessage = _resolveErrorMessage(
      statusCode: statusCode,
      code: code,
      apiMessage: apiMessage,
      codeMessageMapper: codeMessageMapper,
      fallbackMessage: exception.message,
    );

    _throwByStatusCode(statusCode, resolvedMessage);
  }

  static String _resolveErrorMessage({
    required int statusCode,
    required String? code,
    required String apiMessage,
    ApiErrorMessageMapper? codeMessageMapper,
    String? fallbackMessage,
  }) {
    final normalizedCode = code?.trim();
    if (normalizedCode != null && normalizedCode.isNotEmpty) {
      final mappedMessage = codeMessageMapper?.call(normalizedCode)?.trim();
      if (mappedMessage != null && mappedMessage.isNotEmpty) {
        return mappedMessage;
      }
    }

    if (apiMessage.trim().isNotEmpty) {
      return apiMessage.trim();
    }

    if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
      return 'Internal server error';
    }

    if (fallbackMessage != null && fallbackMessage.trim().isNotEmpty) {
      return fallbackMessage.trim();
    }

    return 'Lỗi không xác định';
  }

  static Never _throwByStatusCode(int statusCode, String message) {
    switch (statusCode) {
      case 400:
        throw ServerException(message: message, statusCode: statusCode);
      case 401:
        throw UnauthorizedException(message: message);
      case 403:
        throw ServerException(message: message, statusCode: statusCode);
      case 404:
        throw ServerException(message: message, statusCode: statusCode);
      case 422:
        throw ServerException(message: message, statusCode: statusCode);
      case 500:
      case 502:
      case 503:
        throw ServerException(
          message: message.isNotEmpty ? message : 'Internal server error',
          statusCode: statusCode,
        );
      default:
        throw ServerException(message: message, statusCode: statusCode);
    }
  }
}
