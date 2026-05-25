import 'package:beacon_app/core/network/api_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiResponse.fromJson', () {
    test('parse success, message, code và data', () {
      final result = ApiResponse<Map<String, dynamic>>.fromJson({
        'success': true,
        'message': 'Đã tải',
        'code': 'ok',
        'data': {'id': 1},
      }, (json) => Map<String, dynamic>.from(json as Map));

      expect(result.success, isTrue);
      expect(result.message, 'Đã tải');
      expect(result.code, 'ok');
      expect(result.data, {'id': 1});
    });

    test('gọi fromJsonT khi data khác null', () {
      var calls = 0;

      final result = ApiResponse<int>.fromJson(
        {'success': true, 'message': 'Đã tải', 'data': '41'},
        (json) {
          calls += 1;
          return int.parse(json as String) + 1;
        },
      );

      expect(calls, 1);
      expect(result.data, 42);
    });

    test('không gọi fromJsonT khi data là null', () {
      var calls = 0;

      final result = ApiResponse<int>.fromJson(
        {'success': true, 'message': 'Không có dữ liệu', 'data': null},
        (_) {
          calls += 1;
          return 42;
        },
      );

      expect(calls, 0);
      expect(result.data, isNull);
    });

    test(
      'dùng message rỗng và code null khi thiếu field optional',
      () {
        final result = ApiResponse<dynamic>.fromJson({
          'success': true,
          'data': null,
        }, null);

        expect(result.success, isTrue);
        expect(result.message, '');
        expect(result.code, isNull);
        expect(result.data, isNull);
      },
    );

    test('chuyển code sang string khi code không phải string', () {
      final result = ApiResponse<dynamic>.fromJson({
        'success': true,
        'message': 'Đã tải',
        'code': 123,
        'data': null,
      }, null);

      expect(result.code, '123');
    });
  });
}
