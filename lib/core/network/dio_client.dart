import 'package:dio/dio.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import 'api_endpoints.dart';
import 'interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient(AuthLocalDatasource authLocalDatasource) {
    _dio =
        Dio(
            BaseOptions(
              baseUrl: ApiEndpoints.baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          )
          ..interceptors.addAll([
            AuthInterceptor(authLocalDatasource),
            LoggingInterceptor(),
          ]);
  }

  Dio get dio => _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
    return response;
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return response;
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return response;
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return response;
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return response;
  }
}
