import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:beacon_app/features/auth/domain/entities/auth_result.dart';
import 'package:beacon_app/features/auth/domain/entities/tokens.dart';
import 'package:beacon_app/features/auth/domain/entities/user.dart';
import 'package:beacon_app/features/auth/domain/entities/user_profile.dart';
import 'package:beacon_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class InMemoryAuthLocalDatasource implements AuthLocalDatasource {
  String? _accessToken;
  String? _refreshToken;
  DateTime? _accessTokenExpiresAt;

  @override
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    _accessTokenExpiresAt = null;
  }

  @override
  Future<String?> getAccessToken() async => _accessToken;

  @override
  Future<DateTime?> getAccessTokenExpiresAt() async => _accessTokenExpiresAt;

  @override
  Future<String?> getRefreshToken() async => _refreshToken;

  @override
  Future<void> saveAccessToken(String token) async {
    _accessToken = token;
  }

  @override
  Future<void> saveAccessTokenExpiresAt(DateTime? expiresAt) async {
    _accessTokenExpiresAt = expiresAt;
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    _refreshToken = token;
  }
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    required InMemoryAuthLocalDatasource localDatasource,
    this.autoLoginAfterRegister = false,
  }) : _localDatasource = localDatasource;

  final InMemoryAuthLocalDatasource _localDatasource;

  // Keep false when the integration flow must exercise login after register.
  final bool autoLoginAfterRegister;

  final Map<String, _FakeAccount> _accountsByUsername = {};
  _FakeAccount? _currentAccount;

  int registerCallCount = 0;
  int loginCallCount = 0;

  @override
  Future<Either<Failure, bool>> checkEmailAvailable({
    required String email,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final isTaken = _accountsByUsername.values.any(
      (account) => account.email.toLowerCase() == normalizedEmail,
    );
    return Right(!isTaken);
  }

  @override
  Future<Either<Failure, bool>> checkPhoneAvailable({
    required String phoneNumber,
  }) async {
    final normalizedPhone = phoneNumber.trim();
    final isTaken = _accountsByUsername.values.any(
      (account) => account.phoneNumber == normalizedPhone,
    );
    return Right(!isTaken);
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
    registerCallCount += 1;

    final normalizedUsername = username.trim();
    if (_accountsByUsername.containsKey(normalizedUsername)) {
      return const Left(ServerFailure(message: 'username is already taken.'));
    }

    final account = _FakeAccount(
      userId: 'integration-user-${_accountsByUsername.length + 1}',
      email: email.trim(),
      phoneNumber: phoneNumber.trim(),
      password: password,
      familyName: familyName.trim(),
      givenName: givenName.trim(),
      username: normalizedUsername,
    );
    _accountsByUsername[normalizedUsername] = account;

    final result = _authResult(account, message: 'Register success');
    if (autoLoginAfterRegister) {
      await _saveSession(result.tokens);
      _currentAccount = account;
    }

    return Right(result);
  }

  @override
  Future<Either<Failure, AuthResult>> login({
    required String username,
    required String password,
  }) async {
    loginCallCount += 1;

    final account = _accountsByUsername[username.trim()];
    if (account == null || account.password != password) {
      return const Left(
        UnauthorizedFailure(message: 'Invalid username or password'),
      );
    }

    final result = _authResult(account, message: 'Login success');
    await _saveSession(result.tokens);
    _currentAccount = account;

    return Right(result);
  }

  @override
  Future<Either<Failure, String>> logout() async {
    await _localDatasource.clearTokens();
    _currentAccount = null;
    return const Right('Logout success');
  }

  @override
  Future<Either<Failure, UserProfile>> getMe() async {
    final account = _currentAccount;
    if (account == null) {
      return const Left(UnauthorizedFailure(message: 'Missing test session'));
    }

    return Right(_profile(account));
  }

  @override
  Future<Either<Failure, UserProfile>> updateMe({
    String? familyName,
    String? givenName,
    String? email,
    String? phoneNumber,
  }) async {
    final account = _currentAccount;
    if (account == null) {
      return const Left(UnauthorizedFailure(message: 'Missing test session'));
    }

    final updated = account.copyWith(
      familyName: familyName,
      givenName: givenName,
      email: email,
      phoneNumber: phoneNumber,
    );
    _accountsByUsername[updated.username] = updated;
    _currentAccount = updated;

    return Right(_profile(updated));
  }

  @override
  Future<Either<Failure, UserProfile>> updateMyAvatar({
    required String filePath,
  }) async {
    final account = _currentAccount;
    if (account == null) {
      return const Left(UnauthorizedFailure(message: 'Missing test session'));
    }

    return Right(_profile(account));
  }

  @override
  Future<Either<Failure, void>> updateFcmToken({
    required String token,
    required String platform,
  }) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteFcmToken({required String token}) async {
    return const Right(null);
  }

  AuthResult _authResult(_FakeAccount account, {required String message}) {
    return AuthResult(
      message: message,
      tokens: Tokens(
        accessToken: 'access-token-${account.userId}',
        refreshToken: 'refresh-token-${account.userId}',
        accessTokenExpiresAt: DateTime.utc(2035, 1, 1),
      ),
      user: User(
        userId: account.userId,
        username: account.username,
        email: account.email,
        familyName: account.familyName,
        givenName: account.givenName,
      ),
    );
  }

  UserProfile _profile(_FakeAccount account) {
    return UserProfile(
      id: account.userId,
      username: account.username,
      email: account.email,
      familyName: account.familyName,
      givenName: account.givenName,
      phoneNumber: account.phoneNumber,
      timeZone: 'Asia/Ho_Chi_Minh',
      isActive: true,
      isEmailVerified: true,
      lastLoginAtUtc: DateTime.utc(2026, 5, 26, 8),
      createdAtUtc: DateTime.utc(2026, 1, 1),
      avatarMediaObjectId: null,
      avatarUrl: null,
    );
  }

  Future<void> _saveSession(Tokens tokens) async {
    await _localDatasource.saveAccessToken(tokens.accessToken);
    await _localDatasource.saveRefreshToken(tokens.refreshToken);
    await _localDatasource.saveAccessTokenExpiresAt(
      tokens.accessTokenExpiresAt,
    );
  }
}

class _FakeAccount {
  const _FakeAccount({
    required this.userId,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.familyName,
    required this.givenName,
    required this.username,
  });

  final String userId;
  final String email;
  final String phoneNumber;
  final String password;
  final String familyName;
  final String givenName;
  final String username;

  _FakeAccount copyWith({
    String? email,
    String? phoneNumber,
    String? familyName,
    String? givenName,
  }) {
    return _FakeAccount(
      userId: userId,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password,
      familyName: familyName ?? this.familyName,
      givenName: givenName ?? this.givenName,
      username: username,
    );
  }
}
