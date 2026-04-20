import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_local_datasource_impl.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecase/login_usecase.dart';
import '../../features/auth/domain/usecase/logout_usecase.dart';
import '../../features/auth/domain/usecase/register_usecase.dart';
import '../../features/auth/domain/usecase/check_email_availability_usecase.dart';
import '../../features/auth/domain/usecase/check_phone_availability_usecase.dart';
import '../../features/auth/presentation/controllers/auth_notifier.dart';
import '../../features/auth/presentation/controllers/auth_state.dart';
import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/datasources/home_remote_datasource_impl.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecase/upload_post_media_usecase.dart';
import '../../features/home/presentation/controllers/home_notifier.dart';
import '../../features/home/presentation/controllers/home_state.dart';
import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart';
import '../../features/onboarding/data/datasources/onboarding_local_datasource_impl.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecase/complete_onboarding_usecase.dart';
import '../../features/onboarding/domain/usecase/should_show_onboarding_usecase.dart';
import '../../features/onboarding/presentation/controllers/onboarding_notifier.dart';
import '../../features/onboarding/presentation/controllers/onboarding_state.dart';
import '../messages/app_message.dart';
import '../messages/app_message_notifier.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../preferences/app_preferences.dart';
import '../preferences/app_preferences_impl.dart';
import '../storage/local_storage.dart';
import '../storage/shared_prefs_storage.dart';

// ─── SharedPreferences ────────────────────────────────────────────────────────

// Overridden in main() with the resolved SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main()',
  );
});

// ─── Storage ──────────────────────────────────────────────────────────────────

final localStorageProvider = Provider<LocalStorage>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SharedPrefsStorage(prefs);
});

final appPreferencesProvider = Provider<AppPreferences>((ref) {
  return AppPreferencesImpl(ref.watch(localStorageProvider));
});

final isDarkModeProvider = FutureProvider<bool>((ref) async {
  return ref.watch(appPreferencesProvider).isDarkMode();
});

// ─── Network ──────────────────────────────────────────────────────────────────

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(ref.watch(connectivityProvider));
});

// ─── Auth Datasources ─────────────────────────────────────────────────────────

final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  return AuthLocalDatasourceImpl(ref.watch(localStorageProvider));
});

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(ref.watch(authLocalDatasourceProvider));
});

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasourceImpl(ref.watch(dioClientProvider));
});

final homeRemoteDatasourceProvider = Provider<HomeRemoteDatasource>((ref) {
  return HomeRemoteDatasourceImpl(ref.watch(dioClientProvider));
});

// ─── Onboarding Datasource ───────────────────────────────────────────────────

final onboardingLocalDatasourceProvider = Provider<OnboardingLocalDatasource>((
  ref,
) {
  return OnboardingLocalDatasourceImpl(ref.watch(localStorageProvider));
});

// ─── Auth Repository ──────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDatasource: ref.watch(authRemoteDatasourceProvider),
    localDatasource: ref.watch(authLocalDatasourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    remoteDatasource: ref.watch(homeRemoteDatasourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepositoryImpl(ref.watch(onboardingLocalDatasourceProvider));
});

// ─── Global Messages ─────────────────────────────────────────────────────────

final appMessageProvider =
    StateNotifierProvider<AppMessageNotifier, List<AppMessage>>((ref) {
      return AppMessageNotifier();
    });

// ─── Dev Tools ───────────────────────────────────────────────────────────────

final devShowLayoutGridProvider = StateProvider<bool>((ref) {
  return false;
});

// ─── Auth UseCases ────────────────────────────────────────────────────────────

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

final checkEmailAvailabilityUseCaseProvider =
    Provider<CheckEmailAvailabilityUseCase>((ref) {
      return CheckEmailAvailabilityUseCase(ref.watch(authRepositoryProvider));
    });

final checkPhoneAvailabilityUseCaseProvider =
    Provider<CheckPhoneAvailabilityUseCase>((ref) {
      return CheckPhoneAvailabilityUseCase(ref.watch(authRepositoryProvider));
    });

final shouldShowOnboardingUseCaseProvider =
    Provider<ShouldShowOnboardingUseCase>((ref) {
      return ShouldShowOnboardingUseCase(
        ref.watch(onboardingRepositoryProvider),
      );
    });

final completeOnboardingUseCaseProvider = Provider<CompleteOnboardingUseCase>((
  ref,
) {
  return CompleteOnboardingUseCase(ref.watch(onboardingRepositoryProvider));
});

final uploadPostMediaUseCaseProvider = Provider<UploadPostMediaUseCase>((ref) {
  return UploadPostMediaUseCase(ref.watch(homeRepositoryProvider));
});

// ─── Auth Controller ──────────────────────────────────────────────────────────

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(
    ref.watch(loginUseCaseProvider),
    ref.watch(registerUseCaseProvider),
    ref.watch(logoutUseCaseProvider),
    ref.watch(appMessageProvider.notifier),
  );
});

final onboardingNotifierProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
      return OnboardingNotifier(
        ref.watch(completeOnboardingUseCaseProvider),
        ref.watch(appMessageProvider.notifier),
      );
    });

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((
  ref,
) {
  return HomeNotifier(
    ref.watch(uploadPostMediaUseCaseProvider),
    ref.watch(appMessageProvider.notifier),
  );
});
