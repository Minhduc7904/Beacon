import 'package:beacon_app/core/constants/error_messages.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/features/auth/domain/entities/auth_result.dart';
import 'package:beacon_app/features/auth/domain/entities/tokens.dart';
import 'package:beacon_app/features/auth/domain/entities/user.dart';
import 'package:beacon_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:beacon_app/features/auth/domain/usecase/login_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

AuthResult _authResult() {
  return AuthResult(
    message: 'Đăng nhập thành công',
    tokens: Tokens(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
      accessTokenExpiresAt: DateTime.utc(2026),
    ),
    user: User(
      userId: 'user-1',
      username: 'mai',
      email: 'mai@example.com',
      familyName: 'Nguyen',
      givenName: 'Mai',
    ),
  );
}

void main() {
  late MockAuthRepository repository;
  late LoginUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  group('LoginUseCase', () {
    test('trả về usernameError khi username rỗng', () async {
      final result = await useCase(
        const LoginParams(username: '', password: 'password123'),
      );

      result.fold((failure) {
        expect(failure, isA<LoginValidationFailure>());
        final validationFailure = failure as LoginValidationFailure;
        expect(validationFailure.usernameError, ErrorMessages.usernameRequired);
        expect(validationFailure.message, ErrorMessages.usernameRequired);
      }, (_) => fail('Expected Left'));
      verifyNever(
        () => repository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      );
    });

    test('trả về usernameError khi username chỉ có khoảng trắng', () async {
      final result = await useCase(
        const LoginParams(username: '   ', password: 'password123'),
      );

      result.fold((failure) {
        expect(failure, isA<LoginValidationFailure>());
        final validationFailure = failure as LoginValidationFailure;
        expect(validationFailure.usernameError, ErrorMessages.usernameRequired);
      }, (_) => fail('Expected Left'));
      verifyNever(
        () => repository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      );
    });

    test('trả về passwordError khi password rỗng', () async {
      final result = await useCase(
        const LoginParams(username: 'mai', password: ''),
      );

      result.fold((failure) {
        expect(failure, isA<LoginValidationFailure>());
        final validationFailure = failure as LoginValidationFailure;
        expect(validationFailure.passwordError, ErrorMessages.passwordRequired);
        expect(validationFailure.message, ErrorMessages.passwordRequired);
      }, (_) => fail('Expected Left'));
      verifyNever(
        () => repository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      );
    });

    test('trả về passwordError khi password ngắn hơn 8 ký tự', () async {
      final result = await useCase(
        const LoginParams(username: 'mai', password: '1234567'),
      );

      result.fold((failure) {
        expect(failure, isA<LoginValidationFailure>());
        final validationFailure = failure as LoginValidationFailure;
        expect(validationFailure.passwordError, ErrorMessages.passwordTooShort);
      }, (_) => fail('Expected Left'));
      verifyNever(
        () => repository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      );
    });

    test(
      'gọi repository với username và password giữ nguyên khi input hợp lệ',
      () async {
        final authResult = _authResult();
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(authResult));

        final result = await useCase(
          const LoginParams(username: '  mai  ', password: 'password123'),
        );

        expect(result, Right<Failure, AuthResult>(authResult));
        verify(
          () => repository.login(username: '  mai  ', password: 'password123'),
        ).called(1);
      },
    );

    test('pass-through failure từ repository', () async {
      const failure = ServerFailure(message: 'Máy chủ đang lỗi');
      when(
        () => repository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(
        const LoginParams(username: 'mai', password: 'password123'),
      );

      result.fold(
        (actualFailure) => expect(actualFailure, same(failure)),
        (_) => fail('Expected Left'),
      );
    });

    test('trả về AuthResult khi repository đăng nhập thành công', () async {
      final authResult = _authResult();
      when(
        () => repository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Right(authResult));

      final result = await useCase(
        const LoginParams(username: 'mai', password: 'password123'),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (actualResult) => expect(actualResult, same(authResult)),
      );
    });
  });
}
