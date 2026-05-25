import 'package:beacon_app/core/constants/error_messages.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:beacon_app/features/auth/domain/usecase/check_email_availability_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late CheckEmailAvailabilityUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = CheckEmailAvailabilityUseCase(repository);
  });

  group('CheckEmailAvailabilityUseCase', () {
    test(
      'trả về ValidationFailure và không gọi repository khi email rỗng',
      () async {
        final result = await useCase(
          const CheckEmailAvailabilityParams(email: '   '),
        );

        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, ErrorMessages.emailRequired);
        }, (_) => fail('Expected Left'));
        verifyNever(
          () => repository.checkEmailAvailable(email: any(named: 'email')),
        );
      },
    );

    test(
      'trả về ValidationFailure và không gọi repository khi email sai định dạng',
      () async {
        final result = await useCase(
          const CheckEmailAvailabilityParams(email: 'mai.example.com'),
        );

        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, ErrorMessages.emailInvalidFormat);
        }, (_) => fail('Expected Left'));
        verifyNever(
          () => repository.checkEmailAvailable(email: any(named: 'email')),
        );
      },
    );

    test(
      'trim email nhưng giữ nguyên chữ hoa thường khi gọi repository',
      () async {
        when(
          () => repository.checkEmailAvailable(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(true));

        final result = await useCase(
          const CheckEmailAvailabilityParams(email: '  Mai@Example.COM  '),
        );

        expect(result, const Right<Failure, String>('Mai@Example.COM'));
        verify(
          () => repository.checkEmailAvailable(email: 'Mai@Example.COM'),
        ).called(1);
      },
    );

    test('trả về email đã trim khi email available', () async {
      when(
        () => repository.checkEmailAvailable(email: any(named: 'email')),
      ).thenAnswer((_) async => const Right(true));

      final result = await useCase(
        const CheckEmailAvailabilityParams(email: '  mai@example.com  '),
      );

      expect(result, const Right<Failure, String>('mai@example.com'));
    });

    test(
      'map email unavailable thành ValidationFailure registerEmailExists',
      () async {
        when(
          () => repository.checkEmailAvailable(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(false));

        final result = await useCase(
          const CheckEmailAvailabilityParams(email: 'mai@example.com'),
        );

        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, ErrorMessages.registerEmailExists);
        }, (_) => fail('Expected Left'));
      },
    );

    test('pass-through failure từ repository', () async {
      const failure = ServerFailure(message: 'Không kiểm tra được email');
      when(
        () => repository.checkEmailAvailable(email: any(named: 'email')),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(
        const CheckEmailAvailabilityParams(email: 'mai@example.com'),
      );

      result.fold(
        (actualFailure) => expect(actualFailure, same(failure)),
        (_) => fail('Expected Left'),
      );
    });
  });
}
