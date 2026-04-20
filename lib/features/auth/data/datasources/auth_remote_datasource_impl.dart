import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/dio_client.dart';
import '../mappers/auth_error_code_mapper.dart';
import '../models/auth_response_model.dart';
import '../models/tokens_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _dioClient;

  AuthRemoteDatasourceImpl(this._dioClient);

  @override
  Future<bool> checkPhoneAvailable({required String phoneNumber}) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.checkPhone,
        queryParameters: {'phoneNumber': phoneNumber},
      );

      final result = ApiHandler.handle<bool>(
        response,
        fromJsonT: (json) {
          if (json is! Map<String, dynamic>) {
            throw const FormatException('Invalid check-phone data format');
          }

          return json['available'] == true;
        },
        codeMessageMapper: AuthErrorCodeMapper.mapCheckPhoneCode,
      );

      return result.data ?? false;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: AuthErrorCodeMapper.mapCheckPhoneCode,
      );
    }
  }

  @override
  Future<bool> checkEmailAvailable({required String email}) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.checkEmail,
        queryParameters: {'email': email},
      );

      final result = ApiHandler.handle<bool>(
        response,
        fromJsonT: (json) {
          if (json is! Map<String, dynamic>) {
            throw const FormatException('Invalid check-email data format');
          }

          return json['available'] == true;
        },
        codeMessageMapper: AuthErrorCodeMapper.mapCheckEmailCode,
      );

      return result.data ?? false;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: AuthErrorCodeMapper.mapCheckEmailCode,
      );
    }
  }

  @override
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );

      final result = ApiHandler.handle<AuthResponseModel>(
        response,
        fromJsonT: (json) =>
            AuthResponseModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: AuthErrorCodeMapper.mapLoginCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: AuthErrorCodeMapper.mapLoginCode,
      );
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String confirmPassword,
    required String familyName,
    required String givenName,
    required String username,
    required String password,
    required String phoneNumber,
  }) async {
    final response = await _dioClient.post(
      ApiEndpoints.register,
      data: {
        'email': email,
        'username': username,
        'password': password,
        'confirmPassword': confirmPassword,
        'familyName': familyName,
        'givenName': givenName,
        'phoneNumber': phoneNumber,
      },
    );

    final result = ApiHandler.handle<AuthResponseModel>(
      response,
      fromJsonT: (json) =>
          AuthResponseModel.fromJson(json as Map<String, dynamic>),
    );

    return result.data!;
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    final response = await _dioClient.post(
      ApiEndpoints.logout,
      data: {'refreshToken': refreshToken},
    );
    ApiHandler.handle<void>(response);
  }

  @override
  Future<TokensModel> refreshToken({required String refreshToken}) async {
    final response = await _dioClient.post(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': refreshToken},
    );

    final result = ApiHandler.handle<TokensModel>(
      response,
      fromJsonT: (json) => TokensModel.fromJson(json as Map<String, dynamic>),
    );

    return result.data!;
  }
}
