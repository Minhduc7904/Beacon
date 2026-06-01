import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/usecase/has_local_auth_session_usecase.dart';
import '../../../onboarding/domain/usecase/should_show_onboarding_usecase.dart';
import '../entities/startup_destination.dart';

class ResolveStartupDestinationUseCase {
  final ShouldShowOnboardingUseCase _shouldShowOnboardingUseCase;
  final HasLocalAuthSessionUseCase _hasLocalAuthSessionUseCase;

  ResolveStartupDestinationUseCase(
    this._shouldShowOnboardingUseCase,
    this._hasLocalAuthSessionUseCase,
  );

  Future<Either<Failure, StartupDestination>> call() async {
    bool shouldShowOnboarding;
    try {
      shouldShowOnboarding = await _shouldShowOnboardingUseCase();
    } on Exception {
      return const Right(StartupDestination.onboarding);
    }

    if (shouldShowOnboarding) {
      return const Right(StartupDestination.onboarding);
    }

    try {
      final hasLocalSession = await _hasLocalAuthSessionUseCase();
      return hasLocalSession.fold(
        (_) => const Right(StartupDestination.login),
        (hasSession) => Right(
          hasSession ? StartupDestination.home : StartupDestination.login,
        ),
      );
    } on Exception {
      return const Right(StartupDestination.login);
    }
  }
}
