import 'package:beacon_app/core/errors/exceptions.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/core/network/network_info.dart';
import 'package:beacon_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:beacon_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:beacon_app/features/auth/data/models/auth_response_model.dart';
import 'package:beacon_app/features/auth/data/models/tokens_model.dart';
import 'package:beacon_app/features/auth/data/models/user_model.dart';
import 'package:beacon_app/features/auth/data/models/user_profile_model.dart';
import 'package:beacon_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

final _expiresAt = DateTime.utc(2026, 5, 26, 12);

TokensModel _tokens() {
  return TokensModel(
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    accessTokenExpiresAt: _expiresAt,
  );
}

UserModel _user() {
  return UserModel(
    userId: 'user-1',
    username: 'mai',
    email: 'mai@example.com',
    familyName: 'Nguyen',
    givenName: 'Mai',
  );
}

AuthResponseModel _authResponse({String message = 'Thành công'}) {
  return AuthResponseModel(message: message, tokens: _tokens(), user: _user());
}

UserProfileModel _profile({String givenName = 'Mai'}) {
  return UserProfileModel(
    id: 'user-1',
    username: 'mai',
    email: 'mai@example.com',
    familyName: 'Nguyen',
    givenName: givenName,
    phoneNumber: '+84912345678',
    timeZone: 'Asia/Ho_Chi_Minh',
    isActive: true,
    isEmailVerified: true,
    lastLoginAtUtc: DateTime.utc(2026, 5, 26, 10),
    createdAtUtc: DateTime.utc(2025, 1, 1),
    avatarMediaObjectId: 'avatar-media-1',
    avatarUrl: 'https://example.com/avatar.jpg',
  );
}

void _expectLeft<T>(Either<Failure, T> result, Matcher matcher) {
  result.fold(
    (failure) => expect(failure, matcher),
    (_) => fail('Expected Left'),
  );
}

void _expectRightSame<T>(Either<Failure, T> result, T expected) {
  result.fold(
    (_) => fail('Expected Right'),
    (actual) => expect(actual, same(expected)),
  );
}

void _stubNetwork(MockNetworkInfo networkInfo, bool isConnected) {
  when(() => networkInfo.isConnected).thenAnswer((_) async => isConnected);
}

void _stubSaveSession(
  MockAuthLocalDatasource localDatasource,
  AuthResponseModel response,
) {
  when(
    () => localDatasource.saveAccessToken(response.tokens.accessToken),
  ).thenAnswer((_) async {});
  when(
    () => localDatasource.saveRefreshToken(response.tokens.refreshToken),
  ).thenAnswer((_) async {});
  when(
    () => localDatasource.saveAccessTokenExpiresAt(
      response.tokens.accessTokenExpiresAt,
    ),
  ).thenAnswer((_) async {});
}

void _stubLocalTokens(MockAuthLocalDatasource localDatasource) {
  when(
    () => localDatasource.getAccessToken(),
  ).thenAnswer((_) async => 'access-token');
  when(
    () => localDatasource.getRefreshToken(),
  ).thenAnswer((_) async => 'refresh-token');
}

void _stubClearTokens(MockAuthLocalDatasource localDatasource) {
  when(() => localDatasource.clearTokens()).thenAnswer((_) async {});
}

