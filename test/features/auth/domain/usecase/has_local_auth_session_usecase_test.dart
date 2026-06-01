import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:beacon_app/features/auth/domain/usecase/has_local_auth_session_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late HasLocalAuthSessionUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = HasLocalAuthSessionUseCase(repository);
  });

  group('HasLocalAuthSessionUseCase', () {
    test('trả về true khi repository có local session', () async {
      when(
        () => repository.hasLocalSession(),
      ).thenAnswer((_) async => const Right(true));

      final result = await useCase();

      expect(result, const Right<Failure, bool>(true));
      verify(() => repository.hasLocalSession()).called(1);
    });

    test('trả về false khi repository không có local session', () async {
      when(
        () => repository.hasLocalSession(),
      ).thenAnswer((_) async => const Right(false));

      final result = await useCase();

      expect(result, const Right<Failure, bool>(false));
      verify(() => repository.hasLocalSession()).called(1);
    });

    test('pass-through failure từ repository', () async {
      const failure = CacheFailure(message: 'Không đọc được token');
      when(
        () => repository.hasLocalSession(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase();

      result.fold(
        (actualFailure) => expect(actualFailure, same(failure)),
        (_) => fail('Expected Left'),
      );
    });
  });
}
