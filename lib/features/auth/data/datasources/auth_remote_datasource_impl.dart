import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/tokens_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _dioClient;

  AuthRemoteDatasourceImpl(this._dioClient);

  @override
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  }) async {
    final response = await _dioClient.post(
      ApiEndpoints.login,
      data: {'username': username, 'password': password},
    );

    final result = ApiHandler.handle<AuthResponseModel>(
      response,
      fromJsonT: (json) =>
          AuthResponseModel.fromJson(json as Map<String, dynamic>),
    );

    return result.data!;
  }

  @override
  Future<AuthResponseModel> register({
    required String username,
    required String password,
    required String fullName,
    required String? phoneNumber,
  }) async {
    final response = await _dioClient.post(
      ApiEndpoints.register,
      data: {
        'username': username,
        'password': password,
        'fullName': fullName,
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
