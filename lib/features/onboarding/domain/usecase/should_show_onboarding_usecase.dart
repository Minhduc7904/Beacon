import '../repositories/onboarding_repository.dart';

class ShouldShowOnboardingUseCase {
  final OnboardingRepository _repository;

  ShouldShowOnboardingUseCase(this._repository);

  Future<bool> call() async {
    return !(await _repository.hasCompletedOnboarding());
  }
}
