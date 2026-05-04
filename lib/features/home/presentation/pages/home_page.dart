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
  static const int _streakDays = 36;
  static const int _unreadMessageCount = 2;
  static const int _profilePageIndex = 0;
  static const int _homePageIndex = 1;

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
            onOpenMessages: () {
              ref
                  .read(appMessageProvider.notifier)
                  .addInfo('Chat sẽ sớm ra mắt');
            },
            streakDays: _streakDays,
            unreadMessages: _unreadMessageCount,
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
    required this.unreadMessages,
  });

  final VoidCallback onOpenProfile;
  final VoidCallback onOpenMessages;
  final int streakDays;
  final int unreadMessages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(meProfileProvider).valueOrNull;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: _HomeAppBarContent(
          avatarUrl: profile?.avatarUrl,
          givenName: profile?.givenName,
          streakDays: streakDays,
          unreadMessages: unreadMessages,
          onOpenProfile: onOpenProfile,
          onOpenMessages: onOpenMessages,
        ),
      ),
      body: const SafeArea(child: HomeBody()),
    );
  }
}

class _HomeAppBarContent extends StatelessWidget {
  const _HomeAppBarContent({
    required this.avatarUrl,
    required this.givenName,
    required this.streakDays,
    required this.unreadMessages,
    required this.onOpenProfile,
    required this.onOpenMessages,
  });

  final String? avatarUrl;
  final String? givenName;
  final int streakDays;
  final int unreadMessages;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenMessages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _HomeAvatarButton(
              avatarUrl: avatarUrl,
              givenName: givenName,
              onPressed: onOpenProfile,
            ),
            HomeStreakChip(days: streakDays),
            _HomeChatButton(
              unreadCount: unreadMessages,
              onPressed: onOpenMessages,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAvatarButton extends StatelessWidget {
  const _HomeAvatarButton({
    required this.avatarUrl,
    required this.givenName,
    required this.onPressed,
  });

  final String? avatarUrl;
  final String? givenName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        child: UserAvatar(
          avatarUrl: avatarUrl,
          givenName: givenName,
          size: 34,
          backgroundColor: colorScheme.surface,
        ),
      ),
    );
  }
}

class _HomeChatButton extends StatelessWidget {
  const _HomeChatButton({required this.unreadCount, required this.onPressed});

  final int unreadCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.center,
            child: IconCircleButton(
              icon: Icons.chat_bubble_outline_rounded,
              size: 42,
              iconSize: 19,
              backgroundColor: colorScheme.surface,
              borderColor: colorScheme.outline.withValues(alpha: 0.7),
              iconColor: colorScheme.onSurface,
              onPressed: onPressed,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              top: -1,
              right: -1,
              child: _UnreadBadge(count: unreadCount),
            ),
        ],
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: colorScheme.onSecondary,
      fontWeight: FontWeight.w700,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: colorScheme.secondary.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Text('$count', style: labelStyle),
    );
  }
}
