import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/button/icon_circle_button.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../auth/presentation/pages/profile/profile_page.dart';
import '../../../feed/presentation/pages/feed_page.dart';
import '../../../message_groups/presentation/pages/message_group_list_page.dart';
import '../widgets/home/home_body.dart';
import '../widgets/home/home_streak_chip.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, this.autoCaptureOnOpen = false});

  final bool autoCaptureOnOpen;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  static const int _streakDays = 7;
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
        _KeepAlivePage(
          child: ProfilePage(
            onBackToHome: () => _animateToPage(_homePageIndex),
          ),
        ),
        _KeepAlivePage(
          child: _HomeCenterScaffold(
            onOpenProfile: () => _animateToPage(_profilePageIndex),
            onOpenMessages: () => _animateToPage(_messagePageIndex),
            streakDays: _streakDays,
          ),
        ),
        _KeepAlivePage(
          child: MessageGroupListPage(
            onBackToHome: () => _animateToPage(_homePageIndex),
          ),
        ),
      ],
    );
  }
}

class _KeepAlivePage extends StatefulWidget {
  const _KeepAlivePage({required this.child});

  final Widget child;

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage>
    with AutomaticKeepAliveClientMixin<_KeepAlivePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class _HomeCenterScaffold extends ConsumerWidget {
  const _HomeCenterScaffold({
    required this.onOpenProfile,
    required this.onOpenMessages,
    required this.streakDays,
  });

  final VoidCallback onOpenProfile;
  final VoidCallback onOpenMessages;
  final int streakDays;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(meProfileProvider).valueOrNull;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: GestureDetector(
            onTap: onOpenProfile,
            child: UserAvatar(
              avatarUrl: profile?.avatarUrl,
              givenName: profile?.givenName,
              size: 38,
            ),
          ),
        ),
        title: HomeStreakChip(days: streakDays),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconCircleButton(
              icon: Icons.chat_bubble_outline_rounded,
              size: 40,
              iconSize: 18,
              backgroundColor: colorScheme.surface,
              borderColor: colorScheme.outline,
              iconColor: colorScheme.onSurface,
              onPressed: onOpenMessages,
            ),
          ),
        ],
      ),
      body: const SafeArea(child: HomeBody()),
    );
  }
}
