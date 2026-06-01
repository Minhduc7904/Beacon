import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/theme/color/app_colors.dart';
import '../../../feed/presentation/pages/feed_page.dart';
import '../../../message_groups/presentation/pages/message_group_list_page.dart';
import '../../domain/entities/startup_destination.dart';

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
    final result = await ref.read(resolveStartupDestinationUseCaseProvider)();

    if (!mounted) {
      return;
    }

    final destination = result.getOrElse(() => StartupDestination.login);
    _goToDestination(destination);
  }

  void _goToDestination(StartupDestination destination) {
    switch (destination) {
      case StartupDestination.onboarding:
        context.go(AppRoutes.onboarding);
        return;
      case StartupDestination.login:
        context.go(AppRoutes.login);
        return;
      case StartupDestination.home:
        _startAuthenticatedBackgroundTasks();
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
  }

  void _startAuthenticatedBackgroundTasks() {
    unawaited(ref.read(signalRServiceProvider).connect());
    unawaited(_syncCurrentDeviceTokenIfAuthorized());
    unawaited(_preloadProfile());
    unawaited(ref.read(homeCheckinNotifierProvider.notifier).load());
    unawaited(ref.read(feedProvider.notifier).load());
    unawaited(ref.read(friendsPresenceNotifierProvider.notifier).load());
    unawaited(ref.read(messageGroupListProvider.notifier).load());
    unawaited(_preloadUnreadMessageCounts());
    unawaited(_preloadFeedFilterFriends());
  }

  Future<void> _syncCurrentDeviceTokenIfAuthorized() async {
    try {
      await ref
          .read(pushNotificationServiceProvider)
          .syncCurrentDeviceTokenIfAuthorized();
    } catch (_) {
      // Token sync is a background startup task and must not block navigation.
    }
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
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: SizedBox.expand(),
    );
  }
}
