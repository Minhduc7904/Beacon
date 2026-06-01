import 'package:beacon_app/core/errors/exceptions.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/features/auth/domain/usecase/has_local_auth_session_usecase.dart';
import 'package:beacon_app/features/onboarding/domain/usecase/should_show_onboarding_usecase.dart';
import 'package:beacon_app/features/splash/domain/entities/startup_destination.dart';
import 'package:beacon_app/features/splash/domain/usecase/resolve_startup_destination_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockShouldShowOnboardingUseCase extends Mock
    implements ShouldShowOnboardingUseCase {}

class MockHasLocalAuthSessionUseCase extends Mock
    implements HasLocalAuthSessionUseCase {}

void main() {
  late MockShouldShowOnboardingUseCase shouldShowOnboardingUseCase;
  late MockHasLocalAuthSessionUseCase hasLocalAuthSessionUseCase;
  late ResolveStartupDestinationUseCase useCase;

  setUp(() {
    shouldShowOnboardingUseCase = MockShouldShowOnboardingUseCase();
    hasLocalAuthSessionUseCase = MockHasLocalAuthSessionUseCase();
    useCase = ResolveStartupDestinationUseCase(
      shouldShowOnboardingUseCase,
      hasLocalAuthSessionUseCase,
    );
  });

  group('ResolveStartupDestinationUseCase', () {
    test('onboarding chưa hoàn tất -> onboarding', () async {
      when(() => shouldShowOnboardingUseCase()).thenAnswer((_) async => true);

      final result = await useCase();

      expect(
        result,
        const Right<Failure, StartupDestination>(
          StartupDestination.onboarding,
        ),
      );
      verify(() => shouldShowOnboardingUseCase()).called(1);
      verifyNever(() => hasLocalAuthSessionUseCase());
    });

    test('onboarding hoàn tất + không có local session -> login', () async {
      when(() => shouldShowOnboardingUseCase()).thenAnswer((_) async => false);
      when(
        () => hasLocalAuthSessionUseCase(),
      ).thenAnswer((_) async => const Right(false));

      final result = await useCase();

      expect(
        result,
        const Right<Failure, StartupDestination>(StartupDestination.login),
      );
      verify(() => shouldShowOnboardingUseCase()).called(1);
      verify(() => hasLocalAuthSessionUseCase()).called(1);
    });

    test('onboarding hoàn tất + có access và refresh token -> home', () async {
      when(() => shouldShowOnboardingUseCase()).thenAnswer((_) async => false);
      when(
        () => hasLocalAuthSessionUseCase(),
      ).thenAnswer((_) async => const Right(true));

      final result = await useCase();

      expect(
        result,
        const Right<Failure, StartupDestination>(StartupDestination.home),
      );
      verify(() => shouldShowOnboardingUseCase()).called(1);
      verify(() => hasLocalAuthSessionUseCase()).called(1);
    });

    test('lỗi đọc local session fallback về login', () async {
      when(() => shouldShowOnboardingUseCase()).thenAnswer((_) async => false);
      when(
        () => hasLocalAuthSessionUseCase(),
      ).thenAnswer(
        (_) async => const Left(CacheFailure(message: 'Token storage error')),
      );

      final result = await useCase();

      expect(
        result,
        const Right<Failure, StartupDestination>(StartupDestination.login),
      );
      verify(() => hasLocalAuthSessionUseCase()).called(1);
    });

    test('exception khi đọc local session fallback về login', () async {
      when(() => shouldShowOnboardingUseCase()).thenAnswer((_) async => false);
      when(
        () => hasLocalAuthSessionUseCase(),
      ).thenThrow(const CacheException(message: 'Token storage error'));

      final result = await useCase();

      expect(
        result,
        const Right<Failure, StartupDestination>(StartupDestination.login),
      );
      verify(() => hasLocalAuthSessionUseCase()).called(1);
    });

    test('lỗi đọc onboarding fallback về onboarding', () async {
      when(
        () => shouldShowOnboardingUseCase(),
      ).thenThrow(const CacheException(message: 'Onboarding storage error'));

      final result = await useCase();

      expect(
        result,
        const Right<Failure, StartupDestination>(
          StartupDestination.onboarding,
        ),
      );
      verifyNever(() => hasLocalAuthSessionUseCase());
    });
  });
}
