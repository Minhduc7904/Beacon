import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthLocalDatasource _localDatasource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
    required AuthLocalDatasource localDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AuthResult>> login({
    required String username,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final authResponse = await _remoteDatasource.login(
        username: username,
        password: password,
      );

      await _localDatasource.saveAccessToken(authResponse.tokens.accessToken);
      await _localDatasource.saveRefreshToken(authResponse.tokens.refreshToken);

      final result = AuthResult(
        tokens: authResponse.tokens,
        user: authResponse.user,
      );

      return Right(result);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, String>> logout() async {
    try {
      final accessToken = await _localDatasource.getAccessToken();
      final refreshToken = await _localDatasource.getRefreshToken();

      if (accessToken != null && refreshToken != null) {
        final isConnected = await _networkInfo.isConnected;
        if (isConnected) {
          try {
            await _remoteDatasource.logout(refreshToken: refreshToken);
          } catch (_) {
            // Ignore API errors — tokens will be cleared regardless
          }
        }
      }

      await _localDatasource.clearTokens();
      return const Right('Đăng xuất thành công');
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }
}