void main() {
  late MockAuthRemoteDatasource remoteDatasource;
  late MockAuthLocalDatasource localDatasource;
  late MockNetworkInfo networkInfo;
  late AuthRepositoryImpl repository;

  setUp(() {
    remoteDatasource = MockAuthRemoteDatasource();
    localDatasource = MockAuthLocalDatasource();
    networkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDatasource: remoteDatasource,
      localDatasource: localDatasource,
      networkInfo: networkInfo,
    );
  });

  group('AuthRepositoryImpl network guard', () {
    test('trả về NetworkFailure và không gọi remote khi offline', () async {
      _stubNetwork(networkInfo, false);

      final checkEmail = await repository.checkEmailAvailable(
        email: 'mai@example.com',
      );
      final checkPhone = await repository.checkPhoneAvailable(
        phoneNumber: '+84912345678',
      );
      final login = await repository.login(
        username: 'mai',
        password: 'password123',
      );
      final register = await repository.register(
        email: 'mai@example.com',
        confirmPassword: 'password123',
        familyName: 'Nguyen',
        givenName: 'Mai',
        username: 'mai',
        password: 'password123',
        phoneNumber: '+84912345678',
      );
      final getMe = await repository.getMe();
      final updateMe = await repository.updateMe(givenName: 'Mai');
      final updateAvatar = await repository.updateMyAvatar(
        filePath: 'avatar.jpg',
      );
      final updateFcm = await repository.updateFcmToken(
        token: 'fcm-token',
        platform: 'android',
      );
      final deleteFcm = await repository.deleteFcmToken(token: 'fcm-token');

      final networkFailure = isA<NetworkFailure>().having(
        (failure) => failure.message,
        'message',
        'No internet connection',
      );
      _expectLeft(checkEmail, networkFailure);
      _expectLeft(checkPhone, networkFailure);
      _expectLeft(login, networkFailure);
      _expectLeft(register, networkFailure);
      _expectLeft(getMe, networkFailure);
      _expectLeft(updateMe, networkFailure);
      _expectLeft(updateAvatar, networkFailure);
      _expectLeft(updateFcm, networkFailure);
      _expectLeft(deleteFcm, networkFailure);
      verifyNever(
        () => remoteDatasource.checkEmailAvailable(email: any(named: 'email')),
      );
      verifyNever(
        () => remoteDatasource.checkPhoneAvailable(
          phoneNumber: any(named: 'phoneNumber'),
        ),
      );
      verifyNever(
        () => remoteDatasource.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      );
      verifyNever(
        () => remoteDatasource.register(
          email: any(named: 'email'),
          confirmPassword: any(named: 'confirmPassword'),
          familyName: any(named: 'familyName'),
          givenName: any(named: 'givenName'),
          username: any(named: 'username'),
          password: any(named: 'password'),
          phoneNumber: any(named: 'phoneNumber'),
        ),
      );
      verifyNever(() => remoteDatasource.getMe());
      verifyNever(
        () => remoteDatasource.updateMe(
          familyName: any(named: 'familyName'),
          givenName: any(named: 'givenName'),
          email: any(named: 'email'),
          phoneNumber: any(named: 'phoneNumber'),
        ),
      );
      verifyNever(
        () => remoteDatasource.updateMyAvatar(filePath: any(named: 'filePath')),
      );
      verifyNever(
        () => remoteDatasource.updateFcmToken(
          token: any(named: 'token'),
          platform: any(named: 'platform'),
        ),
      );
      verifyNever(
        () => remoteDatasource.deleteFcmToken(token: any(named: 'token')),
      );
      verifyNever(
        () => localDatasource.saveAccessToken(any()),
      );
      verifyNever(
        () => localDatasource.saveRefreshToken(any()),
      );
    });
  });

  group('AuthRepositoryImpl check availability', () {
    test('checkEmailAvailable online gọi remote và trả bool', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.checkEmailAvailable(email: 'mai@example.com'),
      ).thenAnswer((_) async => true);

      final result = await repository.checkEmailAvailable(
        email: 'mai@example.com',
      );

      expect(result, const Right<Failure, bool>(true));
      verify(
        () => remoteDatasource.checkEmailAvailable(email: 'mai@example.com'),
      ).called(1);
    });

    test('checkPhoneAvailable online gọi remote và trả bool', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.checkPhoneAvailable(
          phoneNumber: '+84912345678',
        ),
      ).thenAnswer((_) async => false);

      final result = await repository.checkPhoneAvailable(
        phoneNumber: '+84912345678',
      );

      expect(result, const Right<Failure, bool>(false));
      verify(
        () => remoteDatasource.checkPhoneAvailable(
          phoneNumber: '+84912345678',
        ),
      ).called(1);
    });

    test('remote exception được map thành Failure', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.checkEmailAvailable(email: 'mai@example.com'),
      ).thenThrow(const ServerException(message: 'Email check failed'));

      final result = await repository.checkEmailAvailable(
        email: 'mai@example.com',
      );

      _expectLeft(
        result,
        isA<ServerFailure>().having(
          (failure) => failure.message,
          'message',
          'Email check failed',
        ),
      );
    });
  });

  group('AuthRepositoryImpl login', () {
    test('online gọi remote, lưu session và trả AuthResult', () async {
      _stubNetwork(networkInfo, true);
      final response = _authResponse(message: 'Đăng nhập thành công');
      when(
        () => remoteDatasource.login(
          username: 'mai',
          password: 'password123',
        ),
      ).thenAnswer((_) async => response);
      _stubSaveSession(localDatasource, response);

      final result = await repository.login(
        username: 'mai',
        password: 'password123',
      );

      result.fold((_) => fail('Expected Right'), (authResult) {
        expect(authResult.message, response.message);
        expect(authResult.tokens, same(response.tokens));
        expect(authResult.user, same(response.user));
      });
      verify(
        () => remoteDatasource.login(
          username: 'mai',
          password: 'password123',
        ),
      ).called(1);
      verify(
        () => localDatasource.saveAccessToken('access-token'),
      ).called(1);
      verify(
        () => localDatasource.saveRefreshToken('refresh-token'),
      ).called(1);
      verify(
        () => localDatasource.saveAccessTokenExpiresAt(_expiresAt),
      ).called(1);
    });

    test('remote exception được map thành Failure', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.login(
          username: 'mai',
          password: 'password123',
        ),
      ).thenThrow(const UnauthorizedException(message: 'Sai thông tin'));

      final result = await repository.login(
        username: 'mai',
        password: 'password123',
      );

      _expectLeft(
        result,
        isA<UnauthorizedFailure>().having(
          (failure) => failure.message,
          'message',
          'Sai thông tin',
        ),
      );
      verifyNever(() => localDatasource.saveAccessToken(any()));
      verifyNever(() => localDatasource.saveRefreshToken(any()));
    });

    test('local save token lỗi được map thành Failure', () async {
      _stubNetwork(networkInfo, true);
      final response = _authResponse();
      when(
        () => remoteDatasource.login(
          username: 'mai',
          password: 'password123',
        ),
      ).thenAnswer((_) async => response);
      when(
        () => localDatasource.saveAccessToken('access-token'),
      ).thenThrow(const CacheException(message: 'Không lưu được token'));

      final result = await repository.login(
        username: 'mai',
        password: 'password123',
      );

      _expectLeft(
        result,
        isA<CacheFailure>().having(
          (failure) => failure.message,
          'message',
          'Không lưu được token',
        ),
      );
    });
  });

  group('AuthRepositoryImpl register', () {
    test('online gọi remote, lưu session và trả AuthResult', () async {
      _stubNetwork(networkInfo, true);
      final response = _authResponse(message: 'Đăng ký thành công');
      when(
        () => remoteDatasource.register(
          email: 'mai@example.com',
          confirmPassword: 'password123',
          familyName: 'Nguyen',
          givenName: 'Mai',
          username: 'mai',
          password: 'password123',
          phoneNumber: '+84912345678',
        ),
      ).thenAnswer((_) async => response);
      _stubSaveSession(localDatasource, response);

      final result = await repository.register(
        email: 'mai@example.com',
        confirmPassword: 'password123',
        familyName: 'Nguyen',
        givenName: 'Mai',
        username: 'mai',
        password: 'password123',
        phoneNumber: '+84912345678',
      );

      result.fold((_) => fail('Expected Right'), (authResult) {
        expect(authResult.message, response.message);
        expect(authResult.tokens, same(response.tokens));
        expect(authResult.user, same(response.user));
      });
      verify(
        () => localDatasource.saveAccessToken('access-token'),
      ).called(1);
      verify(
        () => localDatasource.saveRefreshToken('refresh-token'),
      ).called(1);
      verify(
        () => localDatasource.saveAccessTokenExpiresAt(_expiresAt),
      ).called(1);
    });

    test('remote exception được map thành Failure', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.register(
          email: 'mai@example.com',
          confirmPassword: 'password123',
          familyName: 'Nguyen',
          givenName: 'Mai',
          username: 'mai',
          password: 'password123',
          phoneNumber: '+84912345678',
        ),
      ).thenThrow(const ServerException(message: 'Đăng ký thất bại'));

      final result = await repository.register(
        email: 'mai@example.com',
        confirmPassword: 'password123',
        familyName: 'Nguyen',
        givenName: 'Mai',
        username: 'mai',
        password: 'password123',
        phoneNumber: '+84912345678',
      );

      _expectLeft(
        result,
        isA<ServerFailure>().having(
          (failure) => failure.message,
          'message',
          'Đăng ký thất bại',
        ),
      );
    });
  });

  group('AuthRepositoryImpl profile', () {
    test('getMe online gọi remote và trả profile', () async {
      _stubNetwork(networkInfo, true);
      final profile = _profile();
      when(() => remoteDatasource.getMe()).thenAnswer((_) async => profile);

      final result = await repository.getMe();

      _expectRightSame(result, profile);
      verify(() => remoteDatasource.getMe()).called(1);
    });

    test('updateMe online gọi remote với params đúng và trả profile', () async {
      _stubNetwork(networkInfo, true);
      final profile = _profile(givenName: 'Minh');
      when(
        () => remoteDatasource.updateMe(
          familyName: 'Nguyen',
          givenName: 'Minh',
          email: 'minh@example.com',
          phoneNumber: '+84987654321',
        ),
      ).thenAnswer((_) async => profile);

      final result = await repository.updateMe(
        familyName: 'Nguyen',
        givenName: 'Minh',
        email: 'minh@example.com',
        phoneNumber: '+84987654321',
      );

      _expectRightSame(result, profile);
      verify(
        () => remoteDatasource.updateMe(
          familyName: 'Nguyen',
          givenName: 'Minh',
          email: 'minh@example.com',
          phoneNumber: '+84987654321',
        ),
      ).called(1);
    });

    test('updateMe remote exception được map thành Failure', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.updateMe(
          familyName: null,
          givenName: 'Minh',
          email: null,
          phoneNumber: null,
        ),
      ).thenThrow(const ServerException(message: 'Cập nhật thất bại'));

      final result = await repository.updateMe(givenName: 'Minh');

      _expectLeft(
        result,
        isA<ServerFailure>().having(
          (failure) => failure.message,
          'message',
          'Cập nhật thất bại',
        ),
      );
    });

    test('updateMyAvatar online gọi remote và trả profile', () async {
      _stubNetwork(networkInfo, true);
      final profile = _profile();
      when(
        () => remoteDatasource.updateMyAvatar(filePath: 'avatar.jpg'),
      ).thenAnswer((_) async => profile);

      final result = await repository.updateMyAvatar(filePath: 'avatar.jpg');

      _expectRightSame(result, profile);
      verify(
        () => remoteDatasource.updateMyAvatar(filePath: 'avatar.jpg'),
      ).called(1);
    });
  });

  group('AuthRepositoryImpl logout', () {
    test('online có token thì gọi remote logout, clear local và trả success', () async {
      _stubLocalTokens(localDatasource);
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.logout(refreshToken: 'refresh-token'),
      ).thenAnswer((_) async {});
      _stubClearTokens(localDatasource);

      final result = await repository.logout();

      expect(result, const Right<Failure, String>('Đăng xuất thành công'));
      verify(
        () => remoteDatasource.logout(refreshToken: 'refresh-token'),
      ).called(1);
      verify(() => localDatasource.clearTokens()).called(1);
    });

    test('remote logout lỗi vẫn clear local và trả success', () async {
      _stubLocalTokens(localDatasource);
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.logout(refreshToken: 'refresh-token'),
      ).thenThrow(const ServerException(message: 'Logout remote lỗi'));
      _stubClearTokens(localDatasource);

      final result = await repository.logout();

      expect(result, const Right<Failure, String>('Đăng xuất thành công'));
      verify(
        () => remoteDatasource.logout(refreshToken: 'refresh-token'),
      ).called(1);
      verify(() => localDatasource.clearTokens()).called(1);
    });

    test('offline vẫn clear local và không gọi remote logout', () async {
      _stubLocalTokens(localDatasource);
      _stubNetwork(networkInfo, false);
      _stubClearTokens(localDatasource);

      final result = await repository.logout();

      expect(result, const Right<Failure, String>('Đăng xuất thành công'));
      verifyNever(
        () => remoteDatasource.logout(refreshToken: any(named: 'refreshToken')),
      );
      verify(() => localDatasource.clearTokens()).called(1);
    });

    test('không có token thì không gọi remote logout nhưng vẫn clear local', () async {
      when(() => localDatasource.getAccessToken()).thenAnswer((_) async => null);
      when(
        () => localDatasource.getRefreshToken(),
      ).thenAnswer((_) async => null);
      _stubClearTokens(localDatasource);

      final result = await repository.logout();

      expect(result, const Right<Failure, String>('Đăng xuất thành công'));
      verifyNever(
        () => remoteDatasource.logout(refreshToken: any(named: 'refreshToken')),
      );
      verify(() => localDatasource.clearTokens()).called(1);
    });

    test('local clearTokens lỗi được map thành Failure', () async {
      _stubLocalTokens(localDatasource);
      _stubNetwork(networkInfo, false);
      when(
        () => localDatasource.clearTokens(),
      ).thenThrow(const CacheException(message: 'Không xóa được token'));

      final result = await repository.logout();

      _expectLeft(
        result,
        isA<CacheFailure>().having(
          (failure) => failure.message,
          'message',
          'Không xóa được token',
        ),
      );
    });
  });

  group('AuthRepositoryImpl FCM token', () {
    test('updateFcmToken online delegate remote và trả Right null', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.updateFcmToken(
          token: 'fcm-token',
          platform: 'android',
        ),
      ).thenAnswer((_) async {});

      final result = await repository.updateFcmToken(
        token: 'fcm-token',
        platform: 'android',
      );

      result.fold(
        (_) => fail('Expected Right'),
        (_) => expect(true, isTrue),
      );
      verify(
        () => remoteDatasource.updateFcmToken(
          token: 'fcm-token',
          platform: 'android',
        ),
      ).called(1);
    });

    test('deleteFcmToken online delegate remote và trả Right null', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.deleteFcmToken(token: 'fcm-token'),
      ).thenAnswer((_) async {});

      final result = await repository.deleteFcmToken(token: 'fcm-token');

      result.fold(
        (_) => fail('Expected Right'),
        (_) => expect(true, isTrue),
      );
      verify(
        () => remoteDatasource.deleteFcmToken(token: 'fcm-token'),
      ).called(1);
    });
  });
}
