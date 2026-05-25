import 'package:beacon_app/core/errors/exceptions.dart';
import 'package:beacon_app/core/network/api_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

Response<dynamic> _response({required int statusCode, required dynamic data}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: '/test'),
    statusCode: statusCode,
    data: data,
  );
}

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
  group('ApiHandler.handle', () {
    test('trả về ApiResponse đã parse khi response thành công', () {
      final response = _response(
        statusCode: 200,
        data: {
          'success': true,
          'message': 'Thành công',
          'code': 'ok',
          'data': {'id': 1, 'name': 'Beacon'},
        },
      );

      final result = ApiHandler.handle<Map<String, dynamic>>(
        response,
        fromJsonT: (json) => Map<String, dynamic>.from(json as Map),
      );

      expect(result.success, isTrue);
      expect(result.message, 'Thành công');
      expect(result.code, 'ok');
      expect(result.data, {'id': 1, 'name': 'Beacon'});
    });

    test('ném ServerException khi body response không phải map', () {
      final response = _response(statusCode: 200, data: ['invalid']);

      expect(
        () => ApiHandler.handle<dynamic>(response),
        throwsA(
          isA<ServerException>()
              .having((e) => e.message, 'message', 'Invalid response format')
              .having((e) => e.statusCode, 'statusCode', 200),
        ),
      );
    });

    test(
      'ném ServerException với message fallback 400 khi success là false',
      () {
        final response = _response(
          statusCode: 400,
          data: {'success': false, 'message': '', 'data': null},
        );

        expect(
          () => ApiHandler.handle<dynamic>(response),
          throwsA(
            isA<ServerException>()
                .having((e) => e.message, 'message', 'Yêu cầu không hợp lệ')
                .having((e) => e.statusCode, 'statusCode', 400),
          ),
        );
      },
    );

    test(
      'ném UnauthorizedException với message fallback 401 khi success là false',
      () {
        final response = _response(
          statusCode: 401,
          data: {'success': false, 'message': '', 'data': null},
        );

        expect(
          () => ApiHandler.handle<dynamic>(response),
          throwsA(
            isA<UnauthorizedException>().having(
              (e) => e.message,
              'message',
              'Phiên đăng nhập đã hết hạn',
            ),
          ),
        );
      },
    );

    test(
      'ném ServerException với message fallback 422 khi success là false',
      () {
        final response = _response(
          statusCode: 422,
          data: {'success': false, 'message': '', 'data': null},
        );

        expect(
          () => ApiHandler.handle<dynamic>(response),
          throwsA(
            isA<ServerException>()
                .having(
                  (e) => e.message,
                  'message',
                  'Dữ liệu gửi lên không hợp lệ',
                )
                .having((e) => e.statusCode, 'statusCode', 422),
          ),
        );
      },
    );

    test(
      'ném ServerException với message fallback 500 khi success là false',
      () {
        final response = _response(
          statusCode: 500,
          data: {'success': false, 'message': '', 'data': null},
        );

        expect(
          () => ApiHandler.handle<dynamic>(response),
          throwsA(
            isA<ServerException>()
                .having((e) => e.message, 'message', 'Internal server error')
                .having((e) => e.statusCode, 'statusCode', 500),
          ),
        );
      },
    );

    test(
      'ưu tiên code message mapper trước API message khi mapper trả về nội dung',
      () {
        final response = _response(
          statusCode: 400,
          data: {
            'success': false,
            'code': 'email_exists',
            'message': 'Message từ API',
            'data': null,
          },
        );

        expect(
          () => ApiHandler.handle<dynamic>(
            response,
            codeMessageMapper: (code) =>
                code == 'email_exists' ? 'Email đã được sử dụng' : null,
          ),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'Email đã được sử dụng',
            ),
          ),
        );
      },
    );

    test('dùng API message khi code message mapper trả về chuỗi rỗng', () {
      final response = _response(
        statusCode: 400,
        data: {
          'success': false,
          'code': 'email_exists',
          'message': 'Message từ API',
          'data': null,
        },
      );

      expect(
        () =>
            ApiHandler.handle<dynamic>(response, codeMessageMapper: (_) => ' '),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            'Message từ API',
          ),
        ),
      );
    });
  });

  group('ApiHandler.rethrowDioException', () {
    test('ném NetworkException khi Dio exception là timeout', () {
      final exception = _dioException(type: DioExceptionType.connectionTimeout);

      expect(
        () => ApiHandler.rethrowDioException(exception),
        throwsA(
          isA<NetworkException>().having(
            (e) => e.message,
            'message',
            'Không thể kết nối đến máy chủ',
          ),
        ),
      );
    });

    test('ném UnauthorizedException cho badResponse có status 401', () {
      final exception = _dioException(
        type: DioExceptionType.badResponse,
        statusCode: 401,
        data: {'message': 'Token đã hết hạn'},
      );

      expect(
        () => ApiHandler.rethrowDioException(exception),
        throwsA(
          isA<UnauthorizedException>().having(
            (e) => e.message,
            'message',
            'Token đã hết hạn',
          ),
        ),
      );
    });

    test('ném ServerException cho badResponse có status server', () {
      final exception = _dioException(
        type: DioExceptionType.badResponse,
        statusCode: 500,
        data: {'message': 'Máy chủ đang lỗi'},
      );

      expect(
        () => ApiHandler.rethrowDioException(exception),
        throwsA(
          isA<ServerException>()
              .having((e) => e.message, 'message', 'Máy chủ đang lỗi')
              .having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });

    test('ưu tiên code message mapper cho badResponse trước API message', () {
      final exception = _dioException(
        type: DioExceptionType.badResponse,
        statusCode: 422,
        data: {'code': 'invalid_phone', 'message': 'Message từ API'},
      );

      expect(
        () => ApiHandler.rethrowDioException(
          exception,
          codeMessageMapper: (code) =>
              code == 'invalid_phone' ? 'Số điện thoại không hợp lệ' : null,
        ),
        throwsA(
          isA<ServerException>()
              .having((e) => e.message, 'message', 'Số điện thoại không hợp lệ')
              .having((e) => e.statusCode, 'statusCode', 422),
        ),
      );
    });
  });
}
