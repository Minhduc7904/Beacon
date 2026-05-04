import 'dart:async';

import 'package:dio/dio.dart';
import '../constants/api_error_codes.dart';
import 'api_endpoints.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDatasource _authLocalDatasource;
  final void Function(String message)? _onAuthFailure;
  Completer<bool>? _refreshCompleter;

  AuthInterceptor(
    this._authLocalDatasource, {
    void Function(String)? onAuthFailure,
  }) : _onAuthFailure = onAuthFailure;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await _authLocalDatasource.getAccessToken();
      final hasAccessToken = token != null && token.isNotEmpty;

      if (hasAccessToken) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      if (!hasAccessToken || _shouldSkipRefresh(options.path)) {
        handler.next(options);
        return;
      }

      final expired = await _isAccessTokenExpired();
      if (!expired) {
        handler.next(options);
        return;
      }

      final refreshed = await _refreshTokenWithQueue();
      if (!refreshed) {
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: options,
              statusCode: 401,
              data: {
                'success': false,
                'code': ApiErrorCodes.tokenInvalid,
                'message':
                    'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
              },
            ),
            message: 'Refresh token failed',
          ),
        );
        return;
      }

      final refreshedAccessToken = await _authLocalDatasource.getAccessToken();
      if (refreshedAccessToken == null || refreshedAccessToken.isEmpty) {
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.unknown,
            message: 'Access token unavailable after refresh',
          ),
        );
        return;
      }

      options.headers['Authorization'] = 'Bearer $refreshedAccessToken';
      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: e,
          message: 'Auth interceptor error: $e',
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  bool _shouldSkipRefresh(String path) {
    const excludedPaths = <String>{
      ApiEndpoints.login,
      ApiEndpoints.register,
      ApiEndpoints.checkEmail,
      ApiEndpoints.checkPhone,
      ApiEndpoints.logout,
      ApiEndpoints.refreshToken,
    };

    return excludedPaths.any(path.endsWith);
  }

  Future<bool> _isAccessTokenExpired() async {
    final expiresAt = await _authLocalDatasource.getAccessTokenExpiresAt();
    if (expiresAt == null) {
      return true;
    }

    final now = DateTime.now();
    return !expiresAt.isAfter(now.add(const Duration(seconds: 5)));
  }

  Future<bool> _refreshTokenWithQueue() async {
    final runningRefresh = _refreshCompleter;
    if (runningRefresh != null) {
      return runningRefresh.future;
    }

    final completer = Completer<bool>();
    _refreshCompleter = completer;

    try {
      final refreshed = await _performRefreshTokenRequest();
      completer.complete(refreshed);
      return refreshed;
    } catch (_) {
      completer.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<bool> _performRefreshTokenRequest() async {
    final refreshToken = await _authLocalDatasource.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _handleRefreshFailure(
        message: 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
      );
      return false;
    }

    final refreshDio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    try {
      final response = await refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final body = response.data;
      if (body is! Map<String, dynamic>) {
        await _handleRefreshFailure(
          message: 'Không thể làm mới phiên đăng nhập. Vui lòng đăng nhập lại.',
        );
        return false;
      }

      final success = body['success'] == true;
      final code = body['code']?.toString();
      final message = (body['message']?.toString().trim().isNotEmpty ?? false)
          ? body['message'].toString().trim()
          : 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';

      if (!success) {
        await _handleRefreshFailure(message: message);
        return false;
      }

      final data = body['data'];
      if (data is! Map<String, dynamic>) {
        await _handleRefreshFailure(
          message: 'Không thể làm mới phiên đăng nhập. Vui lòng đăng nhập lại.',
        );
        return false;
      }

      final accessToken = data['accessToken']?.toString() ?? '';
      final nextRefreshToken = data['refreshToken']?.toString() ?? '';
      final expiresAtRaw = data['accessTokenExpiresAt']?.toString();
      final expiresAt = expiresAtRaw != null
          ? DateTime.tryParse(expiresAtRaw)
          : null;

      if (accessToken.isEmpty || nextRefreshToken.isEmpty) {
        await _handleRefreshFailure(
          message: 'Không thể làm mới phiên đăng nhập. Vui lòng đăng nhập lại.',
        );
        return false;
      }

      await _authLocalDatasource.saveAccessToken(accessToken);
      await _authLocalDatasource.saveRefreshToken(nextRefreshToken);
      await _authLocalDatasource.saveAccessTokenExpiresAt(expiresAt);

      if (code == ApiErrorCodes.tokenInvalid) {
        return false;
      }

      return true;
    } on DioException catch (e) {
      final responseBody = e.response?.data;
      final code = responseBody is Map<String, dynamic>
          ? responseBody['code']?.toString()
          : null;
      final message =
          responseBody is Map<String, dynamic> &&
              (responseBody['message']?.toString().trim().isNotEmpty ?? false)
          ? responseBody['message'].toString().trim()
          : 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';

      if (e.response?.statusCode == 401 || code == ApiErrorCodes.tokenInvalid) {
        await _handleRefreshFailure(message: message);
        return false;
      }

      await _handleRefreshFailure(message: message);
      return false;
    }
  }

  Future<void> _handleRefreshFailure({required String message}) async {
    await _authLocalDatasource.clearTokens();
    _onAuthFailure?.call(message);
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
