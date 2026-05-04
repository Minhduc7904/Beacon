import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
import '../../features/auth/domain/usecase/get_me_usecase.dart';
import '../../features/auth/domain/usecase/update_me_usecase.dart';
import '../../features/auth/domain/usecase/update_my_avatar_usecase.dart';
import '../../features/auth/domain/entities/user_profile.dart';
import '../../features/auth/presentation/controllers/auth_notifier.dart';
import '../../features/auth/presentation/controllers/auth_state.dart';
import '../../features/auth/presentation/controllers/me_profile_notifier.dart';
import '../../features/auth/presentation/controllers/profile_notifier.dart';
import '../../features/auth/presentation/controllers/profile_state.dart';
import '../../features/friend_requests/data/datasources/friend_request_remote_datasource.dart';
import '../../features/friend_requests/data/datasources/friend_request_remote_datasource_impl.dart';
import '../../features/friend_requests/data/repositories/friend_request_repository_impl.dart';
import '../../features/friend_requests/domain/repositories/friend_request_repository.dart';
import '../../features/friend_requests/domain/usecase/accept_friend_request_usecase.dart';
import '../../features/friend_requests/domain/usecase/decline_friend_request_usecase.dart';
import '../../features/friend_requests/domain/usecase/get_received_friend_requests_usecase.dart';
import '../../features/friend_requests/domain/usecase/get_sent_friend_requests_usecase.dart';
import '../../features/friend_requests/domain/usecase/send_friend_request_usecase.dart';
import '../../features/friends/data/datasources/friends_remote_datasource.dart';
import '../../features/friends/data/datasources/friends_remote_datasource_impl.dart';
import '../../features/friends/data/repositories/friends_repository_impl.dart';
import '../../features/friends/domain/repositories/friends_repository.dart';
import '../../features/friends/domain/usecase/delete_friend_usecase.dart';
import '../../features/friends/domain/usecase/get_friend_detail_usecase.dart';
import '../../features/friends/domain/usecase/get_friends_usecase.dart';
import '../../features/friends/domain/usecase/search_friends_usecase.dart';
import '../../features/friends/domain/usecase/update_friend_type_usecase.dart';
import '../../features/home/data/datasources/checkin_remote_datasource.dart';
import '../../features/home/data/datasources/checkin_remote_datasource_impl.dart';
import '../../features/home/data/repositories/checkin_repository_impl.dart';
import '../../features/home/domain/repositories/checkin_repository.dart';
import '../../features/home/domain/usecase/checkin_usecase.dart';
import '../../features/home/domain/usecase/get_today_status_usecase.dart';
import '../../features/home/presentation/controllers/home_checkin_notifier.dart';
import '../../features/home/presentation/controllers/home_checkin_state.dart';
import '../../features/home/presentation/controllers/home_notifier.dart';
import '../../features/home/presentation/controllers/home_state.dart';
import '../../features/message_groups/data/datasources/message_groups_remote_datasource.dart';
import '../../features/message_groups/data/datasources/message_groups_remote_datasource_impl.dart';
import '../../features/message_groups/data/repositories/message_groups_repository_impl.dart';
import '../../features/message_groups/domain/repositories/message_groups_repository.dart';
import '../../features/message_groups/domain/usecase/get_group_messages_usecase.dart';
import '../../features/message_groups/domain/usecase/get_message_group_detail_usecase.dart';
import '../../features/message_groups/domain/usecase/get_message_groups_usecase.dart';
import '../../features/message_groups/domain/usecase/send_group_message_usecase.dart';
import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart';
import '../../features/onboarding/data/datasources/onboarding_local_datasource_impl.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecase/complete_onboarding_usecase.dart';
import '../../features/onboarding/domain/usecase/should_show_onboarding_usecase.dart';
import '../../features/onboarding/presentation/controllers/onboarding_notifier.dart';
import '../../features/onboarding/presentation/controllers/onboarding_state.dart';
import '../../features/post_preview/data/datasources/post_preview_remote_datasource.dart';
import '../../features/post_preview/data/datasources/post_preview_remote_datasource_impl.dart';
import '../../features/post_preview/data/repositories/post_preview_repository_impl.dart';
import '../../features/post_preview/domain/repositories/post_preview_repository.dart';
import '../../features/post_preview/domain/usecase/upload_post_media_usecase.dart';
import '../../features/post_preview/presentation/controllers/post_preview_notifier.dart';
import '../../features/post_preview/presentation/controllers/post_preview_state.dart';
import '../../features/safety/data/datasources/safety_remote_datasource.dart';
import '../../features/safety/data/datasources/safety_remote_datasource_impl.dart';
import '../../features/safety/data/repositories/safety_repository_impl.dart';
import '../../features/safety/domain/repositories/safety_repository.dart';
import '../../features/safety/domain/usecase/get_safety_settings_usecase.dart';
import '../../features/safety/domain/usecase/update_safety_settings_usecase.dart';
import '../../features/safety/presentation/controllers/safety_settings_notifier.dart';
import '../../features/safety/presentation/controllers/safety_settings_state.dart';
import '../messages/app_message.dart';
import '../messages/app_message_notifier.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../preferences/app_preferences.dart';
import '../preferences/app_preferences_impl.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import '../storage/flutter_secure_storage_impl.dart';
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

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return FlutterSecureStorageImpl(ref.watch(flutterSecureStorageProvider));
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
  return AuthLocalDatasourceImpl(ref.watch(secureStorageProvider));
});

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    ref.watch(authLocalDatasourceProvider),
    onAuthFailure: (message) {
      ref.read(appMessageProvider.notifier).addError(message);
    },
  );
});

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasourceImpl(ref.watch(dioClientProvider));
});

