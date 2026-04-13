import '../repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase {
  final OnboardingRepository _repository;

  CompleteOnboardingUseCase(this._repository);

  Future<void> call() {
    return _repository.completeOnboarding();
  }
}
