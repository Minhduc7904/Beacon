import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../auth/presentation/pages/profile/profile_page.dart';
import '../../../message_groups/presentation/pages/message_group_list_page.dart';
import '../widgets/home/home_center_scaffold.dart';
import '../widgets/home/home_keep_alive_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
    this.autoCaptureOnOpen = false,
    this.targetPostId,
  });

  final bool autoCaptureOnOpen;
  final String? targetPostId;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  static const int _profilePageIndex = 0;
  static const int _homePageIndex = 1;
  static const int _messagePageIndex = 2;

  late final PageController _horizontalController;
  AppLifecycleState? _lastLifecycleState;
  void Function()? _unsubscribeUnreadMessageCount;
  void Function()? _unsubscribeFriendPresence;

  @override
  void initState() {
    super.initState();
    _horizontalController = PageController(initialPage: _homePageIndex);
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      unawaited(_subscribeUnreadMessageCount());
      unawaited(_subscribeFriendPresence());
    });
  }

  @override
  void dispose() {
    _unsubscribeUnreadMessageCount?.call();
    _unsubscribeUnreadMessageCount = null;
    _unsubscribeFriendPresence?.call();
    _unsubscribeFriendPresence = null;
    WidgetsBinding.instance.removeObserver(this);
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_lastLifecycleState == AppLifecycleState.paused &&
        state == AppLifecycleState.resumed &&
        mounted) {
      ref.read(homeCheckinNotifierProvider.notifier).load(forceRefresh: true);
      ref
          .read(friendsPresenceNotifierProvider.notifier)
          .load(forceRefresh: true);
      unawaited(_seedUnreadMessageCount());
    }
    _lastLifecycleState = state;
  }

  Future<void> _animateToPage(int page) {
    if (page == _homePageIndex) {
      unawaited(_seedUnreadMessageCount());
    }
    return _horizontalController.animateToPage(
      page,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _seedUnreadMessageCount() async {
    final result = await ref
        .read(getMessageGroupsUseCaseProvider)
        .call(limit: 100);
    if (!mounted) {
      return;
    }
    result.fold(
      (failure) {
        ref
            .read(appMessageProvider.notifier)
            .addWarning(
              'Không thể tải số tin nhắn chưa đọc: ${failure.message}',
            );
      },
      (page) {
        ref.read(homeUnreadMessageCountsProvider.notifier).state = {
          for (final group in page.items) group.groupId: group.unreadCount,
        };
      },
    );
  }

  Future<void> _subscribeUnreadMessageCount() async {
    await ref
        .read(subscribeUnreadMessageCountRealtimeUseCaseProvider)
        .call(
          onUnreadCount: (groupId, unreadCount) {
            if (!mounted) {
              return;
            }
            final current = ref.read(homeUnreadMessageCountsProvider);
            ref.read(homeUnreadMessageCountsProvider.notifier).state = {
              ...current,
              groupId: unreadCount,
            };
          },
        );
    _unsubscribeUnreadMessageCount = ref
        .read(subscribeUnreadMessageCountRealtimeUseCaseProvider)
        .unsubscribe();
  }

  Future<void> _subscribeFriendPresence() async {
    await ref
        .read(subscribeFriendPresenceRealtimeUseCaseProvider)
        .call(
          onPresence: (event) {
            if (!mounted) {
              return;
            }
            ref
                .read(friendsPresenceNotifierProvider.notifier)
                .applyPresenceEvent(event);
          },
        );
    _unsubscribeFriendPresence = ref
        .read(subscribeFriendPresenceRealtimeUseCaseProvider)
        .unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    final checkinState = ref.watch(homeCheckinNotifierProvider);
    final streakDays = checkinState.streakDays;
    final unreadByGroupId = ref.watch(homeUnreadMessageCountsProvider);
    final unreadMessageCount = unreadByGroupId.values.fold<int>(
      0,
      (sum, item) => sum + item,
    );

    return PageView(
      controller: _horizontalController,
      children: [
        HomeKeepAlivePage(
          child: ProfilePage(
            onBackToHome: () => _animateToPage(_homePageIndex),
          ),
        ),
        HomeKeepAlivePage(
          child: HomeCenterScaffold(
            onOpenProfile: () => _animateToPage(_profilePageIndex),
            onOpenMessages: () => _animateToPage(_messagePageIndex),
            streakDays: streakDays,
            unreadMessages: unreadMessageCount,
            targetPostId: widget.targetPostId,
          ),
        ),
        HomeKeepAlivePage(
          child: MessageGroupListPage(
            onBackToHome: () => _animateToPage(_homePageIndex),
          ),
        ),
      ],
    );
  }
}