final checkinRemoteDatasourceProvider = Provider<CheckinRemoteDatasource>((
  ref,
) {
  return CheckinRemoteDatasourceImpl(ref.watch(dioClientProvider));
});

final postPreviewRemoteDatasourceProvider =
    Provider<PostPreviewRemoteDatasource>((ref) {
      return PostPreviewRemoteDatasourceImpl(ref.watch(dioClientProvider));
    });

final safetyRemoteDatasourceProvider = Provider<SafetyRemoteDatasource>((ref) {
  return SafetyRemoteDatasourceImpl(ref.watch(dioClientProvider));
});

final friendRequestRemoteDatasourceProvider =
    Provider<FriendRequestRemoteDatasource>((ref) {
      return FriendRequestRemoteDatasourceImpl(ref.watch(dioClientProvider));
    });

final friendsRemoteDatasourceProvider = Provider<FriendsRemoteDatasource>((ref) {
  return FriendsRemoteDatasourceImpl(ref.watch(dioClientProvider));
});

final messageGroupsRemoteDatasourceProvider =
    Provider<MessageGroupsRemoteDatasource>((ref) {
      return MessageGroupsRemoteDatasourceImpl(ref.watch(dioClientProvider));
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

final postPreviewRepositoryProvider = Provider<PostPreviewRepository>((ref) {
  return PostPreviewRepositoryImpl(
    remoteDatasource: ref.watch(postPreviewRemoteDatasourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final checkinRepositoryProvider = Provider<CheckinRepository>((ref) {
  return CheckinRepositoryImpl(
    remoteDatasource: ref.watch(checkinRemoteDatasourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final safetyRepositoryProvider = Provider<SafetyRepository>((ref) {
  return SafetyRepositoryImpl(
    remoteDatasource: ref.watch(safetyRemoteDatasourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final friendRequestRepositoryProvider = Provider<FriendRequestRepository>((ref) {
  return FriendRequestRepositoryImpl(
    remoteDatasource: ref.watch(friendRequestRemoteDatasourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final friendsRepositoryProvider = Provider<FriendsRepository>((ref) {
  return FriendsRepositoryImpl(
    remoteDatasource: ref.watch(friendsRemoteDatasourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final messageGroupsRepositoryProvider = Provider<MessageGroupsRepository>((ref) {
  return MessageGroupsRepositoryImpl(
    remoteDatasource: ref.watch(messageGroupsRemoteDatasourceProvider),
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

final getMeUseCaseProvider = Provider<GetMeUseCase>((ref) {
  return GetMeUseCase(ref.watch(authRepositoryProvider));
});

final updateMeUseCaseProvider = Provider<UpdateMeUseCase>((ref) {
  return UpdateMeUseCase(ref.watch(authRepositoryProvider));
});

final updateMyAvatarUseCaseProvider = Provider<UpdateMyAvatarUseCase>((ref) {
  return UpdateMyAvatarUseCase(ref.watch(authRepositoryProvider));
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

final meProfileProvider =
    StateNotifierProvider<MeProfileNotifier, AsyncValue<UserProfile?>>((ref) {
      return MeProfileNotifier(ref.watch(getMeUseCaseProvider));
    });

final profileNotifierProvider =
    StateNotifierProvider.autoDispose<ProfileNotifier, ProfileState>((ref) {
      return ProfileNotifier(
        ref.watch(getMeUseCaseProvider),
        ref.watch(updateMeUseCaseProvider),
        ref.watch(updateMyAvatarUseCaseProvider),
        ref.watch(meProfileProvider.notifier),
        ref.watch(appMessageProvider.notifier),
      );
    });

final postPreviewUploadPostMediaUseCaseProvider =
    Provider<UploadPostMediaUseCase>((ref) {
      return UploadPostMediaUseCase(ref.watch(postPreviewRepositoryProvider));
    });

final checkinUseCaseProvider = Provider<CheckinUseCase>((ref) {
  return CheckinUseCase(ref.watch(checkinRepositoryProvider));
});

final getTodayStatusUseCaseProvider = Provider<GetTodayStatusUseCase>((ref) {
  return GetTodayStatusUseCase(ref.watch(checkinRepositoryProvider));
});

final getSafetySettingsUseCaseProvider = Provider<GetSafetySettingsUseCase>((
  ref,
) {
  return GetSafetySettingsUseCase(ref.watch(safetyRepositoryProvider));
});

final updateSafetySettingsUseCaseProvider =
    Provider<UpdateSafetySettingsUseCase>((ref) {
      return UpdateSafetySettingsUseCase(ref.watch(safetyRepositoryProvider));
    });

final sendFriendRequestUseCaseProvider = Provider<SendFriendRequestUseCase>((
  ref,
) {
  return SendFriendRequestUseCase(ref.watch(friendRequestRepositoryProvider));
});

final acceptFriendRequestUseCaseProvider = Provider<AcceptFriendRequestUseCase>(
  (ref) {
    return AcceptFriendRequestUseCase(
      ref.watch(friendRequestRepositoryProvider),
    );
  },
);

final declineFriendRequestUseCaseProvider =
    Provider<DeclineFriendRequestUseCase>((ref) {
      return DeclineFriendRequestUseCase(
        ref.watch(friendRequestRepositoryProvider),
      );
    });

final getReceivedFriendRequestsUseCaseProvider =
    Provider<GetReceivedFriendRequestsUseCase>((ref) {
      return GetReceivedFriendRequestsUseCase(
        ref.watch(friendRequestRepositoryProvider),
      );
    });

final getSentFriendRequestsUseCaseProvider =
    Provider<GetSentFriendRequestsUseCase>((ref) {
      return GetSentFriendRequestsUseCase(
        ref.watch(friendRequestRepositoryProvider),
      );
    });

final getFriendsUseCaseProvider = Provider<GetFriendsUseCase>((ref) {
  return GetFriendsUseCase(ref.watch(friendsRepositoryProvider));
});

final searchFriendsUseCaseProvider = Provider<SearchFriendsUseCase>((ref) {
  return SearchFriendsUseCase(ref.watch(friendsRepositoryProvider));
});

final getFriendDetailUseCaseProvider = Provider<GetFriendDetailUseCase>((ref) {
  return GetFriendDetailUseCase(ref.watch(friendsRepositoryProvider));
});

final updateFriendTypeUseCaseProvider = Provider<UpdateFriendTypeUseCase>((ref) {
  return UpdateFriendTypeUseCase(ref.watch(friendsRepositoryProvider));
});

final deleteFriendUseCaseProvider = Provider<DeleteFriendUseCase>((ref) {
  return DeleteFriendUseCase(ref.watch(friendsRepositoryProvider));
});

final getMessageGroupsUseCaseProvider = Provider<GetMessageGroupsUseCase>((ref) {
  return GetMessageGroupsUseCase(ref.watch(messageGroupsRepositoryProvider));
});

final sendGroupMessageUseCaseProvider = Provider<SendGroupMessageUseCase>((ref) {
  return SendGroupMessageUseCase(ref.watch(messageGroupsRepositoryProvider));
});

final getGroupMessagesUseCaseProvider = Provider<GetGroupMessagesUseCase>((ref) {
  return GetGroupMessagesUseCase(ref.watch(messageGroupsRepositoryProvider));
});

final getMessageGroupDetailUseCaseProvider =
    Provider<GetMessageGroupDetailUseCase>((ref) {
      return GetMessageGroupDetailUseCase(
        ref.watch(messageGroupsRepositoryProvider),
      );
    });

// ─── Auth Controller ──────────────────────────────────────────────────────────

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(
    ref.watch(loginUseCaseProvider),
    ref.watch(getMeUseCaseProvider),
    ref.watch(registerUseCaseProvider),
    ref.watch(logoutUseCaseProvider),
    ref.watch(meProfileProvider.notifier),
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
  return HomeNotifier();
});

final homeCheckinNotifierProvider =
    StateNotifierProvider.autoDispose<HomeCheckinNotifier, HomeCheckinState>((
      ref,
    ) {
      return HomeCheckinNotifier(
        ref.watch(getTodayStatusUseCaseProvider),
        ref.watch(checkinUseCaseProvider),
        ref.watch(getSafetySettingsUseCaseProvider),
        ref.watch(appMessageProvider.notifier),
      );
    });

final postPreviewNotifierProvider =
    StateNotifierProvider.autoDispose<PostPreviewNotifier, PostPreviewState>((
      ref,
    ) {
      return PostPreviewNotifier(
        ref.watch(postPreviewUploadPostMediaUseCaseProvider),
        ref.watch(appMessageProvider.notifier),
      );
    });

final safetySettingsNotifierProvider =
    StateNotifierProvider.autoDispose<
      SafetySettingsNotifier,
      SafetySettingsState
    >((ref) {
      return SafetySettingsNotifier(
        ref.watch(getSafetySettingsUseCaseProvider),
        ref.watch(updateSafetySettingsUseCaseProvider),
        ref.watch(appMessageProvider.notifier),
      );
    });
