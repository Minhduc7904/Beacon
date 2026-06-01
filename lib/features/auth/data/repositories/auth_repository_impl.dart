import 'package:dartz/dartz.dart';
import '../../../../core/cache/current_user_cache_scope.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_exception.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/user_profile_local_datasource.dart';
import '../mappers/user_profile_cache_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthLocalDatasource _localDatasource;
  final UserProfileLocalDatasource _userProfileLocalDatasource;
  final CurrentUserCacheScope _currentUserCacheScope;
  final AppDatabase _appDatabase;
  final NetworkInfo _networkInfo;
  final DateTime Function() _nowUtc;

  AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
    required AuthLocalDatasource localDatasource,
    required UserProfileLocalDatasource userProfileLocalDatasource,
    required CurrentUserCacheScope currentUserCacheScope,
    required AppDatabase appDatabase,
    required NetworkInfo networkInfo,
    DateTime Function()? nowUtc,
  }) : _remoteDatasource = remoteDatasource,
       _localDatasource = localDatasource,
       _userProfileLocalDatasource = userProfileLocalDatasource,
       _currentUserCacheScope = currentUserCacheScope,
       _appDatabase = appDatabase,
       _networkInfo = networkInfo,
       _nowUtc = nowUtc ?? (() => DateTime.now().toUtc());

  @override
  Future<Either<Failure, bool>> checkEmailAvailable({
    required String email,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final isAvailable = await _remoteDatasource.checkEmailAvailable(
        email: email,
      );
      return Right(isAvailable);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkPhoneAvailable({
    required String phoneNumber,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final isAvailable = await _remoteDatasource.checkPhoneAvailable(
        phoneNumber: phoneNumber,
      );
      return Right(isAvailable);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

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
      await _localDatasource.saveAccessTokenExpiresAt(
        authResponse.tokens.accessTokenExpiresAt,
      );
      await _saveCurrentUserIdIfPresent(authResponse.user.userId);

      final result = AuthResult(
        message: authResponse.message,
        tokens: authResponse.tokens,
        user: authResponse.user,
      );

      return Right(result);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, AuthResult>> register({
    required String email,
    required String confirmPassword,
    required String familyName,
    required String givenName,
    required String username,
    required String password,
    required String phoneNumber,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final authResponse = await _remoteDatasource.register(
        email: email,
        confirmPassword: confirmPassword,
        familyName: familyName,
        givenName: givenName,
        username: username,
        password: password,
        phoneNumber: phoneNumber,
      );

      await _localDatasource.saveAccessToken(authResponse.tokens.accessToken);
      await _localDatasource.saveRefreshToken(authResponse.tokens.refreshToken);
      await _localDatasource.saveAccessTokenExpiresAt(
        authResponse.tokens.accessTokenExpiresAt,
      );
      await _saveCurrentUserIdIfPresent(authResponse.user.userId);

      final result = AuthResult(
        message: authResponse.message,
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

      final cacheScopeUserId = await _getCurrentUserIdForLogout();
      await _localDatasource.clearTokens();
      await _deleteCachedProfileIfScoped(cacheScopeUserId);
      try {
        await _appDatabase.clearAll();
      } on DatabaseException catch (e) {
        return Left(CacheFailure(message: e.message));
      } finally {
        await _currentUserCacheScope.clearCurrentUserId();
      }
      return const Right('Đăng xuất thành công');
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getMe() async {
    if (!await _networkInfo.isConnected) {
      return _getCachedProfile();
    }

    try {
      final profile = await _remoteDatasource.getMe();
      await _saveCurrentUserIdIfPresent(profile.id);
      await _upsertProfileCacheIfScoped(profile);
      return Right(profile);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateMe({
    String? familyName,
    String? givenName,
    String? email,
    String? phoneNumber,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final profile = await _remoteDatasource.updateMe(
        familyName: familyName,
        givenName: givenName,
        email: email,
        phoneNumber: phoneNumber,
      );
      await _saveCurrentUserIdIfPresent(profile.id);
      await _upsertProfileCacheIfScoped(profile);
      return Right(profile);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateMyAvatar({
    required String filePath,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final profile = await _remoteDatasource.updateMyAvatar(
        filePath: filePath,
      );
      await _saveCurrentUserIdIfPresent(profile.id);
      await _upsertProfileCacheIfScoped(profile);
      return Right(profile);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateFcmToken({
    required String token,
    required String platform,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.updateFcmToken(token: token, platform: platform);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteFcmToken({required String token}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.deleteFcmToken(token: token);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  Future<void> _saveCurrentUserIdIfPresent(String userId) async {
    final normalized = userId.trim();
    if (normalized.isEmpty) {
      return;
    }

    await _currentUserCacheScope.saveCurrentUserId(normalized);
  }

  Future<String?> _getCurrentUserIdForLogout() async {
    try {
      return await _currentUserCacheScope.getCurrentUserId();
    } on Exception {
      // Profile cache cleanup is best-effort during logout.
      return null;
    }
  }

  Future<Either<Failure, UserProfile>> _getCachedProfile() async {
    try {
      final cacheScopeUserId = await _currentUserCacheScope.getCurrentUserId();
      if (cacheScopeUserId == null || cacheScopeUserId.trim().isEmpty) {
        return const Left(NetworkFailure());
      }

      final cache = await _userProfileLocalDatasource.getProfile(
        cacheScopeUserId: cacheScopeUserId,
      );
      if (cache == null) {
        return const Left(NetworkFailure());
      }

      return Right(cache.toDomain());
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  Future<void> _upsertProfileCacheIfScoped(UserProfile profile) async {
    try {
      final cacheScopeUserId = profile.id.trim();
      if (cacheScopeUserId.isEmpty) {
        return;
      }

      await _userProfileLocalDatasource.upsertProfile(
        profile.toCache(
          cacheScopeUserId: cacheScopeUserId,
          cachedAtUtc: _nowUtc(),
        ),
      );
    } on Exception {
      // Profile cache write is best-effort; remote success remains canonical.
    }
  }

  Future<void> _deleteCachedProfileIfScoped(String? cacheScopeUserId) async {
    final scope = cacheScopeUserId?.trim();
    if (scope == null || scope.isEmpty) {
      return;
    }

    try {
      await _userProfileLocalDatasource.deleteProfile(
        cacheScopeUserId: scope,
      );
    } on Exception {
      // Profile cache cleanup must not block logout session cleanup.
    }
  }
}
