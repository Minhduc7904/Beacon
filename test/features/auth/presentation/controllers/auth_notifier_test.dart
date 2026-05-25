import 'dart:async';

import 'package:beacon_app/core/constants/error_messages.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/core/messages/app_message_notifier.dart';
import 'package:beacon_app/core/notifications/push_notification_service.dart';
import 'package:beacon_app/core/realtime/signalr_service.dart';
import 'package:beacon_app/features/auth/domain/entities/auth_result.dart';
import 'package:beacon_app/features/auth/domain/entities/tokens.dart';
import 'package:beacon_app/features/auth/domain/entities/user.dart';
import 'package:beacon_app/features/auth/domain/entities/user_profile.dart';
import 'package:beacon_app/features/auth/domain/usecase/get_me_usecase.dart';
import 'package:beacon_app/features/auth/domain/usecase/login_usecase.dart';
import 'package:beacon_app/features/auth/domain/usecase/logout_usecase.dart';
import 'package:beacon_app/features/auth/domain/usecase/register_usecase.dart';
import 'package:beacon_app/features/auth/presentation/controllers/auth_notifier.dart';
import 'package:beacon_app/features/auth/presentation/controllers/auth_state.dart';
import 'package:beacon_app/features/auth/presentation/controllers/me_profile_notifier.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockGetMeUseCase extends Mock implements GetMeUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockMeProfileNotifier extends Mock implements MeProfileNotifier {}

class MockAppMessageNotifier extends Mock implements AppMessageNotifier {}

class MockSignalRService extends Mock implements SignalRService {}

class MockPushNotificationService extends Mock
    implements PushNotificationService {}

AuthResult _authResult({String message = 'Đăng nhập thành công'}) {
  return AuthResult(
    message: message,
    tokens: Tokens(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
      accessTokenExpiresAt: DateTime.utc(2026, 5, 26, 12),
    ),
    user: User(
      userId: 'auth-user-1',
      username: 'auth-user',
      email: 'auth@example.com',
      familyName: 'Auth',
      givenName: 'User',
    ),
  );
}

UserProfile _profile({
  String id = 'profile-user-1',
  String username = 'mai',
  String email = 'mai@example.com',
  String familyName = 'Nguyen',
  String givenName = 'Mai',
}) {
  return UserProfile(
    id: id,
    username: username,
    email: email,
    familyName: familyName,
    givenName: givenName,
    phoneNumber: '+84912345678',
    timeZone: 'Asia/Ho_Chi_Minh',
    isActive: true,
    isEmailVerified: true,
    lastLoginAtUtc: DateTime.utc(2026, 5, 26, 10),
    createdAtUtc: DateTime.utc(2025, 1, 1),
    avatarMediaObjectId: null,
    avatarUrl: null,
  );
}

