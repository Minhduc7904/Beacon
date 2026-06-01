import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_local_datasource_impl.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource_impl.dart';
import '../../features/auth/data/datasources/user_profile_local_datasource.dart';
import '../../features/auth/data/datasources/user_profile_local_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecase/login_usecase.dart';
import '../../features/auth/domain/usecase/logout_usecase.dart';
import '../../features/auth/domain/usecase/register_usecase.dart';
import '../../features/auth/domain/usecase/check_email_availability_usecase.dart';
import '../../features/auth/domain/usecase/check_phone_availability_usecase.dart';
import '../../features/auth/domain/usecase/delete_fcm_token_usecase.dart';
import '../../features/auth/domain/usecase/get_me_usecase.dart';
import '../../features/auth/domain/usecase/update_me_usecase.dart';
import '../../features/auth/domain/usecase/update_my_avatar_usecase.dart';
import '../../features/auth/domain/usecase/update_fcm_token_usecase.dart';
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
import '../../features/friends/data/services/friends_realtime_service_impl.dart';
import '../../features/friends/domain/repositories/friends_repository.dart';
import '../../features/friends/domain/services/friends_realtime_service.dart';
import '../../features/friends/domain/usecase/delete_friend_usecase.dart';
import '../../features/friends/domain/usecase/get_friend_detail_usecase.dart';
import '../../features/friends/domain/usecase/get_friends_usecase.dart';
import '../../features/friends/domain/usecase/get_friends_presence_usecase.dart';
import '../../features/friends/domain/usecase/search_friends_usecase.dart';
import '../../features/friends/domain/usecase/subscribe_friend_presence_realtime_usecase.dart';
import '../../features/friends/domain/usecase/update_friend_type_usecase.dart';
import '../../features/friends/domain/entities/friend_profile.dart';
import '../../features/friends/presentation/controllers/friends_presence_notifier.dart';
import '../../features/friends/presentation/controllers/friends_presence_state.dart';
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
import '../../features/message_groups/data/services/message_group_realtime_service_impl.dart';
import '../../features/message_groups/domain/repositories/message_groups_repository.dart';
import '../../features/message_groups/domain/services/message_group_realtime_service.dart';
import '../../features/message_groups/domain/usecase/add_group_members_usecase.dart';
import '../../features/message_groups/domain/usecase/create_message_group_usecase.dart';
import '../../features/message_groups/domain/usecase/delete_message_group_usecase.dart';
import '../../features/message_groups/domain/usecase/get_group_messages_usecase.dart';
import '../../features/message_groups/domain/usecase/join_message_group_realtime_usecase.dart';
import '../../features/message_groups/domain/usecase/leave_message_group_usecase.dart';
import '../../features/message_groups/domain/usecase/leave_message_group_realtime_usecase.dart';
import '../../features/message_groups/domain/usecase/mark_message_group_seen_usecase.dart';
import '../../features/message_groups/domain/usecase/approve_message_group_member_usecase.dart';
import '../../features/message_groups/domain/usecase/deny_message_group_member_usecase.dart';
import '../../features/message_groups/domain/usecase/remove_message_group_member_usecase.dart';
import '../../features/message_groups/domain/usecase/subscribe_new_messages_realtime_usecase.dart';
import '../../features/message_groups/domain/usecase/subscribe_message_group_seen_realtime_usecase.dart';
import '../../features/message_groups/domain/usecase/subscribe_message_seen_status_realtime_usecase.dart';
import '../../features/message_groups/domain/usecase/subscribe_typing_status_realtime_usecase.dart';
import '../../features/message_groups/domain/usecase/subscribe_unread_message_count_realtime_usecase.dart';
import '../../features/message_groups/domain/usecase/get_message_group_detail_usecase.dart';
import '../../features/message_groups/domain/usecase/get_message_groups_usecase.dart';
import '../../features/message_groups/domain/usecase/search_group_messages_usecase.dart';
import '../../features/message_groups/domain/usecase/send_group_message_usecase.dart';
import '../../features/message_groups/domain/usecase/send_typing_status_realtime_usecase.dart';
import '../../features/message_groups/domain/usecase/update_message_group_avatar_usecase.dart';
import '../../features/message_groups/domain/usecase/update_message_group_member_custom_name_usecase.dart';
import '../../features/message_groups/domain/usecase/update_message_group_member_role_usecase.dart';
import '../../features/message_groups/domain/usecase/update_message_group_name_usecase.dart';
import '../../features/message_groups/domain/usecase/update_message_group_mute_usecase.dart';
import '../../features/message_groups/domain/usecase/update_message_group_require_approval_usecase.dart';
import '../../features/message_groups/presentation/controllers/add_group_members_notifier.dart';
import '../../features/message_groups/presentation/controllers/add_group_members_state.dart';
import '../../features/message_groups/presentation/controllers/create_message_group_sheet_notifier.dart';
import '../../features/message_groups/presentation/controllers/create_message_group_sheet_state.dart';
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
import '../../features/post_reports/data/datasources/post_reports_remote_datasource.dart';
import '../../features/post_reports/data/datasources/post_reports_remote_datasource_impl.dart';
import '../../features/post_reports/data/repositories/post_reports_repository_impl.dart';
import '../../features/post_reports/domain/repositories/post_reports_repository.dart';
import '../../features/post_reports/domain/usecase/report_post_usecase.dart';
import '../../features/post_reports/presentation/controllers/post_report_notifier.dart';
import '../../features/post_reports/presentation/controllers/post_report_state.dart';
import '../../features/posts/data/datasources/posts_local_datasource.dart';
import '../../features/posts/data/datasources/posts_local_datasource_impl.dart';
import '../../features/posts/data/datasources/posts_remote_datasource.dart';
import '../../features/posts/data/datasources/posts_remote_datasource_impl.dart';
import '../../features/posts/data/repositories/posts_repository_impl.dart';
import '../../features/posts/data/services/posts_realtime_service_impl.dart';
import '../../features/posts/domain/repositories/posts_repository.dart';
import '../../features/posts/domain/services/posts_realtime_service.dart';
import '../../features/posts/domain/usecase/create_post_usecase.dart';
import '../../features/posts/domain/usecase/delete_post_usecase.dart';
import '../../features/posts/domain/usecase/delete_post_reaction_usecase.dart';
import '../../features/posts/domain/usecase/get_feed_posts_usecase.dart';
import '../../features/posts/domain/usecase/get_friend_posts_usecase.dart';
import '../../features/posts/domain/usecase/get_my_posts_usecase.dart';
import '../../features/posts/domain/usecase/get_post_reactions_usecase.dart';
import '../../features/posts/domain/usecase/set_post_reaction_usecase.dart';
import '../../features/posts/domain/usecase/set_post_reaction_icon_usecase.dart';
import '../../features/posts/domain/usecase/subscribe_new_posts_realtime_usecase.dart';
import '../../features/posts/domain/usecase/update_post_usecase.dart';
import '../../features/safety/data/datasources/safety_local_datasource.dart';
import '../../features/safety/data/datasources/safety_local_datasource_impl.dart';
import '../../features/safety/data/datasources/safety_remote_datasource.dart';
import '../../features/safety/data/datasources/safety_remote_datasource_impl.dart';
import '../../features/safety/data/repositories/safety_repository_impl.dart';
import '../../features/safety/domain/repositories/safety_repository.dart';
import '../../features/safety/domain/usecase/get_safety_settings_usecase.dart';
import '../../features/safety/domain/usecase/get_monthly_checkins_usecase.dart';
import '../../features/safety/domain/usecase/update_safety_settings_usecase.dart';
import '../../features/safety/presentation/controllers/safety_mood_calendar_notifier.dart';
import '../../features/safety/presentation/controllers/safety_mood_calendar_state.dart';
import '../../features/safety/presentation/controllers/safety_settings_notifier.dart';
import '../../features/safety/presentation/controllers/safety_settings_state.dart';
import '../cache/current_user_cache_scope.dart';
import '../cache/current_user_cache_scope_impl.dart';
import '../cache/media_file_cache_service.dart';
import '../database/app_database.dart';
import '../observers/app_provider_observer.dart';
import '../messages/app_message.dart';
import '../messages/app_message_notifier.dart';
import '../network/dio_client.dart';
import '../notifications/push_notification_service.dart';
import '../network/network_info.dart';
import '../preferences/app_preferences.dart';
import '../preferences/app_preferences_impl.dart';
import '../realtime/signalr_service.dart';
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

