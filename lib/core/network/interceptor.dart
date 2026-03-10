import 'package:dio/dio.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDatasource _authLocalDatasource;

  AuthInterceptor(this._authLocalDatasource);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _authLocalDatasource.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // TODO: trigger token refresh logic or redirect to login
    }
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}

class LoggingInterceptor extends Interceptor {
  static const _separator = '─────────────────────────────────────────';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ignore: avoid_print
    print('\n$_separator');
    // ignore: avoid_print
    print('→ REQUEST [${options.method}]');
    // ignore: avoid_print
    print('   URL     : ${options.baseUrl}${options.path}');
    if (options.queryParameters.isNotEmpty) {
      // ignore: avoid_print
      print('   QUERY   : ${options.queryParameters}');
    }
    if (options.data != null) {
      // ignore: avoid_print
      print('   BODY    : ${options.data}');
    }
    // ignore: avoid_print
    print(_separator);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ignore: avoid_print
    print('\n$_separator');
    // ignore: avoid_print
    print('← RESPONSE [${response.statusCode}]');
    // ignore: avoid_print
    print(
      '   URL     : ${response.requestOptions.baseUrl}${response.requestOptions.path}',
    );
    // ignore: avoid_print
    print('   DATA    : ${response.data}');
    // ignore: avoid_print
    print(_separator);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print('\n$_separator');
    // ignore: avoid_print
    print('✕ ERROR [${err.response?.statusCode}] — ${err.type.name}');
    // ignore: avoid_print
    print(
      '   URL     : ${err.requestOptions.baseUrl}${err.requestOptions.path}',
    );
    // ignore: avoid_print
    print('   MESSAGE : ${err.message}');
    if (err.response?.data != null) {
      // ignore: avoid_print
      print('   BODY    : ${err.response?.data}');
    }
    // ignore: avoid_print
    print(_separator);
    handler.next(err);
  }
}
