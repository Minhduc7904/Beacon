import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

/// Base class cho tất cả Failure trong domain layer.
abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  String toString() => '$runtimeType: $message';
}

// ─── Infrastructure Failures ──────────────────────────────────────────────────

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error'});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'Unauthorized'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

// ─── Mapper: Exception → Failure ─────────────────────────────────────────────

extension ExceptionToFailure on Exception {
  Failure toFailure() {
    final e = this;
    if (e is DioException) {
      final responseMessage = e.response?.data?['message']?.toString().trim();

      switch (e.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return NetworkFailure(
            message: (responseMessage != null && responseMessage.isNotEmpty)
                ? responseMessage
                : 'Không thể kết nối đến máy chủ',
          );
        case DioExceptionType.badResponse:
          final statusCode = e.response?.statusCode;
          final message =
              (responseMessage != null && responseMessage.isNotEmpty)
              ? responseMessage
              : 'Lỗi máy chủ ($statusCode)';

          if (statusCode == 401) {
            return UnauthorizedFailure(message: message);
          }

          return ServerFailure(
            message: message,
            statusCode: statusCode,
          );
        default:
          return ServerFailure(
            message: (responseMessage != null && responseMessage.isNotEmpty)
                ? responseMessage
                : (e.message ?? 'Lỗi không xác định'),
          );
      }
    }
    if (e is UnauthorizedException) {
      return UnauthorizedFailure(message: e.message);
    }
    if (e is NetworkException) {
      return NetworkFailure(message: e.message);
    }
    if (e is CacheException) {
      return CacheFailure(message: e.message);
    }
    if (e is ServerException) {
      return ServerFailure(message: e.message, statusCode: e.statusCode);
    }
    return ServerFailure(message: e.toString());
  }
}