final currentUserCacheScopeProvider = Provider<CurrentUserCacheScope>((ref) {
  return CurrentUserCacheScopeImpl(ref.watch(secureStorageProvider));
});

final appPreferencesProvider = Provider<AppPreferences>((ref) {
  return AppPreferencesImpl(ref.watch(localStorageProvider));
});

final mediaFileCacheServiceProvider = Provider<MediaFileCacheService>((ref) {
  return MediaFileCacheService(dio: ref.watch(dioClientProvider).dio);
});

final isDarkModeProvider = FutureProvider<bool>((ref) async {
  return ref.watch(appPreferencesProvider).isDarkMode();
});

// ─── Database ────────────────────────────────────────────────────────────────

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('appDatabaseProvider must be overridden in main()');
});

// ─── Push Notifications ─────────────────────────────────────────────────────

final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

final flutterLocalNotificationsProvider =
    Provider<FlutterLocalNotificationsPlugin>((ref) {
      return FlutterLocalNotificationsPlugin();
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

final userProfileLocalDatasourceProvider =
    Provider<UserProfileLocalDatasource>((ref) {
      return UserProfileLocalDatasourceImpl(ref.watch(appDatabaseProvider));
    });

// ─── Realtime ───────────────────────────────────────────────────────────────

final signalRServiceProvider = Provider<SignalRService>((ref) {
  return SignalRService(ref.watch(authLocalDatasourceProvider));
});

final messageGroupRealtimeServiceProvider =
    Provider<MessageGroupRealtimeService>((ref) {
      return MessageGroupRealtimeServiceImpl(ref.watch(signalRServiceProvider));
    });

final friendsRealtimeServiceProvider = Provider<FriendsRealtimeService>((ref) {
  return FriendsRealtimeServiceImpl(ref.watch(signalRServiceProvider));
});

final postsRealtimeServiceProvider = Provider<PostsRealtimeService>((ref) {
  return PostsRealtimeServiceImpl(ref.watch(signalRServiceProvider));
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

final postsRemoteDatasourceProvider = Provider<PostsRemoteDatasource>((ref) {
  return PostsRemoteDatasourceImpl(ref.watch(dioClientProvider));
});

final postsLocalDatasourceProvider = Provider<PostsLocalDatasource>((ref) {
  return PostsLocalDatasourceImpl(ref.watch(appDatabaseProvider));
});

final postReportsRemoteDatasourceProvider =
    Provider<PostReportsRemoteDatasource>((ref) {
      return PostReportsRemoteDatasourceImpl(ref.watch(dioClientProvider));
    });

final safetyRemoteDatasourceProvider = Provider<SafetyRemoteDatasource>((ref) {
  return SafetyRemoteDatasourceImpl(ref.watch(dioClientProvider));
});

final safetyLocalDatasourceProvider = Provider<SafetyLocalDatasource>((ref) {
  return SafetyLocalDatasourceImpl(ref.watch(appDatabaseProvider));
});

final friendRequestRemoteDatasourceProvider =
    Provider<FriendRequestRemoteDatasource>((ref) {
      return FriendRequestRemoteDatasourceImpl(ref.watch(dioClientProvider));
    });

final friendsRemoteDatasourceProvider = Provider<FriendsRemoteDatasource>((
  ref,
) {
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
    userProfileLocalDatasource: ref.watch(userProfileLocalDatasourceProvider),
    currentUserCacheScope: ref.watch(currentUserCacheScopeProvider),
    appDatabase: ref.watch(appDatabaseProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final postPreviewRepositoryProvider = Provider<PostPreviewRepository>((ref) {
  return PostPreviewRepositoryImpl(
    remoteDatasource: ref.watch(postPreviewRemoteDatasourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final postsRepositoryProvider = Provider<PostsRepository>((ref) {
  return PostsRepositoryImpl(
    remoteDatasource: ref.watch(postsRemoteDatasourceProvider),
    localDatasource: ref.watch(postsLocalDatasourceProvider),
    currentUserCacheScope: ref.watch(currentUserCacheScopeProvider),
    mediaFileCacheService: ref.watch(mediaFileCacheServiceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final postReportsRepositoryProvider = Provider<PostReportsRepository>((ref) {
  return PostReportsRepositoryImpl(
    remoteDatasource: ref.watch(postReportsRemoteDatasourceProvider),
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
    localDatasource: ref.watch(safetyLocalDatasourceProvider),
    currentUserCacheScope: ref.watch(currentUserCacheScopeProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final friendRequestRepositoryProvider = Provider<FriendRequestRepository>((
  ref,
) {
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

final messageGroupsRepositoryProvider = Provider<MessageGroupsRepository>((
  ref,
) {
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

final updateFcmTokenUseCaseProvider = Provider<UpdateFcmTokenUseCase>((ref) {
  return UpdateFcmTokenUseCase(ref.watch(authRepositoryProvider));
});

final deleteFcmTokenUseCaseProvider = Provider<DeleteFcmTokenUseCase>((ref) {
  return DeleteFcmTokenUseCase(ref.watch(authRepositoryProvider));
});

final pushNotificationServiceProvider = Provider<PushNotificationService>((
  ref,
) {
  final service = PushNotificationService(
    messaging: ref.watch(firebaseMessagingProvider),
    localNotifications: ref.watch(flutterLocalNotificationsProvider),
    updateFcmTokenUseCase: ref.watch(updateFcmTokenUseCaseProvider),
    deleteFcmTokenUseCase: ref.watch(deleteFcmTokenUseCaseProvider),
  );
  ref.onDispose(() {
    unawaited(service.dispose());
  });
  return service;
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

final createPostUseCaseProvider = Provider<CreatePostUseCase>((ref) {
  return CreatePostUseCase(ref.watch(postsRepositoryProvider));
});

final updatePostUseCaseProvider = Provider<UpdatePostUseCase>((ref) {
  return UpdatePostUseCase(ref.watch(postsRepositoryProvider));
});

final deletePostUseCaseProvider = Provider<DeletePostUseCase>((ref) {
  return DeletePostUseCase(ref.watch(postsRepositoryProvider));
});

final getFeedPostsUseCaseProvider = Provider<GetFeedPostsUseCase>((ref) {
  return GetFeedPostsUseCase(ref.watch(postsRepositoryProvider));
});

final getFriendPostsUseCaseProvider = Provider<GetFriendPostsUseCase>((ref) {
  return GetFriendPostsUseCase(ref.watch(postsRepositoryProvider));
});

final getMyPostsUseCaseProvider = Provider<GetMyPostsUseCase>((ref) {
  return GetMyPostsUseCase(ref.watch(postsRepositoryProvider));
});

final setPostReactionUseCaseProvider = Provider<SetPostReactionUseCase>((ref) {
  return SetPostReactionUseCase(ref.watch(postsRepositoryProvider));
});

final setPostReactionIconUseCaseProvider = Provider<SetPostReactionIconUseCase>(
  (ref) {
    return SetPostReactionIconUseCase(ref.watch(postsRepositoryProvider));
  },
);

final deletePostReactionUseCaseProvider = Provider<DeletePostReactionUseCase>((
  ref,
) {
  return DeletePostReactionUseCase(ref.watch(postsRepositoryProvider));
});

final getPostReactionsUseCaseProvider = Provider<GetPostReactionsUseCase>((
  ref,
) {
  return GetPostReactionsUseCase(ref.watch(postsRepositoryProvider));
});

final reportPostUseCaseProvider = Provider<ReportPostUseCase>((ref) {
  return ReportPostUseCase(ref.watch(postReportsRepositoryProvider));
});

final subscribeNewPostsRealtimeUseCaseProvider =
    Provider<SubscribeNewPostsRealtimeUseCase>((ref) {
      return SubscribeNewPostsRealtimeUseCase(
        ref.watch(postsRealtimeServiceProvider),
      );
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

final getMonthlyCheckinsUseCaseProvider = Provider<GetMonthlyCheckinsUseCase>((
  ref,
) {
  return GetMonthlyCheckinsUseCase(ref.watch(safetyRepositoryProvider));
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

final getFriendsPresenceUseCaseProvider = Provider<GetFriendsPresenceUseCase>((
  ref,
) {
  return GetFriendsPresenceUseCase(ref.watch(friendsRepositoryProvider));
});

final searchFriendsUseCaseProvider = Provider<SearchFriendsUseCase>((ref) {
  return SearchFriendsUseCase(ref.watch(friendsRepositoryProvider));
});

final getFriendDetailUseCaseProvider = Provider<GetFriendDetailUseCase>((ref) {
  return GetFriendDetailUseCase(ref.watch(friendsRepositoryProvider));
});

final updateFriendTypeUseCaseProvider = Provider<UpdateFriendTypeUseCase>((
  ref,
) {
  return UpdateFriendTypeUseCase(ref.watch(friendsRepositoryProvider));
});

final deleteFriendUseCaseProvider = Provider<DeleteFriendUseCase>((ref) {
  return DeleteFriendUseCase(ref.watch(friendsRepositoryProvider));
});

final subscribeFriendPresenceRealtimeUseCaseProvider =
    Provider<SubscribeFriendPresenceRealtimeUseCase>((ref) {
      return SubscribeFriendPresenceRealtimeUseCase(
        ref.watch(friendsRealtimeServiceProvider),
      );
    });

final getMessageGroupsUseCaseProvider = Provider<GetMessageGroupsUseCase>((
  ref,
) {
  return GetMessageGroupsUseCase(ref.watch(messageGroupsRepositoryProvider));
});

final createMessageGroupUseCaseProvider = Provider<CreateMessageGroupUseCase>((
  ref,
) {
  return CreateMessageGroupUseCase(ref.watch(messageGroupsRepositoryProvider));
});

final deleteMessageGroupUseCaseProvider = Provider<DeleteMessageGroupUseCase>((
  ref,
) {
  return DeleteMessageGroupUseCase(ref.watch(messageGroupsRepositoryProvider));
});

final leaveMessageGroupUseCaseProvider = Provider<LeaveMessageGroupUseCase>((
  ref,
) {
  return LeaveMessageGroupUseCase(ref.watch(messageGroupsRepositoryProvider));
});

final addGroupMembersUseCaseProvider = Provider<AddGroupMembersUseCase>((ref) {
  return AddGroupMembersUseCase(ref.watch(messageGroupsRepositoryProvider));
});

final sendGroupMessageUseCaseProvider = Provider<SendGroupMessageUseCase>((
  ref,
) {
  return SendGroupMessageUseCase(ref.watch(messageGroupsRepositoryProvider));
});

final sendPostMessageUseCaseProvider = Provider<SendPostMessageUseCase>((ref) {
  return SendPostMessageUseCase(ref.watch(messageGroupsRepositoryProvider));
});

final getGroupMessagesUseCaseProvider = Provider<GetGroupMessagesUseCase>((
  ref,
) {
  return GetGroupMessagesUseCase(ref.watch(messageGroupsRepositoryProvider));
});

final searchGroupMessagesUseCaseProvider = Provider<SearchGroupMessagesUseCase>(
  (ref) {
    return SearchGroupMessagesUseCase(
      ref.watch(messageGroupsRepositoryProvider),
    );
  },
);

final getMessageGroupDetailUseCaseProvider =
    Provider<GetMessageGroupDetailUseCase>((ref) {
      return GetMessageGroupDetailUseCase(
        ref.watch(messageGroupsRepositoryProvider),
      );
    });

final updateMessageGroupRequireApprovalUseCaseProvider =
    Provider<UpdateMessageGroupRequireApprovalUseCase>((ref) {
      return UpdateMessageGroupRequireApprovalUseCase(
        ref.watch(messageGroupsRepositoryProvider),
      );
    });

final updateMessageGroupNameUseCaseProvider =
    Provider<UpdateMessageGroupNameUseCase>((ref) {
      return UpdateMessageGroupNameUseCase(
        ref.watch(messageGroupsRepositoryProvider),
      );
    });

final updateMessageGroupAvatarUseCaseProvider =
    Provider<UpdateMessageGroupAvatarUseCase>((ref) {
      return UpdateMessageGroupAvatarUseCase(
        ref.watch(messageGroupsRepositoryProvider),
      );
    });

final updateMessageGroupMemberCustomNameUseCaseProvider =
    Provider<UpdateMessageGroupMemberCustomNameUseCase>((ref) {
      return UpdateMessageGroupMemberCustomNameUseCase(
        ref.watch(messageGroupsRepositoryProvider),
      );
    });

final updateMessageGroupMemberRoleUseCaseProvider =
    Provider<UpdateMessageGroupMemberRoleUseCase>((ref) {
      return UpdateMessageGroupMemberRoleUseCase(
        ref.watch(messageGroupsRepositoryProvider),
      );
    });

final approveMessageGroupMemberUseCaseProvider =
    Provider<ApproveMessageGroupMemberUseCase>((ref) {
      return ApproveMessageGroupMemberUseCase(
        ref.watch(messageGroupsRepositoryProvider),
      );
    });

final denyMessageGroupMemberUseCaseProvider =
    Provider<DenyMessageGroupMemberUseCase>((ref) {
      return DenyMessageGroupMemberUseCase(
        ref.watch(messageGroupsRepositoryProvider),
      );
    });

final updateMessageGroupMuteUseCaseProvider =
    Provider<UpdateMessageGroupMuteUseCase>((ref) {
      return UpdateMessageGroupMuteUseCase(
        ref.watch(messageGroupsRepositoryProvider),
      );
    });

final removeMessageGroupMemberUseCaseProvider =
    Provider<RemoveMessageGroupMemberUseCase>((ref) {
      return RemoveMessageGroupMemberUseCase(
        ref.watch(messageGroupsRepositoryProvider),
      );
    });

final joinMessageGroupRealtimeUseCaseProvider =
    Provider<JoinMessageGroupRealtimeUseCase>((ref) {
      return JoinMessageGroupRealtimeUseCase(
        ref.watch(messageGroupRealtimeServiceProvider),
      );
    });

final leaveMessageGroupRealtimeUseCaseProvider =
    Provider<LeaveMessageGroupRealtimeUseCase>((ref) {
      return LeaveMessageGroupRealtimeUseCase(
        ref.watch(messageGroupRealtimeServiceProvider),
      );
    });

final markMessageGroupSeenUseCaseProvider =
    Provider<MarkMessageGroupSeenUseCase>((ref) {
      return MarkMessageGroupSeenUseCase(
        ref.watch(messageGroupsRepositoryProvider),
      );
    });

final subscribeNewMessagesRealtimeUseCaseProvider =
    Provider<SubscribeNewMessagesRealtimeUseCase>((ref) {
      return SubscribeNewMessagesRealtimeUseCase(
        ref.watch(messageGroupRealtimeServiceProvider),
      );
    });

final subscribeTypingStatusRealtimeUseCaseProvider =
    Provider<SubscribeTypingStatusRealtimeUseCase>((ref) {
      return SubscribeTypingStatusRealtimeUseCase(
        ref.watch(messageGroupRealtimeServiceProvider),
      );
    });

final subscribeUnreadMessageCountRealtimeUseCaseProvider =
    Provider<SubscribeUnreadMessageCountRealtimeUseCase>((ref) {
      return SubscribeUnreadMessageCountRealtimeUseCase(
        ref.watch(messageGroupRealtimeServiceProvider),
      );
    });

final subscribeMessageGroupSeenRealtimeUseCaseProvider =
    Provider<SubscribeMessageGroupSeenRealtimeUseCase>((ref) {
      return SubscribeMessageGroupSeenRealtimeUseCase(
        ref.watch(messageGroupRealtimeServiceProvider),
      );
    });

final subscribeMessageSeenStatusRealtimeUseCaseProvider =
    Provider<SubscribeMessageSeenStatusRealtimeUseCase>((ref) {
      return SubscribeMessageSeenStatusRealtimeUseCase(
        ref.watch(messageGroupRealtimeServiceProvider),
      );
    });

final sendTypingStatusRealtimeUseCaseProvider =
    Provider<SendTypingStatusRealtimeUseCase>((ref) {
      return SendTypingStatusRealtimeUseCase(
        ref.watch(messageGroupRealtimeServiceProvider),
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
    ref.watch(signalRServiceProvider),
    ref.watch(pushNotificationServiceProvider),
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
  return HomeNotifier(ref.watch(appMessageProvider.notifier));
});

final homeCheckinNotifierProvider =
    StateNotifierProvider<HomeCheckinNotifier, HomeCheckinState>((ref) {
      return HomeCheckinNotifier(
        ref.watch(getTodayStatusUseCaseProvider),
        ref.watch(checkinUseCaseProvider),
        ref.watch(getSafetySettingsUseCaseProvider),
        ref.watch(appMessageProvider.notifier),
      );
    }, name: 'homeCheckinNotifierProvider ${ProviderLogFlags.noLog}');

final friendsPresenceNotifierProvider =
    StateNotifierProvider<FriendsPresenceNotifier, FriendsPresenceState>((ref) {
      return FriendsPresenceNotifier(
        ref.watch(getFriendsPresenceUseCaseProvider),
        ref.watch(appMessageProvider.notifier),
      );
    });

final createMessageGroupSheetProvider =
    StateNotifierProvider.autoDispose<
      CreateMessageGroupSheetNotifier,
      CreateMessageGroupSheetState
    >((ref) {
      return CreateMessageGroupSheetNotifier(
        ref.watch(getFriendsUseCaseProvider),
        ref.watch(appMessageProvider.notifier),
      );
    });

final addGroupMembersProvider =
    StateNotifierProvider.autoDispose<
      AddGroupMembersNotifier,
      AddGroupMembersState
    >((ref) {
      return AddGroupMembersNotifier(
        ref.watch(getFriendsUseCaseProvider),
        ref.watch(addGroupMembersUseCaseProvider),
        ref.watch(appMessageProvider.notifier),
      );
    });

final homeUnreadMessageCountsProvider = StateProvider<Map<String, int>>(
  (ref) => const <String, int>{},
);

final homeFeedFilterFriendsProvider = FutureProvider<List<FriendProfile>>((
  ref,
) async {
  final result = await ref.watch(getFriendsUseCaseProvider).call(limit: 100);
  return result.fold((failure) => throw failure, (page) => page.items);
});

final postPreviewNotifierProvider =
    StateNotifierProvider.autoDispose<PostPreviewNotifier, PostPreviewState>((
      ref,
    ) {
      return PostPreviewNotifier(
        ref.watch(postPreviewUploadPostMediaUseCaseProvider),
        ref.watch(createPostUseCaseProvider),
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

final safetyMoodCalendarNotifierProvider =
    StateNotifierProvider.autoDispose<
      SafetyMoodCalendarNotifier,
      SafetyMoodCalendarState
    >((ref) {
      return SafetyMoodCalendarNotifier(
        ref.watch(getMonthlyCheckinsUseCaseProvider),
        ref.watch(appMessageProvider.notifier),
      );
    });

final postReportNotifierProvider =
    StateNotifierProvider.autoDispose<PostReportNotifier, PostReportState>((
      ref,
    ) {
      return PostReportNotifier(
        ref.watch(reportPostUseCaseProvider),
        ref.watch(appMessageProvider.notifier),
      );
    });
