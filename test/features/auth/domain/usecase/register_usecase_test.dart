import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/features/auth/domain/entities/auth_result.dart';
import 'package:beacon_app/features/auth/domain/entities/tokens.dart';
import 'package:beacon_app/features/auth/domain/entities/user.dart';
import 'package:beacon_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:beacon_app/features/auth/domain/usecase/register_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

const _validParams = RegisterParams(
  email: 'mai@example.com',
  username: 'mai',
  password: 'secret1',
  confirmPassword: 'secret1',
  familyName: 'Nguyen',
  givenName: 'Mai',
  phoneNumber: '0912345678',
);

AuthResult _authResult() {
  return AuthResult(
    message: 'Đăng ký thành công',
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

RegisterParams _params({
  String email = 'mai@example.com',
  String username = 'mai',
  String password = 'secret1',
  String confirmPassword = 'secret1',
  String familyName = 'Nguyen',
  String givenName = 'Mai',
  String phoneNumber = '0912345678',
}) {
  return RegisterParams(
    email: email,
    username: username,
    password: password,
    confirmPassword: confirmPassword,
    familyName: familyName,
    givenName: givenName,
    phoneNumber: phoneNumber,
  );
}

void _verifyRegisterNeverCalled(MockAuthRepository repository) {
  verifyNever(
    () => repository.register(
      email: any(named: 'email'),
      confirmPassword: any(named: 'confirmPassword'),
      familyName: any(named: 'familyName'),
      givenName: any(named: 'givenName'),
      username: any(named: 'username'),
      password: any(named: 'password'),
      phoneNumber: any(named: 'phoneNumber'),
    ),
  );
}

void main() {
  late MockAuthRepository repository;
  late RegisterUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = RegisterUseCase(repository);
  });

  group('RegisterUseCase', () {
    test('trả về ValidationFailure khi email rỗng', () async {
      final result = await useCase(_params(email: '   '));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Email không được để trống');
      }, (_) => fail('Expected Left'));
      _verifyRegisterNeverCalled(repository);
    });

    test('trả về ValidationFailure khi email sai định dạng', () async {
      final result = await useCase(_params(email: 'mai.example.com'));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Email không đúng định dạng');
      }, (_) => fail('Expected Left'));
      _verifyRegisterNeverCalled(repository);
    });

    test('trả về ValidationFailure khi familyName rỗng', () async {
      final result = await useCase(_params(familyName: '   '));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Họ và tên đệm không được để trống');
      }, (_) => fail('Expected Left'));
      _verifyRegisterNeverCalled(repository);
    });

    test('trả về ValidationFailure khi givenName rỗng', () async {
      final result = await useCase(_params(givenName: '   '));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Tên riêng không được để trống');
      }, (_) => fail('Expected Left'));
      _verifyRegisterNeverCalled(repository);
    });

    test('trả về ValidationFailure khi username rỗng', () async {
      final result = await useCase(_params(username: '   '));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Tên đăng nhập không được để trống');
      }, (_) => fail('Expected Left'));
      _verifyRegisterNeverCalled(repository);
    });

    test('trả về ValidationFailure khi password rỗng', () async {
      final result = await useCase(_params(password: ''));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Mật khẩu không được để trống');
      }, (_) => fail('Expected Left'));
      _verifyRegisterNeverCalled(repository);
    });

    test('trả về ValidationFailure khi password ngắn hơn 6 ký tự', () async {
      final result = await useCase(
        _params(password: '12345', confirmPassword: '12345'),
      );

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Mật khẩu phải có ít nhất 6 ký tự');
      }, (_) => fail('Expected Left'));
      _verifyRegisterNeverCalled(repository);
    });

    test('trả về ValidationFailure khi confirmPassword rỗng', () async {
      final result = await useCase(_params(confirmPassword: ''));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Xác nhận mật khẩu không được để trống');
      }, (_) => fail('Expected Left'));
      _verifyRegisterNeverCalled(repository);
    });

    test('trả về ValidationFailure khi confirmPassword không khớp', () async {
      final result = await useCase(_params(confirmPassword: 'different'));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Mật khẩu xác nhận không khớp');
      }, (_) => fail('Expected Left'));
      _verifyRegisterNeverCalled(repository);
    });

    test('trả về ValidationFailure khi phoneNumber rỗng', () async {
      final result = await useCase(_params(phoneNumber: '   '));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Số điện thoại không được để trống');
      }, (_) => fail('Expected Left'));
      _verifyRegisterNeverCalled(repository);
    });

    test('trả về ValidationFailure khi phoneNumber không hợp lệ', () async {
      final result = await useCase(_params(phoneNumber: '0112345678'));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Số điện thoại Việt Nam không hợp lệ');
      }, (_) => fail('Expected Left'));
      _verifyRegisterNeverCalled(repository);
    });

    test('gọi repository với params giữ nguyên khi input hợp lệ', () async {
      final authResult = _authResult();
      when(
        () => repository.register(
          email: any(named: 'email'),
          confirmPassword: any(named: 'confirmPassword'),
          familyName: any(named: 'familyName'),
          givenName: any(named: 'givenName'),
          username: any(named: 'username'),
          password: any(named: 'password'),
          phoneNumber: any(named: 'phoneNumber'),
        ),
      ).thenAnswer((_) async => Right(authResult));

      final result = await useCase(
        _params(
          email: '  Mai@Example.COM  ',
          username: '  mai  ',
          familyName: '  Nguyen  ',
          givenName: '  Mai  ',
          phoneNumber: ' 091 234 56 78 ',
        ),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (actualResult) => expect(actualResult, same(authResult)),
      );
      verify(
        () => repository.register(
          email: '  Mai@Example.COM  ',
          confirmPassword: 'secret1',
          familyName: '  Nguyen  ',
          givenName: '  Mai  ',
          username: '  mai  ',
          password: 'secret1',
          phoneNumber: ' 091 234 56 78 ',
        ),
      ).called(1);
    });

    test('pass-through failure từ repository', () async {
      const failure = ServerFailure(message: 'Đăng ký thất bại');
      when(
        () => repository.register(
          email: any(named: 'email'),
          confirmPassword: any(named: 'confirmPassword'),
          familyName: any(named: 'familyName'),
          givenName: any(named: 'givenName'),
          username: any(named: 'username'),
          password: any(named: 'password'),
          phoneNumber: any(named: 'phoneNumber'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(_validParams);

      result.fold(
        (actualFailure) => expect(actualFailure, same(failure)),
        (_) => fail('Expected Left'),
      );
    });

    test('trả về AuthResult khi repository đăng ký thành công', () async {
      final authResult = _authResult();
      when(
        () => repository.register(
          email: any(named: 'email'),
          confirmPassword: any(named: 'confirmPassword'),
          familyName: any(named: 'familyName'),
          givenName: any(named: 'givenName'),
          username: any(named: 'username'),
          password: any(named: 'password'),
          phoneNumber: any(named: 'phoneNumber'),
        ),
      ).thenAnswer((_) async => Right(authResult));

      final result = await useCase(_validParams);

      result.fold(
        (_) => fail('Expected Right'),
        (actualResult) => expect(actualResult, same(authResult)),
      );
    });
  });
}
