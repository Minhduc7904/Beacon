import 'package:beacon_app/core/constants/error_messages.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:beacon_app/features/auth/domain/usecase/check_phone_availability_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late CheckPhoneAvailabilityUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = CheckPhoneAvailabilityUseCase(repository);
  });

  group('CheckPhoneAvailabilityUseCase', () {
    test(
      'trả về ValidationFailure và không gọi repository khi phone rỗng',
      () async {
        final result = await useCase(
          const CheckPhoneAvailabilityParams(phoneNumber: '   '),
        );

        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, ErrorMessages.phoneRequired);
        }, (_) => fail('Expected Left'));
        verifyNever(
          () => repository.checkPhoneAvailable(
            phoneNumber: any(named: 'phoneNumber'),
          ),
        );
      },
    );

    test(
      'trả về ValidationFailure và không gọi repository khi phone không hợp lệ',
      () async {
        final result = await useCase(
          const CheckPhoneAvailabilityParams(phoneNumber: '0112345678'),
        );

        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, ErrorMessages.phoneInvalidVietnam);
        }, (_) => fail('Expected Left'));
        verifyNever(
          () => repository.checkPhoneAvailable(
            phoneNumber: any(named: 'phoneNumber'),
          ),
        );
      },
    );

    test('gọi repository bằng E.164 và trả về local phone đã trim', () async {
      when(
        () => repository.checkPhoneAvailable(
          phoneNumber: any(named: 'phoneNumber'),
        ),
      ).thenAnswer((_) async => const Right(true));

      final result = await useCase(
        const CheckPhoneAvailabilityParams(phoneNumber: ' 0912345678 '),
      );

      expect(result, const Right<Failure, String>('0912345678'));
      verify(
        () => repository.checkPhoneAvailable(phoneNumber: '+84912345678'),
      ).called(1);
    });

    test('gọi repository đúng khi phone bắt đầu bằng 84', () async {
      when(
        () => repository.checkPhoneAvailable(
          phoneNumber: any(named: 'phoneNumber'),
        ),
      ).thenAnswer((_) async => const Right(true));

      final result = await useCase(
        const CheckPhoneAvailabilityParams(phoneNumber: '84912345678'),
      );

      expect(result, const Right<Failure, String>('84912345678'));
      verify(
        () => repository.checkPhoneAvailable(phoneNumber: '+84912345678'),
      ).called(1);
    });

    test('gọi repository đúng khi phone bắt đầu bằng +84', () async {
      when(
        () => repository.checkPhoneAvailable(
          phoneNumber: any(named: 'phoneNumber'),
        ),
      ).thenAnswer((_) async => const Right(true));

      final result = await useCase(
        const CheckPhoneAvailabilityParams(phoneNumber: '+84912345678'),
      );

      expect(result, const Right<Failure, String>('+84912345678'));
      verify(
        () => repository.checkPhoneAvailable(phoneNumber: '+84912345678'),
      ).called(1);
    });

    test(
      'map phone unavailable thành ValidationFailure registerPhoneExists',
      () async {
        when(
          () => repository.checkPhoneAvailable(
            phoneNumber: any(named: 'phoneNumber'),
          ),
        ).thenAnswer((_) async => const Right(false));

        final result = await useCase(
          const CheckPhoneAvailabilityParams(phoneNumber: '0912345678'),
        );

        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, ErrorMessages.registerPhoneExists);
        }, (_) => fail('Expected Left'));
      },
    );

    test('pass-through failure từ repository', () async {
      const failure = ServerFailure(
        message: 'Không kiểm tra được số điện thoại',
      );
      when(
        () => repository.checkPhoneAvailable(
          phoneNumber: any(named: 'phoneNumber'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(
        const CheckPhoneAvailabilityParams(phoneNumber: '0912345678'),
      );

      result.fold(
        (actualFailure) => expect(actualFailure, same(failure)),
        (_) => fail('Expected Left'),
      );
    });
  });
}