void main() {
  late MockLoginUseCase loginUseCase;
  late MockGetMeUseCase getMeUseCase;
  late MockRegisterUseCase registerUseCase;
  late MockLogoutUseCase logoutUseCase;
  late MockMeProfileNotifier meProfileNotifier;
  late MockAppMessageNotifier messageNotifier;
  late MockSignalRService signalRService;
  late MockPushNotificationService pushNotificationService;
  late AuthNotifier notifier;

  setUpAll(() {
    registerFallbackValue(
      const LoginParams(username: 'fallback', password: 'password123'),
    );
    registerFallbackValue(
      const RegisterParams(
        email: 'fallback@example.com',
        username: 'fallback',
        password: 'password123',
        confirmPassword: 'password123',
        familyName: 'Nguyen',
        givenName: 'Mai',
        phoneNumber: '+84912345678',
      ),
    );
    registerFallbackValue(_profile());
  });

  setUp(() {
    loginUseCase = MockLoginUseCase();
    getMeUseCase = MockGetMeUseCase();
    registerUseCase = MockRegisterUseCase();
    logoutUseCase = MockLogoutUseCase();
    meProfileNotifier = MockMeProfileNotifier();
    messageNotifier = MockAppMessageNotifier();
    signalRService = MockSignalRService();
    pushNotificationService = MockPushNotificationService();

    when(() => signalRService.connect()).thenAnswer((_) async {});
    when(() => signalRService.disconnect()).thenAnswer((_) async {});
    when(
      () => pushNotificationService.registerCurrentDeviceToken(),
    ).thenAnswer((_) async {});
    when(
      () => pushNotificationService.deleteCurrentDeviceToken(),
    ).thenAnswer((_) async {});

    notifier = AuthNotifier(
      loginUseCase,
      getMeUseCase,
      registerUseCase,
      logoutUseCase,
      meProfileNotifier,
      messageNotifier,
      signalRService,
      pushNotificationService,
    );
  });

  group('AuthNotifier initial/reset', () {
    test('khởi tạo với AuthInitial và không tự gọi usecase', () {
      expect(notifier.state, isA<AuthInitial>());
      verifyNever(() => loginUseCase(any()));
      verifyNever(() => getMeUseCase.call());
      verifyNever(() => registerUseCase(any()));
      verifyNever(() => logoutUseCase.call());
    });

    test('reset clear profile và đưa state về AuthInitial', () {
      notifier.reset();

      expect(notifier.state, isA<AuthInitial>());
      verify(() => meProfileNotifier.clearProfile()).called(1);
    });
  });

  group('AuthNotifier login', () {
    test('set AuthLoading, gọi LoginUseCase đúng params và login thành công', () async {
      final loginCompleter = Completer<Either<Failure, AuthResult>>();
      final authResult = _authResult(message: 'API login ok');
      final profile = _profile();
      when(() => loginUseCase(any())).thenAnswer((_) => loginCompleter.future);
      when(
        () => getMeUseCase.call(),
      ).thenAnswer((_) async => Right(profile));

      final future = notifier.login(username: 'mai', password: 'password123');

      expect(notifier.state, isA<AuthLoading>());
      verify(() => meProfileNotifier.clearProfile()).called(1);

      loginCompleter.complete(Right(authResult));
      await future;

      final captured = verify(() => loginUseCase(captureAny())).captured.single
          as LoginParams;
      expect(captured.username, 'mai');
      expect(captured.password, 'password123');
      verify(() => getMeUseCase.call()).called(1);
      verify(() => meProfileNotifier.setProfile(profile)).called(1);
      verify(() => messageNotifier.addSuccess('API login ok')).called(1);
      verify(() => signalRService.connect()).called(1);
      verify(
        () => pushNotificationService.registerCurrentDeviceToken(),
      ).called(1);

      final state = notifier.state;
      expect(state, isA<AuthSuccess>());
      final success = state as AuthSuccess;
      expect(success.successMessage, 'API login ok');
      expect(success.user.userId, profile.id);
      expect(success.user.username, profile.username);
      expect(success.user.email, profile.email);
      expect(success.user.familyName, profile.familyName);
      expect(success.user.givenName, profile.givenName);
    });

    test('login success dùng fallback message khi API message rỗng', () async {
      final authResult = _authResult(message: '   ');
      final profile = _profile();
      when(
        () => loginUseCase(any()),
      ).thenAnswer((_) async => Right(authResult));
      when(
        () => getMeUseCase.call(),
      ).thenAnswer((_) async => Right(profile));

      await notifier.login(username: 'mai', password: 'password123');

      verify(() => messageNotifier.addSuccess('Đăng nhập thành công')).called(1);
      final success = notifier.state as AuthSuccess;
      expect(success.successMessage, 'Đăng nhập thành công');
    });

    test('LoginValidationFailure chuyển thành AuthValidationError', () async {
      const failure = LoginValidationFailure(
        usernameError: ErrorMessages.usernameRequired,
      );
      when(
        () => loginUseCase(any()),
      ).thenAnswer((_) async => const Left(failure));

      await notifier.login(username: '', password: 'password123');

      final state = notifier.state;
      expect(state, isA<AuthValidationError>());
      final validation = state as AuthValidationError;
      expect(validation.message, ErrorMessages.usernameRequired);
      expect(validation.usernameError, ErrorMessages.usernameRequired);
      expect(validation.passwordError, isNull);
      verifyNever(() => getMeUseCase.call());
      verifyNever(() => messageNotifier.addError(any()));
    });

    test('login ValidationFailure thường chuyển thành AuthValidationError', () async {
      const failure = ValidationFailure(message: 'Dữ liệu login không hợp lệ');
      when(
        () => loginUseCase(any()),
      ).thenAnswer((_) async => const Left(failure));

      await notifier.login(username: 'mai', password: 'password123');

      final state = notifier.state;
      expect(state, isA<AuthValidationError>());
      expect((state as AuthValidationError).message, failure.message);
      verifyNever(() => getMeUseCase.call());
      verifyNever(() => messageNotifier.addError(any()));
    });

    test('login failure không phải validation phát message và AuthError', () async {
      const failure = UnauthorizedFailure(message: 'Sai username hoặc password');
      when(
        () => loginUseCase(any()),
      ).thenAnswer((_) async => const Left(failure));

      await notifier.login(username: 'mai', password: 'password123');

      verify(() => messageNotifier.addError(failure.message)).called(1);
      verifyNever(() => getMeUseCase.call());
      final state = notifier.state;
      expect(state, isA<AuthError>());
      expect((state as AuthError).message, failure.message);
    });

    test('login success nhưng getMe fail thì clear profile và AuthError', () async {
      final authResult = _authResult();
      const failure = ServerFailure(message: 'Không tải được hồ sơ');
      when(
        () => loginUseCase(any()),
      ).thenAnswer((_) async => Right(authResult));
      when(
        () => getMeUseCase.call(),
      ).thenAnswer((_) async => const Left(failure));

      await notifier.login(username: 'mai', password: 'password123');

      verify(() => messageNotifier.addError(failure.message)).called(1);
      verify(() => meProfileNotifier.clearProfile()).called(2);
      verifyNever(() => meProfileNotifier.setProfile(any()));
      verifyNever(() => signalRService.connect());
      verifyNever(() => pushNotificationService.registerCurrentDeviceToken());
      final state = notifier.state;
      expect(state, isA<AuthError>());
      expect((state as AuthError).message, failure.message);
    });
  });

  group('AuthNotifier register', () {
    test('register success gọi usecase đúng params và AuthSuccess', () async {
      final registerCompleter = Completer<Either<Failure, AuthResult>>();
      final authResult = _authResult(message: 'API register ok');
      when(
        () => registerUseCase(any()),
      ).thenAnswer((_) => registerCompleter.future);

      final future = notifier.register(
        email: 'mai@example.com',
        username: 'mai',
        password: 'password123',
        confirmPassword: 'password123',
        familyName: 'Nguyen',
        givenName: 'Mai',
        phoneNumber: '+84912345678',
      );

      expect(notifier.state, isA<AuthLoading>());

      registerCompleter.complete(Right(authResult));
      await future;

      final captured = verify(
        () => registerUseCase(captureAny()),
      ).captured.single as RegisterParams;
      expect(captured.email, 'mai@example.com');
      expect(captured.username, 'mai');
      expect(captured.password, 'password123');
      expect(captured.confirmPassword, 'password123');
      expect(captured.familyName, 'Nguyen');
      expect(captured.givenName, 'Mai');
      expect(captured.phoneNumber, '+84912345678');
      verify(() => messageNotifier.addSuccess('API register ok')).called(1);
      verifyNever(() => getMeUseCase.call());

      final state = notifier.state;
      expect(state, isA<AuthSuccess>());
      final success = state as AuthSuccess;
      expect(success.user, same(authResult.user));
      expect(success.successMessage, 'API register ok');
    });

    test('register success dùng fallback message khi API message rỗng', () async {
      final authResult = _authResult(message: ' ');
      when(
        () => registerUseCase(any()),
      ).thenAnswer((_) async => Right(authResult));

      await notifier.register(
        email: 'mai@example.com',
        username: 'mai',
        password: 'password123',
        confirmPassword: 'password123',
        familyName: 'Nguyen',
        givenName: 'Mai',
        phoneNumber: '+84912345678',
      );

      verify(() => messageNotifier.addSuccess('Đăng ký thành công!')).called(1);
      expect(
        (notifier.state as AuthSuccess).successMessage,
        'Đăng ký thành công!',
      );
    });

    test('register ValidationFailure chuyển thành AuthValidationError', () async {
      const failure = ValidationFailure(message: 'Email không đúng định dạng');
      when(
        () => registerUseCase(any()),
      ).thenAnswer((_) async => const Left(failure));

      await notifier.register(
        email: 'bad-email',
        username: 'mai',
        password: 'password123',
        confirmPassword: 'password123',
        familyName: 'Nguyen',
        givenName: 'Mai',
        phoneNumber: '+84912345678',
      );

      final state = notifier.state;
      expect(state, isA<AuthValidationError>());
      expect((state as AuthValidationError).message, failure.message);
      verifyNever(() => messageNotifier.addError(any()));
    });

    test('register username conflict chuyển thành username AuthValidationError', () async {
      const failure = ServerFailure(message: 'username is already taken.');
      when(
        () => registerUseCase(any()),
      ).thenAnswer((_) async => const Left(failure));

      await notifier.register(
        email: 'mai@example.com',
        username: 'mai',
        password: 'password123',
        confirmPassword: 'password123',
        familyName: 'Nguyen',
        givenName: 'Mai',
        phoneNumber: '+84912345678',
      );

      verify(() => messageNotifier.addError(failure.message)).called(1);
      final state = notifier.state;
      expect(state, isA<AuthValidationError>());
      final validation = state as AuthValidationError;
      expect(validation.message, failure.message);
      expect(validation.usernameError, failure.message);
    });

    test('register server failure chuyển thành AuthError', () async {
      const failure = ServerFailure(message: 'Đăng ký thất bại');
      when(
        () => registerUseCase(any()),
      ).thenAnswer((_) async => const Left(failure));

      await notifier.register(
        email: 'mai@example.com',
        username: 'mai',
        password: 'password123',
        confirmPassword: 'password123',
        familyName: 'Nguyen',
        givenName: 'Mai',
        phoneNumber: '+84912345678',
      );

      verify(() => messageNotifier.addError(failure.message)).called(1);
      final state = notifier.state;
      expect(state, isA<AuthError>());
      expect((state as AuthError).message, failure.message);
    });
  });

  group('AuthNotifier logout', () {
    test('logout success disconnect, delete FCM, gọi usecase và AuthInitial', () async {
      when(
        () => logoutUseCase.call(),
      ).thenAnswer((_) async => const Right('Đăng xuất thành công'));

      final future = notifier.logout();

      expect(notifier.state, isA<AuthLoading>());

      await future;

      verify(() => meProfileNotifier.clearProfile()).called(1);
      verify(() => signalRService.disconnect()).called(1);
      verify(
        () => pushNotificationService.deleteCurrentDeviceToken(),
      ).called(1);
      verify(() => logoutUseCase.call()).called(1);
      expect(notifier.state, isA<AuthInitial>());
      verifyNever(() => messageNotifier.addSuccess(any()));
    });

    test('logout failure phát message lỗi và AuthError', () async {
      const failure = ServerFailure(message: 'Đăng xuất thất bại');
      when(
        () => logoutUseCase.call(),
      ).thenAnswer((_) async => const Left(failure));

      await notifier.logout();

      verify(() => meProfileNotifier.clearProfile()).called(1);
      verify(() => signalRService.disconnect()).called(1);
      verify(
        () => pushNotificationService.deleteCurrentDeviceToken(),
      ).called(1);
      verify(() => messageNotifier.addError(failure.message)).called(1);
      final state = notifier.state;
      expect(state, isA<AuthError>());
      expect((state as AuthError).message, failure.message);
    });
  });
}
