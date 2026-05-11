import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/dio_client.dart';
import '../mappers/auth_error_code_mapper.dart';
import '../models/auth_response_model.dart';
import '../models/tokens_model.dart';
import '../models/user_profile_model.dart';
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

      final data = result.data!;
      return AuthResponseModel(
        message: result.message,
        tokens: data.tokens,
        user: data.user,
      );
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
    try {
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
        codeMessageMapper: AuthErrorCodeMapper.mapRegisterCode,
      );

      final data = result.data!;
      return AuthResponseModel(
        message: result.message,
        tokens: data.tokens,
        user: data.user,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: AuthErrorCodeMapper.mapRegisterCode,
      );
    }
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

  @override
  Future<UserProfileModel> getMe() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.me);

      final result = ApiHandler.handle<UserProfileModel>(
        response,
        fromJsonT: (json) =>
            UserProfileModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: AuthErrorCodeMapper.mapMeCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: AuthErrorCodeMapper.mapMeCode,
      );
    }
  }

  @override
  Future<UserProfileModel> updateMe({
    String? familyName,
    String? givenName,
    String? email,
    String? phoneNumber,
  }) async {
    try {
      final payload = <String, dynamic>{
        'familyName': familyName,
        'givenName': givenName,
        'email': email,
        'phoneNumber': phoneNumber,
      }..removeWhere((_, value) => value == null);

      final response = await _dioClient.patch(
        ApiEndpoints.userMe,
        data: payload,
      );

      final result = ApiHandler.handle<UserProfileModel>(
        response,
        fromJsonT: (json) =>
            UserProfileModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: AuthErrorCodeMapper.mapUpdateMeCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: AuthErrorCodeMapper.mapUpdateMeCode,
      );
    }
  }

  @override
  Future<UserProfileModel> updateMyAvatar({required String filePath}) async {
    try {
      final fileName = filePath.split(RegExp(r'[\\/]')).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName.isEmpty ? 'avatar.jpg' : fileName,
        ),
      });

      final response = await _dioClient.put(
        ApiEndpoints.userMeAvatar,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final result = ApiHandler.handle<UserProfileModel>(
        response,
        fromJsonT: (json) =>
            UserProfileModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: AuthErrorCodeMapper.mapUpdateAvatarCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: AuthErrorCodeMapper.mapUpdateAvatarCode,
      );
    }
  }

  @override
  Future<void> updateFcmToken({
    required String token,
    required String platform,
  }) async {
    final response = await _dioClient.post(
      ApiEndpoints.deviceTokens,
      data: {'token': token, 'platform': platform},
    );
    ApiHandler.handle<void>(response);
  }

  @override
  Future<void> deleteFcmToken({required String token}) async {
    final response = await _dioClient.delete(
      ApiEndpoints.deviceTokens,
      data: {'token': token},
    );
    ApiHandler.handle<void>(response);
  }
}
