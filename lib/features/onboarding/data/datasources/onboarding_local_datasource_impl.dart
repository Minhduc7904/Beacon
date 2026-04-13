import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/local_storage.dart';
import 'onboarding_local_datasource.dart';

class OnboardingLocalDatasourceImpl implements OnboardingLocalDatasource {
  final LocalStorage _storage;

  OnboardingLocalDatasourceImpl(this._storage);

  @override
  Future<bool> hasCompletedOnboarding() async {
    return await _storage.getBool(StorageKeys.hasCompletedOnboarding) ?? false;
  }

  @override
  Future<void> setCompletedOnboarding() {
    return _storage.setBool(StorageKeys.hasCompletedOnboarding, value: true);
  }
}
