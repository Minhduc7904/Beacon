import 'package:beacon_app/core/constants/error_messages.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/features/auth/domain/entities/user_profile.dart';
import 'package:beacon_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:beacon_app/features/auth/domain/usecase/update_me_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

UserProfile _userProfile() {
  return UserProfile(
    id: 'user-1',
    username: 'mai',
    email: 'mai@example.com',
    familyName: 'Nguyen',
    givenName: 'Mai',
    phoneNumber: '+84912345678',
    timeZone: 'Asia/Ho_Chi_Minh',
    isActive: true,
    isEmailVerified: true,
    lastLoginAtUtc: DateTime.utc(2026),
    createdAtUtc: DateTime.utc(2025),
    avatarMediaObjectId: null,
    avatarUrl: null,
  );
}

void _verifyUpdateMeNeverCalled(MockAuthRepository repository) {
  verifyNever(
    () => repository.updateMe(
      familyName: any(named: 'familyName'),
      givenName: any(named: 'givenName'),
      email: any(named: 'email'),
      phoneNumber: any(named: 'phoneNumber'),
    ),
  );
}

void main() {
  late MockAuthRepository repository;
  late UpdateMeUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = UpdateMeUseCase(repository);
  });

  group('UpdateMeUseCase', () {
    test('trả về ValidationFailure khi không có thay đổi', () async {
      final result = await useCase(const UpdateMeParams());

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.noProfileChanges);
      }, (_) => fail('Expected Left'));
      _verifyUpdateMeNeverCalled(repository);
    });

    test('trả về ValidationFailure khi familyName blank', () async {
      final result = await useCase(const UpdateMeParams(familyName: '   '));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.familyNameRequired);
      }, (_) => fail('Expected Left'));
      _verifyUpdateMeNeverCalled(repository);
    });

    test('trả về ValidationFailure khi givenName blank', () async {
      final result = await useCase(const UpdateMeParams(givenName: '   '));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.givenNameRequired);
      }, (_) => fail('Expected Left'));
      _verifyUpdateMeNeverCalled(repository);
    });

    test('trả về ValidationFailure khi email rỗng', () async {
      final result = await useCase(const UpdateMeParams(email: '   '));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.emailRequired);
      }, (_) => fail('Expected Left'));
      _verifyUpdateMeNeverCalled(repository);
    });

    test('trả về ValidationFailure khi email sai định dạng', () async {
      final result = await useCase(
        const UpdateMeParams(email: 'mai.example.com'),
      );

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.emailInvalidFormat);
      }, (_) => fail('Expected Left'));
      _verifyUpdateMeNeverCalled(repository);
    });

    test('trả về ValidationFailure khi phone rỗng', () async {
      final result = await useCase(const UpdateMeParams(phoneNumber: '   '));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.phoneRequired);
      }, (_) => fail('Expected Left'));
      _verifyUpdateMeNeverCalled(repository);
    });

    test('trả về ValidationFailure khi phone không hợp lệ', () async {
      final result = await useCase(
        const UpdateMeParams(phoneNumber: '0112345678'),
      );

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.phoneInvalidVietnam);
      }, (_) => fail('Expected Left'));
      _verifyUpdateMeNeverCalled(repository);
    });

    test(
      'trim name, lowercase email và chuyển phone sang E.164 khi gọi repository',
      () async {
        final profile = _userProfile();
        when(
          () => repository.updateMe(
            familyName: any(named: 'familyName'),
            givenName: any(named: 'givenName'),
            email: any(named: 'email'),
            phoneNumber: any(named: 'phoneNumber'),
          ),
        ).thenAnswer((_) async => Right(profile));

        final result = await useCase(
          const UpdateMeParams(
            familyName: '  Nguyen  ',
            givenName: '  Mai  ',
            email: '  Mai@Example.COM  ',
            phoneNumber: '0912345678',
          ),
        );

        result.fold(
          (_) => fail('Expected Right'),
          (actualProfile) => expect(actualProfile, same(profile)),
        );
        verify(
          () => repository.updateMe(
            familyName: 'Nguyen',
            givenName: 'Mai',
            email: 'mai@example.com',
            phoneNumber: '+84912345678',
          ),
        ).called(1);
      },
    );

    test('pass-through failure từ repository', () async {
      const failure = ServerFailure(message: 'Cập nhật hồ sơ thất bại');
      when(
        () => repository.updateMe(
          familyName: any(named: 'familyName'),
          givenName: any(named: 'givenName'),
          email: any(named: 'email'),
          phoneNumber: any(named: 'phoneNumber'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(const UpdateMeParams(givenName: 'Mai'));

      result.fold(
        (actualFailure) => expect(actualFailure, same(failure)),
        (_) => fail('Expected Left'),
      );
    });

    test('trả về UserProfile khi repository cập nhật thành công', () async {
      final profile = _userProfile();
      when(
        () => repository.updateMe(
          familyName: any(named: 'familyName'),
          givenName: any(named: 'givenName'),
          email: any(named: 'email'),
          phoneNumber: any(named: 'phoneNumber'),
        ),
      ).thenAnswer((_) async => Right(profile));

      final result = await useCase(const UpdateMeParams(givenName: 'Mai'));

      result.fold(
        (_) => fail('Expected Right'),
        (actualProfile) => expect(actualProfile, same(profile)),
      );
    });
  });
}
