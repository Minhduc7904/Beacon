import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../auth/presentation/pages/profile/profile_page.dart';
import '../../../feed/presentation/pages/feed_page.dart';
import '../../../message_groups/presentation/pages/message_group_list_page.dart';
import '../widgets/home/home_center_scaffold.dart';
import '../widgets/home/home_keep_alive_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, this.autoCaptureOnOpen = false});

  final bool autoCaptureOnOpen;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  static const int _streakDays = 36;
  static const int _unreadMessageCount = 2;
  static const int _profilePageIndex = 0;
  static const int _homePageIndex = 1;
  static const int _messagePageIndex = 2;

  late final PageController _horizontalController;
  AppLifecycleState? _lastLifecycleState;

  @override
  void initState() {
    super.initState();
    _horizontalController = PageController(initialPage: _homePageIndex);
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final profile = ref.read(meProfileProvider).valueOrNull;
      if (profile == null) {
        ref.read(meProfileProvider.notifier).fetchProfile();
      }

      ref.read(homeCheckinNotifierProvider.notifier).load();
      ref.read(feedProvider.notifier).load();
    });
  }

  @override
  void dispose() {
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
    }
    _lastLifecycleState = state;
  }

  Future<void> _animateToPage(int page) {
    return _horizontalController.animateToPage(
      page,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
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
            streakDays: _streakDays,
            unreadMessages: _unreadMessageCount,
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
