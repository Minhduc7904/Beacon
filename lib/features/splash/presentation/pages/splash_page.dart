import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/image/logo_image.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../../../feed/presentation/pages/feed_page.dart';
import '../../../message_groups/presentation/pages/message_group_list_page.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final shouldShowOnboarding = await ref
        .read(shouldShowOnboardingUseCaseProvider)
        .call();

    if (!mounted) {
      return;
    }

    if (shouldShowOnboarding) {
      context.pushReplacement(AppRoutes.onboarding);
      return;
    }

    final localDatasource = ref.read(authLocalDatasourceProvider);

    final accessToken = await localDatasource.getAccessToken();
    final refreshToken = await localDatasource.getRefreshToken();

    if (!mounted) {
      return;
    }

    final isAuthenticated =
        accessToken != null &&
        accessToken.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }

    if (isAuthenticated) {
      await Future.wait([
        _connectSignalR(),
        _preloadHomeData(),
        ref
            .read(pushNotificationServiceProvider)
            .syncCurrentDeviceTokenIfAuthorized(),
      ]);

      if (!mounted) {
        return;
      }

      final targetPostId = ref
          .read(pushNotificationServiceProvider)
          .consumePendingPostReactionPostId();
      if (targetPostId != null && targetPostId.trim().isNotEmpty) {
        context.go(
          AppRoutes.home,
          extra: <String, dynamic>{'targetPostId': targetPostId.trim()},
        );
        return;
      }

      context.go(AppRoutes.home);
      return;
    }

    if (!mounted) {
      return;
    }

    context.go(AppRoutes.onboarding);
  }

  Future<void> _connectSignalR() async {
    await ref.read(signalRServiceProvider).connect();
  }

  Future<void> _preloadHomeData() async {
    unawaited(ref.read(feedProvider.notifier).load(forceRefresh: true));

    final tasks = <Future<void>>[
      _preloadProfile(),
      ref.read(homeCheckinNotifierProvider.notifier).load(forceRefresh: true),
      ref
          .read(friendsPresenceNotifierProvider.notifier)
          .load(forceRefresh: true),
      ref.read(messageGroupListProvider.notifier).load(forceRefresh: true),
      _preloadUnreadMessageCounts(),
      _preloadFeedFilterFriends(),
    ];

    await Future.wait(tasks);
  }

  Future<void> _preloadProfile() async {
    if (ref.read(meProfileProvider).valueOrNull != null) {
      return;
    }

    await ref.read(meProfileProvider.notifier).fetchProfile();
  }

  Future<void> _preloadUnreadMessageCounts() async {
    final result = await ref
        .read(getMessageGroupsUseCaseProvider)
        .call(limit: 100);

    result.fold((_) {}, (page) {
      ref.read(homeUnreadMessageCountsProvider.notifier).state = {
        for (final group in page.items) group.groupId: group.unreadCount,
      };
    });
  }

  Future<void> _preloadFeedFilterFriends() async {
    try {
      await ref.read(homeFeedFilterFriendsProvider.future);
    } catch (_) {
      // The dropdown already renders its own error state.
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.primary,
      body: SafeArea(
        child: AppScreenLayout(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogoImage(
                  width: 359,
                  height: 380,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
