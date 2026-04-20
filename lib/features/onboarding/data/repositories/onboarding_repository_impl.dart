import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDatasource _localDatasource;

  OnboardingRepositoryImpl(this._localDatasource);

  @override
  Future<bool> hasCompletedOnboarding() {
    return _localDatasource.hasCompletedOnboarding();
  }

  @override
  Future<void> completeOnboarding() {
    return _localDatasource.setCompletedOnboarding();
  }
}
