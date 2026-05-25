import 'package:beacon_app/core/errors/exceptions.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _dioException({
  required DioExceptionType type,
  int? statusCode,
  dynamic data,
  String? message,
}) {
  final requestOptions = RequestOptions(path: '/test');
  return DioException(
    requestOptions: requestOptions,
    response: statusCode == null
        ? null
        : Response<dynamic>(
            requestOptions: requestOptions,
            statusCode: statusCode,
            data: data,
          ),
    type: type,
    message: message,
  );
}

void main() {
  group('ExceptionToFailure', () {
    test('map Dio 401 badResponse thành UnauthorizedFailure', () {
      final exception = _dioException(
        type: DioExceptionType.badResponse,
        statusCode: 401,
        data: {'message': 'API báo chưa xác thực'},
      );

      final failure = exception.toFailure();

      expect(failure, isA<UnauthorizedFailure>());
      expect(failure.message, 'API báo chưa xác thực');
      expect(failure.statusCode, isNull);
    });

    test('map Dio timeout thành NetworkFailure', () {
      final exception = _dioException(type: DioExceptionType.receiveTimeout);

      final failure = exception.toFailure();

      expect(failure, isA<NetworkFailure>());
      expect(failure.message, 'Không thể kết nối đến máy chủ');
      expect(failure.statusCode, isNull);
    });

    test('map ServerException và giữ nguyên message cùng status code', () {
      const exception = ServerException(
        message: 'Máy chủ từ chối request',
        statusCode: 422,
      );

      final failure = exception.toFailure();

      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Máy chủ từ chối request');
      expect(failure.statusCode, 422);
    });

    test('map CacheException thành CacheFailure', () {
      const exception = CacheException(message: 'Cache đã cũ');

      final failure = exception.toFailure();

      expect(failure, isA<CacheFailure>());
      expect(failure.message, 'Cache đã cũ');
      expect(failure.statusCode, isNull);
    });

    test('map exception lạ thành ServerFailure với text của exception', () {
      final exception = Exception('Lỗi bất ngờ');

      final failure = exception.toFailure();

      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Exception: Lỗi bất ngờ');
      expect(failure.statusCode, isNull);
    });
  });
}
