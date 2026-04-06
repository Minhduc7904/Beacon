import 'package:dio/dio.dart';
import '../errors/exceptions.dart';
import 'api_response.dart';

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
      _throwByStatusCode(statusCode, apiResponse.message);
    }

    return apiResponse;
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
